/**
 * Fetches what the availability engine needs and hands it over.
 *
 * Everything timezone- and database-shaped lives here; everything that decides
 * which slots exist lives in `engine.ts`. The split is the point: this file is
 * four queries and some date arithmetic, and can be read in a minute.
 */
import { AppointmentStatus } from '@prisma/client';

import { Config } from '../config';
import { notFound, unprocessable } from '../lib/errors';
import { prisma } from '../lib/prisma';
import {
  LocalDate,
  daysBetween,
  instantToLocalDate,
  localToInstant,
  weekdayOf,
} from '../lib/time';
import {
  AvailabilityResult,
  StylistAvailabilityInput,
  TimeWindow,
  computeAvailability,
} from './engine';

/** The statuses that occupy a chair. Must match the exclusion constraint. */
export const OCCUPYING_STATUSES: AppointmentStatus[] = [
  AppointmentStatus.PENDING,
  AppointmentStatus.CONFIRMED,
  AppointmentStatus.COMPLETED,
];

export interface AvailabilityQuery {
  serviceId: string;
  stylistId?: string | undefined;
  date: LocalDate;
  /** Overridable so tests and reschedules can reason about a fixed clock. */
  now?: Date;
  /**
   * An appointment to pretend does not exist. Used when rescheduling: the
   * booking being moved must not block its own new time.
   */
  ignoreAppointmentId?: string | undefined;
}

export interface AvailabilityResponse extends AvailabilityResult {
  date: LocalDate;
  service: {
    id: string;
    name: string;
    durationMinutes: number;
    priceCents: number;
  };
  /** Echoed back so the app can cache per-rule-set rather than guess. */
  rules: {
    slotStepMinutes: number;
    leadTimeMinutes: number;
    maxDaysAhead: number;
  };
}

/**
 * Rejects a date outside the open diary. Yesterday is a mistake worth naming;
 * so is a date six months out when the salon only takes bookings 60 days
 * ahead, because otherwise the app shows an empty day and no reason.
 */
export function assertWithinHorizon(date: LocalDate, now = new Date()): void {
  const today = instantToLocalDate(now, Config.booking.utcOffsetMinutes);
  const offset = daysBetween(today, date);

  if (offset < 0) {
    throw unprocessable('DATE_IN_PAST', 'That date has already passed.');
  }
  if (offset > Config.booking.maxDaysAhead) {
    throw unprocessable(
      'DATE_TOO_FAR_AHEAD',
      `Bookings open ${Config.booking.maxDaysAhead} days ahead. Please pick an earlier date.`,
    );
  }
}

export async function getAvailability(
  query: AvailabilityQuery,
): Promise<AvailabilityResponse> {
  const now = query.now ?? new Date();
  const { utcOffsetMinutes } = Config.booking;
  assertWithinHorizon(query.date, now);

  const service = await prisma.service.findFirst({
    where: { id: query.serviceId, active: true },
  });
  if (!service) {
    throw notFound('That service is not available.');
  }

  // Stylists qualified for this service — and, if one was asked for, only
  // them. An unqualified or inactive stylist yields no slots rather than an
  // error, so the app can keep a stale selection on screen without crashing.
  const stylists = await prisma.stylist.findMany({
    where: {
      active: true,
      ...(query.stylistId ? { id: query.stylistId } : {}),
      services: { some: { serviceId: service.id } },
    },
    select: { id: true },
    orderBy: { id: 'asc' },
  });
  const stylistIds = stylists.map((s) => s.id);

  const weekday = weekdayOf(query.date);
  const dayStart = localToInstant(query.date, 0, utcOffsetMinutes);
  const dayEnd = localToInstant(query.date, 24 * 60, utcOffsetMinutes);

  const business = await prisma.businessHours.findUnique({ where: { weekday } });
  const businessWindows: TimeWindow[] =
    !business || business.isClosed || business.closeMinute <= business.openMinute
      ? []
      : [
          {
            startsAt: localToInstant(query.date, business.openMinute, utcOffsetMinutes),
            endsAt: localToInstant(query.date, business.closeMinute, utcOffsetMinutes),
          },
        ];

  if (businessWindows.length === 0 || stylistIds.length === 0) {
    // Nothing to query for; let the engine name the reason.
    return respond(
      computeAvailability({
        businessWindows,
        stylists: stylistIds.map((id) => ({
          stylistId: id,
          workingWindows: [],
          busyWindows: [],
        })),
        serviceDurationMinutes: service.durationMinutes,
        slotStepMinutes: Config.booking.slotStepMinutes,
        leadTimeMinutes: Config.booking.leadTimeMinutes,
        now,
      }),
      query.date,
      service,
    );
  }

  const [schedules, timeOff, appointments] = await Promise.all([
    prisma.stylistSchedule.findMany({
      where: { stylistId: { in: stylistIds }, weekday },
      orderBy: { startMinute: 'asc' },
    }),
    // Any time off touching the day at all, not only time off starting on it.
    prisma.timeOff.findMany({
      where: {
        stylistId: { in: stylistIds },
        startsAt: { lt: dayEnd },
        endsAt: { gt: dayStart },
      },
    }),
    prisma.appointment.findMany({
      where: {
        stylistId: { in: stylistIds },
        status: { in: OCCUPYING_STATUSES },
        startsAt: { lt: dayEnd },
        endsAt: { gt: dayStart },
        ...(query.ignoreAppointmentId
          ? { id: { not: query.ignoreAppointmentId } }
          : {}),
      },
      select: { stylistId: true, startsAt: true, endsAt: true },
    }),
  ]);

  const engineInput: StylistAvailabilityInput[] = stylistIds.map((id) => ({
    stylistId: id,
    workingWindows: schedules
      .filter((s) => s.stylistId === id && s.endMinute > s.startMinute)
      .map((s) => ({
        startsAt: localToInstant(query.date, s.startMinute, utcOffsetMinutes),
        endsAt: localToInstant(query.date, s.endMinute, utcOffsetMinutes),
      })),
    busyWindows: [
      ...timeOff.filter((t) => t.stylistId === id),
      ...appointments.filter((a) => a.stylistId === id),
    ].map((w) => ({ startsAt: w.startsAt, endsAt: w.endsAt })),
  }));

  return respond(
    computeAvailability({
      businessWindows,
      stylists: engineInput,
      serviceDurationMinutes: service.durationMinutes,
      slotStepMinutes: Config.booking.slotStepMinutes,
      leadTimeMinutes: Config.booking.leadTimeMinutes,
      now,
    }),
    query.date,
    service,
  );
}

function respond(
  result: AvailabilityResult,
  date: LocalDate,
  service: { id: string; name: string; durationMinutes: number; priceCents: number },
): AvailabilityResponse {
  return {
    ...result,
    date,
    service: {
      id: service.id,
      name: service.name,
      durationMinutes: service.durationMinutes,
      priceCents: service.priceCents,
    },
    rules: {
      slotStepMinutes: Config.booking.slotStepMinutes,
      leadTimeMinutes: Config.booking.leadTimeMinutes,
      maxDaysAhead: Config.booking.maxDaysAhead,
    },
  };
}
