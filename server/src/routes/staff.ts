/**
 * The staff-side views: one stylist's day, and the owner's whole-salon day.
 *
 * `GET /staff/agenda?date=` is what a stylist opens in the morning. It answers
 * the three questions they actually have — who is coming, when, and where the
 * gaps are — in one call, because a phone on salon wifi should not need four.
 */
import { Role } from '@prisma/client';
import { Router } from 'express';
import { z } from 'zod';

import { OCCUPYING_STATUSES } from '../availability/service';
import { Config } from '../config';
import { forbidden } from '../lib/errors';
import { asyncHandler, ok, parseQuery } from '../lib/http';
import { prisma } from '../lib/prisma';
import { appointmentPublic, timeOffPublic } from '../lib/serialize';
import {
  instantToLocalDate,
  isValidLocalDate,
  localToInstant,
  minuteOfDayToLabel,
  weekdayOf,
} from '../lib/time';
import { authed, requireAuth, requireStaff } from '../middleware/auth';

export const staffRouter = Router();

const agendaQuery = z.object({
  date: z
    .string()
    .refine(isValidLocalDate, 'date must be a real date in YYYY-MM-DD form.')
    .optional(),
  /** The owner may look at any stylist's day; a stylist may only see their own. */
  stylistId: z.string().uuid().optional(),
});

staffRouter.get(
  '/agenda',
  requireAuth,
  requireStaff,
  asyncHandler(async (req, res) => {
    const claims = authed(req);
    const query = parseQuery(agendaQuery, req);
    const { utcOffsetMinutes } = Config.booking;

    const date = query.date ?? instantToLocalDate(new Date(), utcOffsetMinutes);
    const dayStart = localToInstant(date, 0, utcOffsetMinutes);
    const dayEnd = localToInstant(date, 24 * 60, utcOffsetMinutes);

    let stylistId: string | null;
    if (claims.role === Role.OWNER) {
      // No stylistId means the whole salon, which is the owner's default view.
      stylistId = query.stylistId ?? null;
    } else {
      if (query.stylistId && query.stylistId !== claims.stylistId) {
        throw forbidden('You can only see your own agenda.');
      }
      if (!claims.stylistId) {
        throw forbidden('You do not have a stylist profile.');
      }
      stylistId = claims.stylistId;
    }

    const weekday = weekdayOf(date);
    const [business, appointments, timeOff, schedules] = await Promise.all([
      prisma.businessHours.findUnique({ where: { weekday } }),
      prisma.appointment.findMany({
        where: {
          ...(stylistId ? { stylistId } : {}),
          startsAt: { lt: dayEnd },
          endsAt: { gt: dayStart },
        },
        include: {
          service: true,
          user: { select: { id: true, fullName: true, email: true, phone: true } },
          stylist: {
            include: { user: { select: { id: true, fullName: true, email: true, phone: true } } },
          },
        },
        orderBy: { startsAt: 'asc' },
      }),
      prisma.timeOff.findMany({
        where: {
          ...(stylistId ? { stylistId } : {}),
          startsAt: { lt: dayEnd },
          endsAt: { gt: dayStart },
        },
        orderBy: { startsAt: 'asc' },
      }),
      prisma.stylistSchedule.findMany({
        where: { ...(stylistId ? { stylistId } : {}), weekday },
        orderBy: [{ stylistId: 'asc' }, { startMinute: 'asc' }],
      }),
    ]);

    // Cancellations and no-shows stay in the list — a stylist wants to see
    // that the 14:00 cancelled rather than silently find a gap — but they are
    // not counted as booked time or revenue.
    const booked = appointments.filter((a) =>
      (OCCUPYING_STATUSES as string[]).includes(a.status),
    );

    ok(res, {
      date,
      weekday,
      stylistId,
      businessHours: business
        ? {
            isClosed: business.isClosed,
            openTime: minuteOfDayToLabel(business.openMinute),
            closeTime: minuteOfDayToLabel(business.closeMinute),
          }
        : null,
      workingHours: schedules.map((s) => ({
        stylistId: s.stylistId,
        startTime: minuteOfDayToLabel(s.startMinute),
        endTime: minuteOfDayToLabel(s.endMinute),
      })),
      appointments: appointments.map(appointmentPublic),
      timeOff: timeOff.map(timeOffPublic),
      summary: {
        total: appointments.length,
        booked: booked.length,
        bookedMinutes: booked.reduce((sum, a) => sum + a.durationMinutes, 0),
        expectedRevenueCents: booked.reduce((sum, a) => sum + a.priceCents, 0),
        byStatus: appointments.reduce<Record<string, number>>((acc, a) => {
          acc[a.status] = (acc[a.status] ?? 0) + 1;
          return acc;
        }, {}),
      },
    });
  }),
);

export default staffRouter;
