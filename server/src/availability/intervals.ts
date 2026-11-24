/**
 * Half-open interval arithmetic, `[start, end)`.
 *
 * Half-open is the whole reason this file is small: an appointment ending at
 * 10:00 and one starting at 10:00 do not overlap, and that falls out of `<`
 * rather than needing a rule. The same convention is used by the database
 * exclusion constraint (`tstzrange(..., '[)')`), so the two agree by
 * construction instead of by coincidence.
 *
 * Times are epoch milliseconds. Everything here is pure.
 */

export interface Interval {
  start: number;
  end: number;
}

export const interval = (start: number, end: number): Interval => ({ start, end });

export const isEmpty = (i: Interval): boolean => i.end <= i.start;

export const overlaps = (a: Interval, b: Interval): boolean =>
  a.start < b.end && b.start < a.end;

export const contains = (outer: Interval, inner: Interval): boolean =>
  outer.start <= inner.start && inner.end <= outer.end;

export const byStart = (a: Interval, b: Interval): number =>
  a.start - b.start || a.end - b.end;

/** Sorts, drops empties, and fuses anything touching or overlapping. */
export function normalise(intervals: readonly Interval[]): Interval[] {
  const sorted = intervals.filter((i) => !isEmpty(i)).sort(byStart);
  const merged: Interval[] = [];

  for (const current of sorted) {
    const last = merged[merged.length - 1];
    if (last && current.start <= last.end) {
      last.end = Math.max(last.end, current.end);
    } else {
      merged.push({ start: current.start, end: current.end });
    }
  }
  return merged;
}

/** Every piece of `a` that is also in `b`. Both sides are normalised first. */
export function intersect(
  a: readonly Interval[],
  b: readonly Interval[],
): Interval[] {
  const left = normalise(a);
  const right = normalise(b);
  const out: Interval[] = [];

  let i = 0;
  let j = 0;
  while (i < left.length && j < right.length) {
    const start = Math.max(left[i].start, right[j].start);
    const end = Math.min(left[i].end, right[j].end);
    if (start < end) out.push({ start, end });

    // Advance whichever ends first; it cannot intersect anything later.
    if (left[i].end < right[j].end) i += 1;
    else j += 1;
  }
  return out;
}

/** Every piece of `from` that is not in `cuts`. */
export function subtract(
  from: readonly Interval[],
  cuts: readonly Interval[],
): Interval[] {
  const base = normalise(from);
  const holes = normalise(cuts);
  const out: Interval[] = [];

  for (const span of base) {
    let cursor = span.start;
    for (const hole of holes) {
      if (hole.end <= cursor) continue;
      if (hole.start >= span.end) break;
      if (hole.start > cursor) {
        out.push({ start: cursor, end: Math.min(hole.start, span.end) });
      }
      cursor = Math.max(cursor, hole.end);
      if (cursor >= span.end) break;
    }
    if (cursor < span.end) out.push({ start: cursor, end: span.end });
  }
  return out;
}
