/**
 * Bookings: create, list, read, reschedule, cancel, and the staff transitions.
 *
 * ### How double-booking is prevented
 *
 * Not by checking. A handler that reads "is 10:00 free?" and then writes the
 * booking has a gap between the two, and two phones tapping the same slot at
 * the same moment both read "free" and both write. That is not a rare race —
 * it is exactly what happens when a salon posts a promotion.
 *
 * So the guarantee lives in the database. `Appointment` carries a PostgreSQL
 * exclusion constraint:
 *
 *     EXCLUDE USING gist (
 *       "stylistId" WITH =,
 *       tstzrange("startsAt", "endsAt", '[)') WITH &&
 *     ) WHERE (status NOT IN ('CANCELLED', 'NO_SHOW'))
 *
 * Two overlapping bookings for one stylist cannot both exist, whatever the
 * application does, whatever order the requests arrive in, however many
 * instances of this server are running. The loser's `INSERT` is rejected by
 * Postgres with SQLSTATE 23P01, which this file turns into a 409 `SLOT_TAKEN`
 * — a specific code the booking screen shows as "that slot was just taken".
 *
 * A second constraint does the same for the client, so one person cannot hold
 * two appointments at once with two different stylists.
 *
 * The availability check that still runs before the write is a *policy* check,
 * not a lock. It rejects 03:00, off-grid times, a stylist who does not work
 * Tuesdays, and a service that stylist does not perform. Those are wrong no
 * matter who else is booking; the constraint handles the one case that depends
 * on timing.
 *
 * Both writes go through `withBookingLock`, which exists because PostgreSQL
 * resolves *simultaneous* conflicting inserts against an exclusion constraint
 * by deadlocking rather than by raising 23P01. That file explains it; the
 * short version is that the lock turns the race into a queue so the loser gets
 * a clean `SLOT_TAKEN` instead of a deadlock, and the constraint remains the
 * thing that actually guarantees correctness.
 */
import { AppointmentStatus, Prisma, Role } from '@prisma/client';
import { Router } from 'express';
import { z } from 'zod';

import { isOfferedSlot } from '../availability/engine';
import { OCCUPYING_STATUSES, getAvailability } from '../availability/service';
import { Config } from '../config';
import {
  badRequest,
  clientDoubleBooked,
  forbidden,
  isClientOverlapError,
  isOverlapError,
  notFound,
  slotTaken,
  unprocessable,
} from '../lib/errors';
import { withBookingLock } from '../lib/booking-tx';
import { asyncHandler, created, ok, parseBody, parseQuery } from '../lib/http';
import { prisma } from '../lib/prisma';
import { appointmentPublic, reviewPublic } from '../lib/serialize';
import { instantToLocalDate, isValidLocalDate, localToInstant } from '../lib/time';
import {
  assertCanActOn,
  authed,
  isStaff,
  requireAuth,
  requireStaff,
} from '../middleware/auth';

export const appointmentsRouter = Router();

const isoInstant = z.string().datetime({ offset: true });

const createSchema = z.object({
  serviceId: z.string().uuid(),
  /** Omit to let the salon assign whoever is free. */
  stylistId: z.string().uuid().optional(),
  startsAt: isoInstant,
  notes: z.string().trim().max(1000).optional(),
});

const rescheduleSchema = z
  .object({
    startsAt: isoInstant.optional(),
    stylistId: z.string().uuid().optional(),
    notes: z.string().trim().max(1000).optional().nullable(),
  })
  .refine(
    (body) =>
      body.startsAt !== undefined ||
      body.stylistId !== undefined ||
      body.notes !== undefined,
    { message: 'Nothing to change.' },
  );

const cancelSchema = z.object({
  reason: z.string().trim().max(300).optional(),
});

const listQuery = z.object({
  status: z
    .string()
    .optional()
    .transform((v) => (v ? v.split(',').map((s) => s.trim().toUpperCase()) : undefined))
    .refine(
      (list) =>
        !list ||
        list.every((s) => (Object.values(AppointmentStatus) as string[]).includes(s)),
      'Unknown status.',
    ),
  /** Inclusive local date bounds; `to` covers the whole day. */
  from: z.string().refine(isValidLocalDate, 'from must be YYYY-MM-DD.').optional(),
  to: z.string().refine(isValidLocalDate, 'to must be YYYY-MM-DD.').optional(),
  /** Owner-only narrowing; ignored for everyone else. */
  stylistId: z.string().uuid().optional(),
  userId: z.string().uuid().optional(),
  scope: z.enum(['upcoming', 'past', 'all']).optional(),
  limit: z.coerce.number().int().min(1).max(200).optional(),
  cursor: z.string().uuid().optional(),
});

