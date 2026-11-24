/**
 * Tests for the availability engine.
 *
 * These are the checks worth having: the engine decides what a client is
 * offered, and every one of its mistakes is both plausible and invisible.
 * Nobody notices that a 90-minute colour is being offered at 19:00 — twenty
 * minutes before closing — until a stylist is still working at 20:30.
 *
 * Everything here runs against the compiled output with no database, no
 * network and no credentials, because the engine is pure: plain data in, slots
 * out, with the clock passed in rather than read. So `npm test` is seconds on
 * any laptop, on any branch. The database-backed guarantees are tested
 * separately in `concurrency.test.mjs`.
 *
 *   npm test
 */
import { strict as assert } from 'node:assert';
import { describe, test } from 'node:test';

import {
  computeAvailability,
  freeWindowsFor,
  isOfferedSlot,
} from '../dist/availability/engine.js';
import {
  intersect,
  normalise,
  subtract,
} from '../dist/availability/intervals.js';
import { localToInstant, minuteOfDayToLabel } from '../dist/lib/time.js';

/** Africa/Johannesburg, UTC+2 all year. */
const OFFSET = 120;

/** A Wednesday, well clear of month and year boundaries. */
const DATE = '2026-12-02';

/** 09:00 salon-local on DATE, as an instant. */
const at = (time) => localToInstant(DATE, toMinutes(time), OFFSET);

function toMinutes(label) {
  const [h, m] = label.split(':').map(Number);
  return h * 60 + m;
}

const window = (from, to) => ({ startsAt: at(from), endsAt: at(to) });

/** 09:00–20:00, the salon's real hours. */
const OPEN = [window('09:00', '20:00')];

/** The local HH:MM labels of the offered slots — what the app shows as chips. */
const labels = (result) =>
  result.slots.map((slot) =>
    minuteOfDayToLabel(
      (slot.startsAt.getTime() - localToInstant(DATE, 0, OFFSET).getTime()) / 60_000,
    ),
  );

/** A clock reading far enough before DATE that lead time never bites. */
const WELL_BEFORE = new Date(at('09:00').getTime() - 5 * 24 * 60 * 60_000);

const stylist = (id, workingWindows, busyWindows = []) => ({
  stylistId: id,
  workingWindows,
  busyWindows,
});

const run = (overrides = {}) =>
  computeAvailability({
    businessWindows: OPEN,
    stylists: [stylist('jabulile', [window('09:00', '18:00')])],
    serviceDurationMinutes: 60,
    slotStepMinutes: 15,
    leadTimeMinutes: 120,
    now: WELL_BEFORE,
    ...overrides,
  });

// ---------------------------------------------------------------------------

describe('interval arithmetic', () => {
  test('normalise fuses touching and overlapping spans and drops empties', () => {
    const merged = normalise([
      { start: 10, end: 20 },
      { start: 20, end: 30 }, // touching
      { start: 25, end: 28 }, // inside the previous
      { start: 50, end: 50 }, // empty
      { start: 40, end: 45 },
    ]);
    assert.deepEqual(merged, [
      { start: 10, end: 30 },
      { start: 40, end: 45 },
    ]);
  });

  test('intersect keeps only the shared parts', () => {
    const shared = intersect(
      [
        { start: 0, end: 100 },
        { start: 200, end: 300 },
      ],
      [
        { start: 50, end: 250 },
      ],
    );
    assert.deepEqual(shared, [
      { start: 50, end: 100 },
      { start: 200, end: 250 },
    ]);
  });

  test('subtract cuts a hole out of the middle', () => {
    assert.deepEqual(
      subtract([{ start: 0, end: 100 }], [{ start: 40, end: 60 }]),
      [
        { start: 0, end: 40 },
        { start: 60, end: 100 },
      ],
    );
  });

  test('a cut covering the whole span leaves nothing', () => {
    assert.deepEqual(
      subtract([{ start: 10, end: 20 }], [{ start: 0, end: 50 }]),
      [],
    );
  });

  test('back-to-back spans do not overlap — the half-open convention', () => {
    // An appointment 10:00-11:00 must not block one starting at 11:00. This is
    // the same `[)` convention the database exclusion constraint uses.
    assert.deepEqual(
      subtract([{ start: 0, end: 100 }], [{ start: 0, end: 50 }]),
      [{ start: 50, end: 100 }],
    );
  });
});

