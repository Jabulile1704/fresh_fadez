/**
 * The availability engine: the one piece of logic in this server that is worth
 * being careful about.
 *
 * It is deliberately pure. Plain data in — opening hours, working hours, time
 * off, existing bookings, a duration, a clock reading — and a list of bookable
 * slots out. No Prisma, no Express, no `new Date()`, no `process.env`. That is
 * what makes "closed on Sunday", "the 13:00 booking blocks 12:30 for a 90
 * minute service", and "a 90 minute colour will not fit before 20:00" things a
 * test can state in four lines, instead of things someone discovers in
 * production.
 *
 * The computation, per stylist:
 *
 *     salon opening hours for that weekday          (when the doors are open)
 *   ∩ that stylist's working hours for that weekday (when they are rostered)
 *   − their time off                                (leave, training)
 *   − their non-cancelled appointments              (the chair is occupied)
 *   = free time
 *
 * then free time is walked on a fixed grid (`slotStepMinutes`) and a slot is
 * offered only where the *whole* service duration fits inside one free span
 * and starts no sooner than `leadTimeMinutes` from now.
 *
 * The grid is anchored to each free span's own start rather than to midnight,
 * so a stylist rostered 09:10–12:00 is offered 09:10, 09:25, … and not nothing
 * at all. Slots from different stylists are then merged by start time, which
 * is what makes `stylistId` optional at the API edge: one slot, several
 * stylists who could take it.
 */
import {
  Interval,
  intersect,
  normalise,
  subtract,
} from './intervals';

/** A window of time, as the caller holds it: real instants. */
export interface TimeWindow {
  startsAt: Date;
  endsAt: Date;
}

export interface StylistAvailabilityInput {
  stylistId: string;
  /**
   * When this stylist is rostered on the requested day, salon-local hours
   * already resolved to instants. Empty means "not working that day", which
   * is different from "working but fully booked" and yields no slots either
   * way.
   */
  workingWindows: readonly TimeWindow[];
  /**
   * Everything that occupies them: time off and existing appointments, in one
   * list because the engine treats them identically. The caller is responsible
   * for having excluded cancelled appointments.
   */
  busyWindows: readonly TimeWindow[];
}

export interface AvailabilityInput {
  /**
   * When the salon itself is open on the requested day. Empty means closed —
   * a public holiday or a day marked `isClosed` — and no stylist's own roster
   * can open it.
   */
  businessWindows: readonly TimeWindow[];
  stylists: readonly StylistAvailabilityInput[];
  /** How long the requested service takes. Must be positive. */
  serviceDurationMinutes: number;
  /** Grid the offered start times sit on, in minutes. */
  slotStepMinutes: number;
  /** Soonest a booking may start, measured from `now`. */
  leadTimeMinutes: number;
  /** The clock reading, passed in rather than read, so this stays pure. */
  now: Date;
}

export interface AvailableSlot {
  startsAt: Date;
  endsAt: Date;
  /** Every stylist who could take this slot, ascending by id. */
  stylistIds: string[];
}

export interface AvailabilityResult {
  slots: AvailableSlot[];
  /**
   * Why there is nothing to offer, when there is nothing to offer. The app
   * shows this instead of an empty list with no explanation, and it is `null`
   * whenever `slots` is non-empty.
   */
  reason: UnavailableReason | null;
}

export type UnavailableReason =
  | 'SALON_CLOSED'
  | 'NO_STYLIST_FOR_SERVICE'
  | 'NO_STYLIST_WORKING'
  | 'FULLY_BOOKED';

const MS_PER_MINUTE = 60_000;

const toInterval = (w: TimeWindow): Interval => ({
  start: w.startsAt.getTime(),
  end: w.endsAt.getTime(),
});

/**
 * Free time for one stylist on the requested day: rostered hours clipped to
 * the salon's opening hours, with time off and bookings cut out.
 *
 * Exported because it is useful on its own — the staff agenda uses it to show
 * a stylist's remaining gaps — and because testing it separately makes a
 * failure in `computeAvailability` easy to localise.
 */