const reviewSchema = z.object({
  rating: z.number().int().min(1).max(5),
  comment: z.string().trim().max(1000).optional(),
});

// -------------------------------------------------------------- create ---

appointmentsRouter.post(
  '/',
  requireAuth,
  asyncHandler(async (req, res) => {
    const claims = authed(req);
    const body = parseBody(createSchema, req);

    const startsAt = new Date(body.startsAt);
    if (Number.isNaN(startsAt.getTime())) {
      throw badRequest('startsAt is not a valid timestamp.');
    }

    const date = instantToLocalDate(startsAt, Config.booking.utcOffsetMinutes);
    const availability = await getAvailability({
      serviceId: body.serviceId,
      stylistId: body.stylistId,
      date,
    });

    const stylistId = await resolveStylist(availability, startsAt, body.stylistId);
    const endsAt = new Date(
      startsAt.getTime() + availability.service.durationMinutes * 60_000,
    );

    try {
      const appointment = await withBookingLock(
        { stylistId, userId: claims.sub },
        (tx) =>
          tx.appointment.create({
            data: {
              userId: claims.sub,
              stylistId,
              serviceId: availability.service.id,
              startsAt,
              endsAt,
              status: AppointmentStatus.PENDING,
              // Copied, not referenced: repricing the catalogue tomorrow must
              // not reprice a booking already in the diary.
              priceCents: availability.service.priceCents,
              durationMinutes: availability.service.durationMinutes,
              notes: body.notes ?? null,
            },
            include: {
              service: true,
              stylist: {
                include: {
                  user: { select: { id: true, fullName: true, email: true, phone: true } },
                },
              },
            },
          }),
      );

      created(res, appointmentPublic(appointment));
    } catch (error) {
      throw translateOverlap(error, { startsAt, endsAt, stylistId });
    }
  }),
);

// ---------------------------------------------------------------- read ---

appointmentsRouter.get(
  '/',
  requireAuth,
  asyncHandler(async (req, res) => {
    const claims = authed(req);
    const query = parseQuery(listQuery, req);
    const { utcOffsetMinutes } = Config.booking;
    const limit = query.limit ?? 50;

    // Role scoping, in one place. A client sees their own bookings; a stylist
    // sees the ones in their own chair; the owner sees the whole diary and may
    // narrow it.
    const scope: Prisma.AppointmentWhereInput = (() => {
      if (claims.role === Role.OWNER) {
        return {
          ...(query.stylistId ? { stylistId: query.stylistId } : {}),
          ...(query.userId ? { userId: query.userId } : {}),
        };
      }
      if (claims.role === Role.STYLIST && claims.stylistId) {
        // A stylist is also a person who can book a haircut, so their own
        // client bookings belong in their list too.
        return {
          OR: [{ stylistId: claims.stylistId }, { userId: claims.sub }],
        };
      }
      return { userId: claims.sub };
    })();

    const now = new Date();
    const timeFilter: Prisma.AppointmentWhereInput = {
      ...(query.from
        ? { startsAt: { gte: localToInstant(query.from, 0, utcOffsetMinutes) } }
        : {}),
      ...(query.to
        ? {
            endsAt: {
              lte: localToInstant(query.to, 24 * 60, utcOffsetMinutes),
            },
          }
        : {}),
    };

    const scopeFilter: Prisma.AppointmentWhereInput =
      query.scope === 'upcoming'
        ? { startsAt: { gte: now } }
        : query.scope === 'past'
          ? { startsAt: { lt: now } }
          : {};

    const where: Prisma.AppointmentWhereInput = {
      AND: [
        scope,
        timeFilter,
        scopeFilter,
        query.status ? { status: { in: query.status as AppointmentStatus[] } } : {},
      ],
    };

    const rows = await prisma.appointment.findMany({
      where,
      include: {
        service: true,
        stylist: {
          include: { user: { select: { id: true, fullName: true, email: true, phone: true } } },
        },
        // Staff need to know who is walking in; clients already know.
        ...(isStaff(claims)
          ? { user: { select: { id: true, fullName: true, email: true, phone: true } } }
          : {}),
        review: true,
      },
      orderBy: query.scope === 'past' ? { startsAt: 'desc' } : { startsAt: 'asc' },
      take: limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
    });

    const page = rows.slice(0, limit);
    ok(res, {
      appointments: page.map(appointmentPublic),
      nextCursor: rows.length > limit ? page[page.length - 1]?.id ?? null : null,
    });
  }),
);