describe('free windows for one stylist', () => {
  test('rostered hours are clipped to the salon opening hours', () => {
    // Rostered 08:00-21:00, but the salon is only open 09:00-20:00.
    const free = freeWindowsFor(OPEN, stylist('s', [window('08:00', '21:00')]));
    assert.equal(free.length, 1);
    assert.equal(free[0].start, at('09:00').getTime());
    assert.equal(free[0].end, at('20:00').getTime());
  });

  test('a lunch break splits the day into two windows', () => {
    const free = freeWindowsFor(
      OPEN,
      stylist('s', [window('09:00', '13:00'), window('14:00', '18:00')]),
    );
    assert.equal(free.length, 2);
    assert.equal(free[0].end, at('13:00').getTime());
    assert.equal(free[1].start, at('14:00').getTime());
  });
});

describe('closed days', () => {
  test('no business hours means no slots and a reason the app can show', () => {
    const result = run({ businessWindows: [] });
    assert.deepEqual(result.slots, []);
    assert.equal(result.reason, 'SALON_CLOSED');
  });

  test("a stylist's own roster cannot open a closed salon", () => {
    // Someone rostered on a Sunday is still not bookable on a Sunday.
    const result = run({
      businessWindows: [],
      stylists: [stylist('jabulile', [window('09:00', '17:00')])],
    });
    assert.deepEqual(result.slots, []);
    assert.equal(result.reason, 'SALON_CLOSED');
  });

  test('salon open but nobody rostered', () => {
    const result = run({ stylists: [stylist('jabulile', [])] });
    assert.deepEqual(result.slots, []);
    assert.equal(result.reason, 'NO_STYLIST_WORKING');
  });

  test('no qualified stylist at all is a distinct reason', () => {
    const result = run({ stylists: [] });
    assert.deepEqual(result.slots, []);
    assert.equal(result.reason, 'NO_STYLIST_FOR_SERVICE');
  });
});

describe('the basic grid', () => {
  test('a 60 minute service on a 09:00-18:00 roster runs 09:00 to 17:00', () => {
    const result = run();
    const shown = labels(result);

    assert.equal(shown[0], '09:00');
    assert.equal(shown[1], '09:15');
    // 17:00 fits (ends 18:00); 17:15 would run past the shift.
    assert.equal(shown[shown.length - 1], '17:00');
    assert.equal(shown.length, (17 - 9) * 4 + 1);
    assert.equal(result.reason, null);
  });

  test('every slot carries the stylists who could take it', () => {
    const result = run({
      stylists: [
        stylist('jabulile', [window('09:00', '18:00')]),
        stylist('oscar', [window('10:00', '18:00')]),
      ],
    });

    const nine = result.slots.find((s) => s.startsAt.getTime() === at('09:00').getTime());
    const ten = result.slots.find((s) => s.startsAt.getTime() === at('10:00').getTime());

    assert.deepEqual(nine.stylistIds, ['jabulile']);
    // Sorted, so "anyone" resolves deterministically.
    assert.deepEqual(ten.stylistIds, ['jabulile', 'oscar']);
  });

  test('the grid is anchored to the shift start, not to midnight', () => {
    // Rostered from 09:10. Anchoring to midnight on a 15-minute grid would
    // offer 09:15 first and silently lose five minutes of the stylist's day.
    const result = run({
      stylists: [stylist('jabulile', [window('09:10', '14:00')])],
    });
    assert.equal(labels(result)[0], '09:10');
    assert.equal(labels(result)[1], '09:25');
  });

  test('slot ends are start plus the service duration', () => {
    const result = run({ serviceDurationMinutes: 90 });
    const first = result.slots[0];
    assert.equal(first.endsAt.getTime() - first.startsAt.getTime(), 90 * 60_000);
  });
});

