/**
 * The team, and the two things a stylist maintains about themselves: their
 * weekly working hours and their time off.
 *
 * `PUT /stylists/me/schedule` replaces the whole week in one transaction
 * rather than accepting per-day edits. A roster is read as a whole ("I work
 * Tuesday to Saturday"), and a replace cannot leave the week half-updated if
 * the connection drops between two calls.
 */
import { Router } from 'express';
import { z } from 'zod';

import { badRequest, forbidden, notFound } from '../lib/errors';
import { asyncHandler, created, ok, parseBody, parseQuery } from '../lib/http';
import { prisma } from '../lib/prisma';
import {
  reviewPublic,
  schedulePublic,
  stylistPublic,
  timeOffPublic,
} from '../lib/serialize';
import { MINUTES_PER_DAY } from '../lib/time';
import { authed, requireAuth, requireStaff } from '../middleware/auth';

export const stylistsRouter = Router();

const listQuery = z.object({
  /** Narrow the team to whoever performs this service. */
  serviceId: z.string().uuid().optional(),
  includeInactive: z.enum(['true', 'false']).optional(),
});

const scheduleRowSchema = z
  .object({
    weekday: z.number().int().min(0).max(6),
    startMinute: z.number().int().min(0).max(MINUTES_PER_DAY),
    endMinute: z.number().int().min(0).max(MINUTES_PER_DAY),
  })
  .refine((row) => row.endMinute > row.startMinute, {
    message: 'A shift must end after it starts.',
    path: ['endMinute'],
  });

const scheduleSchema = z.object({
  /**
   * The complete week. Several rows may share a weekday, which is how a lunch
   * break is expressed: two shifts with a gap between them.
   */
  schedule: z.array(scheduleRowSchema).max(50),
});

const timeOffSchema = z
  .object({
    startsAt: z.string().datetime({ offset: true }),
    endsAt: z.string().datetime({ offset: true }),
    reason: z.string().trim().max(300).optional(),
  })
  .refine((body) => new Date(body.endsAt) > new Date(body.startsAt), {
    message: 'Time off must end after it starts.',
    path: ['endsAt'],
  });

const profileSchema = z.object({
  title: z.string().trim().min(2).max(120).optional(),
  specialization: z.string().trim().min(2).max(160).optional(),
  bio: z.string().trim().max(2000).optional().nullable(),
  experienceYears: z.number().int().min(0).max(80).optional(),
  imageAsset: z.string().trim().max(300).optional().nullable(),
});

stylistsRouter.get(
  '/',
  asyncHandler(async (req, res) => {
    const query = parseQuery(listQuery, req);
    const stylists = await prisma.stylist.findMany({
      where: {
        ...(query.includeInactive === 'true' ? {} : { active: true }),
        ...(query.serviceId
          ? { services: { some: { serviceId: query.serviceId } } }
          : {}),
      },
      include: {
        user: { select: { id: true, fullName: true, email: true, phone: true } },
        services: { include: { service: true } },
      },
      orderBy: [{ title: 'asc' }],
    });

    ok(res, { stylists: stylists.map(stylistPublic) });
  }),
);

/**
 * Mounted before `/:id` on purpose: Express matches in order, and `me` would
 * otherwise be parsed as an id and 404 on a uuid check.
 */
stylistsRouter.get(
  '/me',
  requireAuth,
  requireStaff,
  asyncHandler(async (req, res) => {
    ok(res, stylistPublic(await myStylist(req)));
  }),
);

stylistsRouter.patch(
  '/me',
  requireAuth,
  requireStaff,
  asyncHandler(async (req, res) => {
    const body = parseBody(profileSchema, req);
    const mine = await myStylist(req);

    const updated = await prisma.stylist.update({
      where: { id: mine.id },
      data: {
        ...(body.title === undefined ? {} : { title: body.title }),
        ...(body.specialization === undefined
          ? {}
          : { specialization: body.specialization }),
        ...(body.bio === undefined ? {} : { bio: body.bio }),
        ...(body.experienceYears === undefined
          ? {}
          : { experienceYears: body.experienceYears }),
        ...(body.imageAsset === undefined ? {} : { imageAsset: body.imageAsset }),
      },
      include: {
        user: { select: { id: true, fullName: true, email: true, phone: true } },
        schedules: true,
      },
    });

    ok(res, stylistPublic(updated));
  }),
);