appointmentsRouter.get(
  '/:id',
  requireAuth,
  asyncHandler(async (req, res) => {
    const claims = authed(req);
    const appointment = await prisma.appointment.findUnique({
      where: { id: req.params.id },
      include: {
        service: true,
        stylist: {
          include: { user: { select: { id: true, fullName: true, email: true, phone: true } } },
        },
        user: { select: { id: true, fullName: true, email: true, phone: true } },
        review: true,
      },
    });
    if (!appointment) throw notFound('That appointment does not exist.');
    assertCanActOn(claims, appointment);

    // A client has no business seeing the client block of their own booking
    // repeated back; staff do.
    const payload = appointmentPublic(
      isStaff(claims) ? appointment : { ...appointment, user: null },
    );
    ok(res, payload);
  }),
);

// ---------------------------------------------------------- reschedule ---

appointmentsRouter.patch(
  '/:id',
  requireAuth,
  asyncHandler(async (req, res) => {
    const claims = authed(req);
    const body = parseBody(rescheduleSchema, req);

    const existing = await prisma.appointment.findUnique({
      where: { id: req.params.id },
      include: { service: true },
    });
    if (!existing) throw notFound('That appointment does not exist.');
    assertCanActOn(claims, existing);

    if (
      existing.status === AppointmentStatus.CANCELLED ||
      existing.status === AppointmentStatus.COMPLETED ||
      existing.status === AppointmentStatus.NO_SHOW
    ) {
      throw unprocessable(
        'APPOINTMENT_CLOSED',
        'That appointment can no longer be changed.',
      );
    }

    // Notes-only edit: no availability question to answer.
    if (body.startsAt === undefined && body.stylistId === undefined) {
      const updated = await prisma.appointment.update({
        where: { id: existing.id },
        data: { notes: body.notes ?? null },
        include: { service: true, stylist: { include: { user: { select: { id: true, fullName: true, email: true, phone: true } } } } },
      });
      ok(res, appointmentPublic(updated));
      return;
    }

    const startsAt = body.startsAt ? new Date(body.startsAt) : existing.startsAt;
    const date = instantToLocalDate(startsAt, Config.booking.utcOffsetMinutes);

    // A client moving their own booking must land on a slot that is genuinely
    // offered; `ignoreAppointmentId` stops the booking being moved from
    // blocking its own new time.
    const availability = await getAvailability({
      serviceId: existing.serviceId,
      stylistId: body.stylistId ?? existing.stylistId,
      date,
      ignoreAppointmentId: existing.id,
    });

    const stylistId = await resolveStylist(
      availability,
      startsAt,
      body.stylistId ?? existing.stylistId,
      existing.id,
    );
    const endsAt = new Date(
      startsAt.getTime() + availability.service.durationMinutes * 60_000,
    );

    try {
      // The same lock and the same constraint as a fresh booking: moving an
      // appointment onto an occupied slot has to fail exactly as booking one
      // would.
      const updated = await withBookingLock(
        { stylistId, userId: existing.userId },
        (tx) =>
          tx.appointment.update({
            where: { id: existing.id },
            data: {
              startsAt,
              endsAt,
              stylistId,
              durationMinutes: availability.service.durationMinutes,
              ...(body.notes === undefined ? {} : { notes: body.notes }),
              // A rescheduled booking needs confirming again: the stylist
              // agreed to the old time, not this one.
              status: AppointmentStatus.PENDING,
            },
            include: {
              service: true,
              stylist: {
                include: {
                  user: { select: { id: true, fullName: true, email: true, phone: true } },
                },
              },
            },
          }),
      );
      ok(res, appointmentPublic(updated));
    } catch (error) {
      throw translateOverlap(error, { startsAt, endsAt, stylistId });
    }
  }),
);

// -------------------------------------------------------------- cancel ---