describe('duration not fitting before close', () => {
  test('a 90 minute colour is not offered in the last hour', () => {
    // Open until 20:00, so the last 90-minute start is 18:30 — not 19:00,
    // and certainly not 19:45.
    const result = run({
      serviceDurationMinutes: 90,
      stylists: [stylist('jabulile', [window('09:00', '20:00')])],
    });
    const shown = labels(result);
    assert.equal(shown[shown.length - 1], '18:30');
    assert.ok(!shown.includes('19:00'));
  });

  test('a service longer than the whole day is never offered', () => {
    const result = run({ serviceDurationMinutes: 10 * 60 });
    assert.deepEqual(result.slots, []);
    assert.equal(result.reason, 'FULLY_BOOKED');
  });

  test('a service that exactly fills the shift is offered once', () => {
    const result = run({
      serviceDurationMinutes: 60,
      stylists: [stylist('jabulile', [window('09:00', '10:00')])],
    });
    assert.deepEqual(labels(result), ['09:00']);
  });
});

describe('time off', () => {
  test('an afternoon off removes the afternoon', () => {
    const result = run({
      stylists: [
        stylist('jabulile', [window('09:00', '18:00')], [window('13:00', '18:00')]),
      ],
    });
    const shown = labels(result);
    assert.equal(shown[shown.length - 1], '12:00'); // ends 13:00
    assert.ok(!shown.includes('13:00'));
  });

  test('time off spanning the whole day removes every slot', () => {
    const result = run({
      stylists: [
        // A fortnight of leave, of which this day is in the middle.
        stylist(
          'jabulile',
          [window('09:00', '18:00')],
          [{ startsAt: at('-48:00'), endsAt: at('72:00') }],
        ),
      ],
    });
    assert.deepEqual(result.slots, []);
    assert.equal(result.reason, 'FULLY_BOOKED');
  });

  test('one stylist off still leaves the other bookable', () => {
    const result = run({
      stylists: [
        stylist('jabulile', [window('09:00', '18:00')], [window('09:00', '18:00')]),
        stylist('oscar', [window('09:00', '18:00')]),
      ],
    });
    assert.ok(result.slots.length > 0);
    assert.ok(result.slots.every((s) => s.stylistIds.join() === 'oscar'));
  });
});

describe('a mid-day existing booking', () => {
  test('a 13:00-14:00 booking blocks the starts that would run into it', () => {
    const result = run({
      serviceDurationMinutes: 60,
      stylists: [
        stylist('jabulile', [window('09:00', '18:00')], [window('13:00', '14:00')]),
      ],
    });
    const shown = labels(result);

    // 12:00 ends at 13:00 — fine, half-open.
    assert.ok(shown.includes('12:00'));
    // 12:15 through 13:45 would all overlap the booking.
    for (const blocked of ['12:15', '12:30', '12:45', '13:00', '13:15', '13:30', '13:45']) {
      assert.ok(!shown.includes(blocked), `${blocked} should be blocked`);
    }
    // 14:00 starts exactly as it ends — also fine.
    assert.ok(shown.includes('14:00'));
  });

  test('back-to-back bookings leave no gap and no false slot', () => {
    const result = run({
      serviceDurationMinutes: 30,
      stylists: [
        stylist(
          'jabulile',
          [window('09:00', '11:00')],
          [window('09:00', '10:00'), window('10:00', '10:30')],
        ),
      ],
    });
    assert.deepEqual(labels(result), ['10:30']);
  });

  test('a fully booked day reports FULLY_BOOKED, not NO_STYLIST_WORKING', () => {
    // The distinction matters: one means "try another day", the other means
    // "nobody works that day".
    const result = run({
      stylists: [
        stylist('jabulile', [window('09:00', '18:00')], [window('09:00', '18:00')]),
      ],
    });
    assert.deepEqual(result.slots, []);
    assert.equal(result.reason, 'FULLY_BOOKED');
  });
});

