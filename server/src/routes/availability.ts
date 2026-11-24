/**
 * `GET /availability` — the endpoint the booking screen is built around.
 *
 * It is public. Prices and open slots are what the app shows before anyone
 * signs in, and requiring a token here would mean a client must register
 * before finding out whether Saturday morning is free.
 *
 * `stylistId` is optional. Omitted, the response is every slot at which *some*
 * qualified stylist is free, each slot carrying the ids of the stylists who
 * could take it — so the app can offer "anyone" and still book a specific
 * person when the client picks one.
 */
import { Router } from 'express';
import { z } from 'zod';

import { getAvailability } from '../availability/service';
import { Config } from '../config';
import { asyncHandler, ok, parseQuery } from '../lib/http';
import { prisma } from '../lib/prisma';
import { businessHoursPublic } from '../lib/serialize';
import {
  addDays,
  instantToLocalDate,
  isValidLocalDate,
  minuteOfDayToLabel,
} from '../lib/time';

export const availabilityRouter = Router();

const availabilityQuery = z.object({
  serviceId: z.string().uuid('serviceId must be a valid id.'),
  stylistId: z.string().uuid('stylistId must be a valid id.').optional(),
  date: z
    .string()
    .refine(isValidLocalDate, 'date must be a real date in YYYY-MM-DD form.'),
});

availabilityRouter.get(
  '/availability',
  asyncHandler(async (req, res) => {
    const query = parseQuery(availabilityQuery, req);
    const result = await getAvailability({
      serviceId: query.serviceId,
      stylistId: query.stylistId,
      date: query.date,
    });

    ok(res, {
      date: result.date,
      service: result.service,
      rules: result.rules,
      reason: result.reason,
      slots: result.slots.map((slot) => ({
        startsAt: slot.startsAt.toISOString(),
        endsAt: slot.endsAt.toISOString(),
        // The local label the app puts on the chip, so it need not re-derive
        // the salon's timezone client-side.
        label: minuteOfDayToLabel(
          localMinuteOf(slot.startsAt, Config.booking.utcOffsetMinutes),
        ),
        stylistIds: slot.stylistIds,
      })),
    });
  }),
);

/**
 * The salon's opening hours and the booking rules, for the screens that need
 * them before a date is chosen — the week strip, and the "we're closed on
 * Sundays" note.
 */
availabilityRouter.get(
  '/salon',
  asyncHandler(async (_req, res) => {
    const hours = await prisma.businessHours.findMany({ orderBy: { weekday: 'asc' } });
    const today = instantToLocalDate(new Date(), Config.booking.utcOffsetMinutes);

    ok(res, {
      salon: Config.salon,
      businessHours: hours.map(businessHoursPublic),
      rules: {
        slotStepMinutes: Config.booking.slotStepMinutes,
        leadTimeMinutes: Config.booking.leadTimeMinutes,
        maxDaysAhead: Config.booking.maxDaysAhead,
        cancellationWindowHours: Config.booking.cancellationWindowHours,
        utcOffsetMinutes: Config.booking.utcOffsetMinutes,
      },
      bookingWindow: {
        firstDate: today,
        lastDate: addDays(today, Config.booking.maxDaysAhead),
      },
    });
  }),
);

function localMinuteOf(instant: Date, utcOffsetMinutes: number): number {
  const shifted = new Date(instant.getTime() + utcOffsetMinutes * 60_000);
  return shifted.getUTCHours() * 60 + shifted.getUTCMinutes();
}
