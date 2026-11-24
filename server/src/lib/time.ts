/**
 * Local-time arithmetic for a salon in one fixed timezone.
 *
 * Opening hours are naturally local and date-free ("we open at nine"), while
 * appointments are naturally absolute ("09:00 on 4 December"). Mixing the two
 * is where booking bugs live, so everything here converts in exactly one
 * direction at exactly one place: minutes-from-local-midnight plus a local
 * calendar date, in, and a UTC instant out.
 *
 * Every function is pure and timezone-independent of the *host* clock — the
 * offset is passed in, never read from the machine — which is what lets the
 * tests assert exact instants without caring where they run.
 */

export const MINUTES_PER_DAY = 24 * 60;
const MS_PER_MINUTE = 60_000;

/** `YYYY-MM-DD`, the only date format the API accepts or emits. */
export type LocalDate = string;

const DATE_PATTERN = /^(\d{4})-(\d{2})-(\d{2})$/;

export interface ParsedLocalDate {
  year: number;
  month: number; // 1-12
  day: number; // 1-31
}

export function parseLocalDate(date: LocalDate): ParsedLocalDate {
  const match = DATE_PATTERN.exec(date);
  if (!match) {
    throw new Error(`Date must look like YYYY-MM-DD, got "${date}".`);
  }
  const year = Number(match[1]);
  const month = Number(match[2]);
  const day = Number(match[3]);

  // Round-tripping through UTC catches 2026-02-30 and 2026-13-01, which the
  // regex happily accepts.
  const asUtc = new Date(Date.UTC(year, month - 1, day));
  if (
    asUtc.getUTCFullYear() !== year ||
    asUtc.getUTCMonth() !== month - 1 ||
    asUtc.getUTCDate() !== day
  ) {
    throw new Error(`"${date}" is not a real date.`);
  }
  return { year, month, day };
}

export function isValidLocalDate(date: string): boolean {
  try {
    parseLocalDate(date);
    return true;
  } catch {
    return false;
  }
}

/**
 * The instant at which `minuteOfDay` begins on `date`, salon-local.
 *
 * `minuteOfDay` may exceed 1440, which is how a window that runs past midnight
 * is expressed without special-casing the date.
 */
export function localToInstant(
  date: LocalDate,
  minuteOfDay: number,
  utcOffsetMinutes: number,
): Date {
  const { year, month, day } = parseLocalDate(date);
  const midnightUtc = Date.UTC(year, month - 1, day);
  return new Date(midnightUtc + (minuteOfDay - utcOffsetMinutes) * MS_PER_MINUTE);
}

/** The salon-local calendar date an instant falls on. */
export function instantToLocalDate(
  instant: Date,
  utcOffsetMinutes: number,
): LocalDate {
  const shifted = new Date(instant.getTime() + utcOffsetMinutes * MS_PER_MINUTE);
  const y = shifted.getUTCFullYear();
  const m = String(shifted.getUTCMonth() + 1).padStart(2, '0');
  const d = String(shifted.getUTCDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

/** Minutes from salon-local midnight, for an instant. */
export function instantToMinuteOfDay(
  instant: Date,
  utcOffsetMinutes: number,
): number {
  const shifted = new Date(instant.getTime() + utcOffsetMinutes * MS_PER_MINUTE);
  return shifted.getUTCHours() * 60 + shifted.getUTCMinutes();
}

/** 0 = Sunday .. 6 = Saturday, matching JavaScript and the stored weekdays. */
export function weekdayOf(date: LocalDate): number {
  const { year, month, day } = parseLocalDate(date);
  return new Date(Date.UTC(year, month - 1, day)).getUTCDay();
}

export function weekdayOfInstant(
  instant: Date,
  utcOffsetMinutes: number,
): number {
  return weekdayOf(instantToLocalDate(instant, utcOffsetMinutes));
}

/** Whole days between two local dates: `addDays(a, n) === b`. */
export function daysBetween(from: LocalDate, to: LocalDate): number {
  const a = parseLocalDate(from);
  const b = parseLocalDate(to);
  const ms =
    Date.UTC(b.year, b.month - 1, b.day) - Date.UTC(a.year, a.month - 1, a.day);
  return Math.round(ms / (MINUTES_PER_DAY * MS_PER_MINUTE));
}

export function addDays(date: LocalDate, days: number): LocalDate {
  const { year, month, day } = parseLocalDate(date);
  const moved = new Date(Date.UTC(year, month - 1, day + days));
  const y = moved.getUTCFullYear();
  const m = String(moved.getUTCMonth() + 1).padStart(2, '0');
  const d = String(moved.getUTCDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

/** "09:00" for 540. Used in responses so the app need not do the division. */
export function minuteOfDayToLabel(minuteOfDay: number): string {
  const normalised = ((minuteOfDay % MINUTES_PER_DAY) + MINUTES_PER_DAY) % MINUTES_PER_DAY;
  const h = String(Math.floor(normalised / 60)).padStart(2, '0');
  const m = String(normalised % 60).padStart(2, '0');
  return `${h}:${m}`;
}

/** "09:00" or "9:00" to 540. Rejects anything else. */
export function labelToMinuteOfDay(label: string): number {
  const match = /^(\d{1,2}):(\d{2})$/.exec(label.trim());
  if (!match) {
    throw new Error(`Time must look like HH:MM, got "${label}".`);
  }
  const h = Number(match[1]);
  const m = Number(match[2]);
  if (h > 24 || m > 59 || (h === 24 && m !== 0)) {
    throw new Error(`"${label}" is not a real time of day.`);
  }
  return h * 60 + m;
}

export function addMinutes(instant: Date, minutes: number): Date {
  return new Date(instant.getTime() + minutes * MS_PER_MINUTE);
}

/** Rounds `minute` up to the next multiple of `step`. */
export function ceilToStep(minute: number, step: number): number {
  if (step <= 0) return minute;
  return Math.ceil(minute / step) * step;
}