appointmentsRouter.post(
  '/:id/cancel',
  requireAuth,
  asyncHandler(async (req, res) => {
    const claims = authed(req);
    const body = parseBody(cancelSchema, req);

    const existing = await prisma.appointment.findUnique({
      where: { id: req.params.id },
    });
    if (!existing) throw notFound('That appointment does not exist.');
    assertCanActOn(claims, existing);

    if (existing.status === AppointmentStatus.CANCELLED) {
      // Idempotent: tapping cancel twice on a slow connection is not an error.
      ok(res, appointmentPublic(existing));
      return;
    }
    if (
      existing.status === AppointmentStatus.COMPLETED ||
      existing.status === AppointmentStatus.NO_SHOW
    ) {
      throw unprocessable(
        'APPOINTMENT_CLOSED',
        'That appointment has already happened.',
      );
    }

    // The cancellation window applies to clients only. The salon can always
    // cancel — a stylist off sick at 8am has to be able to clear their day.
    if (!isStaff(claims)) {
      const windowMs = Config.booking.cancellationWindowHours * 3_600_000;
      const noticeMs = existing.startsAt.getTime() - Date.now();
      if (noticeMs < windowMs) {
        throw unprocessable(
          'CANCELLATION_WINDOW_PASSED',
          `Appointments can only be cancelled more than ${Config.booking.cancellationWindowHours} hours ahead. Please call the salon on ${Config.salon.phone}.`,
        );
      }
    }

    const updated = await prisma.appointment.update({
      where: { id: existing.id },
      data: {
        status: AppointmentStatus.CANCELLED,
        cancelledAt: new Date(),
        cancelledByUserId: claims.sub,
        cancellationReason: body.reason ?? null,
      },
      include: {
        service: true,
        stylist: { include: { user: { select: { id: true, fullName: true, email: true, phone: true } } } },
      },
    });

    // The slot is free again the instant this returns: CANCELLED is outside
    // the exclusion constraint's predicate and outside OCCUPYING_STATUSES, so
    // the next availability call offers it without any extra bookkeeping.
    ok(res, appointmentPublic(updated));
  }),
);

// ------------------------------------------------- staff state changes ---

/**
 * The three transitions only the salon may make. One factory rather than three
 * near-identical handlers, so the ownership rule and the legal-transition
 * table are each written once.
 */
function staffTransition(
  path: string,
  next: AppointmentStatus,
  allowedFrom: AppointmentStatus[],
  rejection: string,
) {
  appointmentsRouter.post(
    `/:id/${path}`,
    requireAuth,
    requireStaff,
    asyncHandler(async (req, res) => {
      const claims = authed(req);
      const existing = await prisma.appointment.findUnique({
        where: { id: req.params.id },
      });
      if (!existing) throw notFound('That appointment does not exist.');

      // A stylist may only touch their own chair; the owner, anyone's.
      if (
        claims.role === Role.STYLIST &&
        existing.stylistId !== claims.stylistId
      ) {
        throw forbidden('That appointment belongs to another stylist.');
      }

      if (!allowedFrom.includes(existing.status)) {
        throw unprocessable('INVALID_TRANSITION', rejection);
      }

      const updated = await prisma.appointment.update({
        where: { id: existing.id },
        data: { status: next },
        include: {
          service: true,
          stylist: { include: { user: { select: { id: true, fullName: true, email: true, phone: true } } } },
          user: { select: { id: true, fullName: true, email: true, phone: true } },
        },
      });
      ok(res, appointmentPublic(updated));
    }),
  );
}

staffTransition(
  'confirm',
  AppointmentStatus.CONFIRMED,
  [AppointmentStatus.PENDING],
  'Only a pending appointment can be confirmed.',
);
staffTransition(
  'complete',
  AppointmentStatus.COMPLETED,
  [AppointmentStatus.PENDING, AppointmentStatus.CONFIRMED],
  'Only a pending or confirmed appointment can be completed.',
);
staffTransition(
  'no-show',
  AppointmentStatus.NO_SHOW,
  [AppointmentStatus.PENDING, AppointmentStatus.CONFIRMED],
  'Only a pending or confirmed appointment can be marked a no-show.',
);

// -------------------------------------------------------------- review ---