stylistsRouter.put(
  '/me/schedule',
  requireAuth,
  requireStaff,
  asyncHandler(async (req, res) => {
    const { schedule } = parseBody(scheduleSchema, req);
    const mine = await myStylist(req);

    // Two shifts on the same day must not overlap each other, or the engine
    // would offer the same minute twice. Caught here rather than in the
    // engine, which is entitled to assume a coherent roster.
    for (let weekday = 0; weekday <= 6; weekday += 1) {
      const rows = schedule
        .filter((row) => row.weekday === weekday)
        .sort((a, b) => a.startMinute - b.startMinute);
      for (let i = 1; i < rows.length; i += 1) {
        if (rows[i].startMinute < rows[i - 1].endMinute) {
          throw badRequest(
            `Two shifts overlap on weekday ${weekday}. Please make them separate blocks.`,
          );
        }
      }
    }

    // Replace the week atomically: a failed write leaves the old roster, never
    // a partial one.
    const rows = await prisma.$transaction(async (tx) => {
      await tx.stylistSchedule.deleteMany({ where: { stylistId: mine.id } });
      if (schedule.length > 0) {
        await tx.stylistSchedule.createMany({
          data: schedule.map((row) => ({ ...row, stylistId: mine.id })),
        });
      }
      return tx.stylistSchedule.findMany({
        where: { stylistId: mine.id },
        orderBy: [{ weekday: 'asc' }, { startMinute: 'asc' }],
      });
    });

    ok(res, { stylistId: mine.id, schedule: rows.map(schedulePublic) });
  }),
);

stylistsRouter.get(
  '/me/time-off',
  requireAuth,
  requireStaff,
  asyncHandler(async (req, res) => {
    const mine = await myStylist(req);
    const rows = await prisma.timeOff.findMany({
      where: { stylistId: mine.id, endsAt: { gte: new Date() } },
      orderBy: { startsAt: 'asc' },
    });
    ok(res, { timeOff: rows.map(timeOffPublic) });
  }),
);

stylistsRouter.post(
  '/me/time-off',
  requireAuth,
  requireStaff,
  asyncHandler(async (req, res) => {
    const body = parseBody(timeOffSchema, req);
    const mine = await myStylist(req);

    const startsAt = new Date(body.startsAt);
    const endsAt = new Date(body.endsAt);

    // Booking over time off is prevented by availability; time off over an
    // existing booking is not, so it is reported rather than silently
    // creating a double-commitment the stylist will not notice until the day.
    const clashes = await prisma.appointment.findMany({
      where: {
        stylistId: mine.id,
        status: { in: ['PENDING', 'CONFIRMED'] },
        startsAt: { lt: endsAt },
        endsAt: { gt: startsAt },
      },
      select: { id: true, startsAt: true, endsAt: true },
    });

    const row = await prisma.timeOff.create({
      data: { stylistId: mine.id, startsAt, endsAt, reason: body.reason ?? null },
    });

    created(res, {
      ...timeOffPublic(row),
      // Non-empty means "these clients still think they have an appointment".
      clashingAppointments: clashes.map((c) => ({
        id: c.id,
        startsAt: c.startsAt.toISOString(),
        endsAt: c.endsAt.toISOString(),
      })),
    });
  }),
);

stylistsRouter.delete(
  '/me/time-off/:id',
  requireAuth,
  requireStaff,
  asyncHandler(async (req, res) => {
    const mine = await myStylist(req);
    const deleted = await prisma.timeOff.deleteMany({
      where: { id: req.params.id, stylistId: mine.id },
    });
    if (deleted.count === 0) throw notFound('That time off does not exist.');
    ok(res, { ok: true, deleted: true, id: req.params.id });
  }),
);

stylistsRouter.get(
  '/:id',
  asyncHandler(async (req, res) => {
    const stylist = await prisma.stylist.findUnique({
      where: { id: req.params.id },
      include: {
        user: { select: { id: true, fullName: true, email: true, phone: true } },
        services: { include: { service: true } },
        schedules: { orderBy: [{ weekday: 'asc' }, { startMinute: 'asc' }] },
        reviews: {
          take: 10,
          orderBy: { createdAt: 'desc' },
          include: { user: { select: { fullName: true } } },
        },
      },
    });
    if (!stylist) throw notFound('That stylist does not exist.');

    ok(res, {
      ...stylistPublic(stylist),
      reviews: stylist.reviews.map(reviewPublic),
    });
  }),
);

/** The caller's own stylist profile, or a clear error if they have none. */
async function myStylist(req: Parameters<typeof authed>[0]) {
  const claims = authed(req);
  const stylist = await prisma.stylist.findUnique({
    where: { userId: claims.sub },
    include: {
      user: { select: { id: true, fullName: true, email: true, phone: true } },
      schedules: { orderBy: [{ weekday: 'asc' }, { startMinute: 'asc' }] },
    },
  });
  if (!stylist) {
    // The owner is staff but need not be a bookable stylist, so this is a
    // real case rather than an impossible one.
    throw forbidden('You do not have a stylist profile.');
  }
  return stylist;
}