export function freeWindowsFor(
  businessWindows: readonly TimeWindow[],
  stylist: StylistAvailabilityInput,
): Interval[] {
  const open = intersect(
    businessWindows.map(toInterval),
    stylist.workingWindows.map(toInterval),
  );
  return subtract(open, stylist.busyWindows.map(toInterval));
}

/**
 * Start times on a `step` grid at which a `duration` block fits entirely
 * inside `span`, no earlier than `earliest`.
 *
 * The grid is anchored to `span.start`, not to midnight: the question being
 * answered is "when could this stylist start", and their shift start is the
 * natural first answer.
 */
function slotStartsIn(
  span: Interval,
  durationMs: number,
  stepMs: number,
  earliest: number,
): number[] {
  const starts: number[] = [];
  const lastPossible = span.end - durationMs;
  if (lastPossible < span.start) return starts; // duration does not fit at all

  let start = span.start;
  if (start < earliest) {
    // Jump straight to the first grid point at or after `earliest` instead of
    // stepping there, so a lead time of days costs no more than one booking.
    const stepsToSkip = Math.ceil((earliest - span.start) / stepMs);
    start = span.start + stepsToSkip * stepMs;
  }
  for (; start <= lastPossible; start += stepMs) {
    starts.push(start);
  }
  return starts;
}

export function computeAvailability(
  input: AvailabilityInput,
): AvailabilityResult {
  const {
    businessWindows,
    stylists,
    serviceDurationMinutes,
    slotStepMinutes,
    leadTimeMinutes,
    now,
  } = input;

  if (!Number.isFinite(serviceDurationMinutes) || serviceDurationMinutes <= 0) {
    throw new Error('serviceDurationMinutes must be a positive number.');
  }
  if (!Number.isFinite(slotStepMinutes) || slotStepMinutes <= 0) {
    throw new Error('slotStepMinutes must be a positive number.');
  }

  const durationMs = serviceDurationMinutes * MS_PER_MINUTE;
  const stepMs = slotStepMinutes * MS_PER_MINUTE;
  const earliest = now.getTime() + Math.max(0, leadTimeMinutes) * MS_PER_MINUTE;

  const open = normalise(businessWindows.map(toInterval));
  if (open.length === 0) {
    return { slots: [], reason: 'SALON_CLOSED' };
  }
  if (stylists.length === 0) {
    return { slots: [], reason: 'NO_STYLIST_FOR_SERVICE' };
  }

  // start time -> the stylists free for the whole duration from that start.
  const byStart = new Map<number, string[]>();
  let anyoneRostered = false;

  for (const stylist of stylists) {
    const free = freeWindowsFor(businessWindows, stylist);
    if (intersect(open, stylist.workingWindows.map(toInterval)).length > 0) {
      anyoneRostered = true;
    }
    for (const span of free) {
      for (const start of slotStartsIn(span, durationMs, stepMs, earliest)) {
        const existing = byStart.get(start);
        if (existing) existing.push(stylist.stylistId);
        else byStart.set(start, [stylist.stylistId]);
      }
    }
  }

  const slots: AvailableSlot[] = [...byStart.entries()]
    .sort(([a], [b]) => a - b)
    .map(([start, stylistIds]) => ({
      startsAt: new Date(start),
      endsAt: new Date(start + durationMs),
      stylistIds: [...stylistIds].sort(),
    }));

  if (slots.length > 0) return { slots, reason: null };

  return {
    slots: [],
    reason: anyoneRostered ? 'FULLY_BOOKED' : 'NO_STYLIST_WORKING',
  };
}

/**
 * Whether `candidate` is one of the slots the engine would offer — the check
 * `POST /appointments` runs before it writes.
 *
 * This is a *policy* check, not the double-booking guard: by the time the row
 * is written someone else may have taken the slot, and that race is settled by
 * the database's exclusion constraint, not here. What this catches is a client
 * asking for 03:00, or for 09:07 off the grid, or for a stylist who does not
 * work Tuesdays — requests that are wrong no matter who else is booking.
 */
export function isOfferedSlot(
  result: AvailabilityResult,
  candidate: Date,
  stylistId: string,
): boolean {
  const at = candidate.getTime();
  return result.slots.some(
    (slot) =>
      slot.startsAt.getTime() === at && slot.stylistIds.includes(stylistId),
  );
}