appointmentsRouter.post(
  '/:id/review',
  requireAuth,
  asyncHandler(async (req, res) => {
    const claims = authed(req);
    const body = parseBody(reviewSchema, req);

    const appointment = await prisma.appointment.findUnique({
      where: { id: req.params.id },
      include: { review: true },
    });
    if (!appointment) throw notFound('That appointment does not exist.');
    if (appointment.userId !== claims.sub) {
      throw forbidden('You can only review your own appointments.');
    }
    if (appointment.status !== AppointmentStatus.COMPLETED) {
      throw unprocessable(
        'NOT_COMPLETED',
        'You can review an appointment once it has been completed.',
      );
    }
    if (appointment.review) {
      throw unprocessable('ALREADY_REVIEWED', 'You have already reviewed that appointment.');
    }

    // Write the review and recompute the stylist's rating together, so the
    // displayed average can never disagree with the reviews behind it.
    const review = await prisma.$transaction(async (tx) => {
      const row = await tx.review.create({
        data: {
          appointmentId: appointment.id,
          userId: claims.sub,
          stylistId: appointment.stylistId,
          rating: body.rating,
          comment: body.comment ?? null,
        },
        include: { user: { select: { fullName: true } } },
      });

      const stats = await tx.review.aggregate({
        where: { stylistId: appointment.stylistId },
        _avg: { rating: true },
        _count: { _all: true },
      });
      await tx.stylist.update({
        where: { id: appointment.stylistId },
        data: {
          rating: Math.round((stats._avg.rating ?? 0) * 10) / 10,
          reviewCount: stats._count._all,
        },
      });
      return row;
    });

    created(res, reviewPublic(review));
  }),
);

// ------------------------------------------------------------- helpers ---

/**
 * Confirms the requested start is a slot the engine actually offers, and
 * resolves "anyone" to a specific stylist.
 *
 * ### Why "not offered" is not one error
 *
 * A slot can fail to be on offer for two quite different reasons, and the app
 * needs to tell them apart:
 *
 *   * the request was never valid — 03:00, off the 15-minute grid, a closed
 *     day, a stylist who does not work Tuesdays. The client should go back and
 *     pick from the offered slots: 422 `SLOT_NOT_AVAILABLE`.
 *   * the slot was offered a moment ago and somebody has since taken it. The
 *     client should be told exactly that and shown what is left:
 *     409 `SLOT_TAKEN`.
 *
 * Without this distinction a lost race reports whichever code depends on
 * timing — 422 when the winner committed before this request read
 * availability, 409 when it committed after — and the Flutter layer has to
 * treat two codes as one meaning. So when the slot is not offered, one extra
 * indexed query asks the question that actually matters: is there a booking in
 * the way? That query runs only on the failure path.
 */
async function resolveStylist(
  availability: Awaited<ReturnType<typeof getAvailability>>,
  startsAt: Date,
  requestedStylistId?: string,
  ignoreAppointmentId?: string,
): Promise<string> {
  const offered = isOfferedSlot(availability, startsAt, requestedStylistId ?? '');
  const slot = availability.slots.find(
    (s) => s.startsAt.getTime() === startsAt.getTime(),
  );

  if (requestedStylistId ? offered : Boolean(slot)) {
    // `stylistIds` is sorted, so "anyone" resolves the same way for the same
    // inputs — deterministic, and therefore testable.
    return requestedStylistId ?? slot!.stylistIds[0];
  }

  if (availability.reason === 'SALON_CLOSED') {
    throw unprocessable('SALON_CLOSED', 'The salon is closed that day.');
  }

  const endsAt = new Date(
    startsAt.getTime() + availability.service.durationMinutes * 60_000,
  );
  const blocking = await prisma.appointment.findFirst({
    where: {
      ...(requestedStylistId ? { stylistId: requestedStylistId } : {}),
      status: { in: OCCUPYING_STATUSES },
      startsAt: { lt: endsAt },
      endsAt: { gt: startsAt },
      ...(ignoreAppointmentId ? { id: { not: ignoreAppointmentId } } : {}),
    },
    select: { id: true },
  });

  if (blocking) {
    throw slotTaken({
      startsAt: startsAt.toISOString(),
      endsAt: endsAt.toISOString(),
      ...(requestedStylistId ? { stylistId: requestedStylistId } : {}),
    });
  }

  throw unprocessable(
    'SLOT_NOT_AVAILABLE',
    requestedStylistId
      ? 'That stylist is not available at that time. Please pick another slot.'
      : 'That time is not available. Please pick one of the offered slots.',
  );
}

/** Turns a constraint violation into the error the app knows how to show. */
function translateOverlap(
  error: unknown,
  context: { startsAt: Date; endsAt: Date; stylistId: string },
): unknown {
  if (isClientOverlapError(error)) return clientDoubleBooked();
  if (isOverlapError(error)) {
    return slotTaken({
      stylistId: context.stylistId,
      startsAt: context.startsAt.toISOString(),
      endsAt: context.endsAt.toISOString(),
    });
  }
  return error;
}