describe('lead time', () => {
  test('slots inside the lead time are excluded', () => {
    // It is 10:00 on the day, with two hours' notice required: the first
    // bookable start is 12:00, not 10:15.
    const result = run({
      now: at('10:00'),
      leadTimeMinutes: 120,
    });
    const shown = labels(result);
    assert.equal(shown[0], '12:00');
    assert.ok(!shown.includes('10:15'));
    assert.ok(!shown.includes('11:45'));
  });

  test('the first bookable start is pushed onto the grid, not left ragged', () => {
    // 10:05 + 120 minutes is 12:05, which is not on a 15-minute grid: the
    // first offer must be 12:15.
    const result = run({ now: at('10:05'), leadTimeMinutes: 120 });
    assert.equal(labels(result)[0], '12:15');
  });

  test('zero lead time offers the current grid point', () => {
    const result = run({ now: at('10:00'), leadTimeMinutes: 0 });
    assert.equal(labels(result)[0], '10:00');
  });

  test('a lead time past closing empties the day', () => {
    const result = run({ now: at('10:00'), leadTimeMinutes: 10 * 60 });
    assert.deepEqual(result.slots, []);
    assert.equal(result.reason, 'FULLY_BOOKED');
  });

  test('a long lead time still terminates promptly', () => {
    // Guards the loop that skips ahead to the lead-time boundary: stepping
    // there 15 minutes at a time over a year would take millions of
    // iterations.
    const started = Date.now();
    run({ now: at('10:00'), leadTimeMinutes: 365 * 24 * 60 });
    assert.ok(Date.now() - started < 500);
  });
});

describe('the whole computation together', () => {
  test('hours ∩ roster − time off − bookings, on a 15 minute grid', () => {
    // Salon 09:00-20:00. Jabulile rostered 09:00-13:00 and 14:00-18:00, with
    // a 10:00-11:30 booking and 16:00-18:00 off. 60 minute service, 2 hours'
    // notice, and it is 08:00 on the day.
    const result = run({
      now: at('08:00'),
      leadTimeMinutes: 120,
      serviceDurationMinutes: 60,
      stylists: [
        stylist(
          'jabulile',
          [window('09:00', '13:00'), window('14:00', '18:00')],
          [window('10:00', '11:30'), window('16:00', '18:00')],
        ),
      ],
    });

    assert.deepEqual(labels(result), [
      // Lead time rules out everything before 10:00; the booking rules out
      // 10:00-11:30; 11:30 and 11:45 end inside the shift.
      '11:30',
      '11:45',
      '12:00',
      // 12:15 onwards would run past 13:00.
      // The afternoon shift resumes at 14:00; 15:00 is the last start that
      // ends before the 16:00 time off.
      '14:00',
      '14:15',
      '14:30',
      '14:45',
      '15:00',
    ]);
  });
});

describe('isOfferedSlot', () => {
  test('accepts an offered slot for an offered stylist', () => {
    const result = run();
    assert.ok(isOfferedSlot(result, at('09:00'), 'jabulile'));
  });

  test('rejects a time that is not on offer', () => {
    const result = run();
    assert.ok(!isOfferedSlot(result, at('03:00'), 'jabulile'));
    assert.ok(!isOfferedSlot(result, at('09:07'), 'jabulile'));
  });

  test('rejects a stylist who is not free at that time', () => {
    const result = run({
      stylists: [
        stylist('jabulile', [window('09:00', '18:00')]),
        stylist('oscar', [window('14:00', '18:00')]),
      ],
    });
    assert.ok(isOfferedSlot(result, at('09:00'), 'jabulile'));
    assert.ok(!isOfferedSlot(result, at('09:00'), 'oscar'));
  });
});

describe('input guards', () => {
  test('a non-positive duration is a programming error, not an empty day', () => {
    assert.throws(() => run({ serviceDurationMinutes: 0 }), /positive/);
    assert.throws(() => run({ slotStepMinutes: 0 }), /positive/);
  });
});
