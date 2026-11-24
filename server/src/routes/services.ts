/**
 * The service catalogue.
 *
 * Reading is public — the app shows prices on the home screen before anyone
 * signs in. Writing is the owner's alone, enforced by `requireOwner` on the
 * route rather than by a check inside each handler.
 *
 * Deleting a service that has ever been booked would orphan appointment
 * history, so `DELETE` deactivates by default and only truly deletes when
 * nothing references the row. The app sees one endpoint either way.
 */
import { Router } from 'express';
import { z } from 'zod';

import { badRequest, notFound } from '../lib/errors';
import { asyncHandler, created, ok, parseBody, parseQuery } from '../lib/http';
import { prisma } from '../lib/prisma';
import { servicePublic } from '../lib/serialize';
import { requireAuth, requireOwner } from '../middleware/auth';

export const servicesRouter = Router();

const listQuery = z.object({
  category: z.string().trim().min(1).max(80).optional(),
  // Only the owner has a reason to see retired services; for everyone else
  // this is ignored below.
  includeInactive: z.enum(['true', 'false']).optional(),
});

const upsertSchema = z.object({
  name: z.string().trim().min(2).max(120),
  description: z.string().trim().min(2).max(1000),
  category: z.string().trim().min(2).max(80),
  priceCents: z.number().int().min(0).max(10_000_000),
  durationMinutes: z.number().int().min(5).max(600),
  imageAsset: z.string().trim().max(300).optional().nullable(),
  active: z.boolean().optional(),
  /** Stylist ids who perform it. Replaces the set when present. */
  stylistIds: z.array(z.string().uuid()).max(100).optional(),
});

const patchSchema = upsertSchema.partial();

servicesRouter.get(
  '/',
  asyncHandler(async (req, res) => {
    const query = parseQuery(listQuery, req);
    const services = await prisma.service.findMany({
      where: {
        ...(query.category ? { category: query.category } : {}),
        ...(query.includeInactive === 'true' ? {} : { active: true }),
      },
      include: {
        stylists: { select: { stylistId: true } },
      },
      orderBy: [{ category: 'asc' }, { name: 'asc' }],
    });

    ok(res, {
      services: services.map((service) => ({
        ...servicePublic(service),
        stylistIds: service.stylists.map((s) => s.stylistId),
      })),
    });
  }),
);

servicesRouter.get(
  '/:id',
  asyncHandler(async (req, res) => {
    const service = await prisma.service.findUnique({
      where: { id: req.params.id },
      include: { stylists: { select: { stylistId: true } } },
    });
    if (!service) throw notFound('That service does not exist.');

    ok(res, {
      ...servicePublic(service),
      stylistIds: service.stylists.map((s) => s.stylistId),
    });
  }),
);

servicesRouter.post(
  '/',
  requireAuth,
  requireOwner,
  asyncHandler(async (req, res) => {
    const body = parseBody(upsertSchema, req);
    await assertStylistsExist(body.stylistIds);

    const service = await prisma.service.create({
      data: {
        name: body.name,
        description: body.description,
        category: body.category,
        priceCents: body.priceCents,
        durationMinutes: body.durationMinutes,
        imageAsset: body.imageAsset ?? null,
        active: body.active ?? true,
        ...(body.stylistIds
          ? {
              stylists: {
                create: body.stylistIds.map((stylistId) => ({ stylistId })),
              },
            }
          : {}),
      },
      include: { stylists: { select: { stylistId: true } } },
    });

    created(res, {
      ...servicePublic(service),
      stylistIds: service.stylists.map((s) => s.stylistId),
    });
  }),
);

servicesRouter.patch(
  '/:id',
  requireAuth,
  requireOwner,
  asyncHandler(async (req, res) => {
    const body = parseBody(patchSchema, req);
    const existing = await prisma.service.findUnique({ where: { id: req.params.id } });
    if (!existing) throw notFound('That service does not exist.');
    await assertStylistsExist(body.stylistIds);

    const service = await prisma.service.update({
      where: { id: existing.id },
      data: {
        ...(body.name === undefined ? {} : { name: body.name }),
        ...(body.description === undefined ? {} : { description: body.description }),
        ...(body.category === undefined ? {} : { category: body.category }),
        ...(body.priceCents === undefined ? {} : { priceCents: body.priceCents }),
        ...(body.durationMinutes === undefined
          ? {}
          : { durationMinutes: body.durationMinutes }),
        ...(body.imageAsset === undefined ? {} : { imageAsset: body.imageAsset }),
        ...(body.active === undefined ? {} : { active: body.active }),
        // Replacing the set, not adding to it, so removing a stylist from a
        // service is possible with the same call that adds one.
        ...(body.stylistIds
          ? {
              stylists: {
                deleteMany: {},
                create: body.stylistIds.map((stylistId) => ({ stylistId })),
              },
            }
          : {}),
      },
      include: { stylists: { select: { stylistId: true } } },
    });

    ok(res, {
      ...servicePublic(service),
      stylistIds: service.stylists.map((s) => s.stylistId),
    });
  }),
);

servicesRouter.delete(
  '/:id',
  requireAuth,
  requireOwner,
  asyncHandler(async (req, res) => {
    const service = await prisma.service.findUnique({
      where: { id: req.params.id },
      include: { _count: { select: { appointments: true } } },
    });
    if (!service) throw notFound('That service does not exist.');

    if (service._count.appointments > 0) {
      // History wins over tidiness: a deactivated service disappears from the
      // app and from availability while the bookings that used it keep their
      // name and price.
      const updated = await prisma.service.update({
        where: { id: service.id },
        data: { active: false },
      });
      ok(res, {
        ...servicePublic(updated),
        deactivated: true,
        message: 'That service has past bookings, so it was retired rather than deleted.',
      });
      return;
    }

    await prisma.service.delete({ where: { id: service.id } });
    ok(res, { ok: true, deleted: true, id: service.id });
  }),
);

async function assertStylistsExist(ids?: string[]): Promise<void> {
  if (!ids || ids.length === 0) return;
  const found = await prisma.stylist.count({ where: { id: { in: ids } } });
  if (found !== new Set(ids).size) {
    throw badRequest('One or more of those stylists do not exist.');
  }
}
