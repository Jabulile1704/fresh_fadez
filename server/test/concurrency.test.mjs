/**
 * The double-booking guarantee, tested for real.
 *
 * This is the one test that cannot be written against pure functions. The
 * claim being checked is not "the code decides correctly" — it is "two clients
 * tapping the same slot at the same moment cannot both get it", and that is a
 * claim about PostgreSQL's exclusion constraint under genuine concurrency. So
 * this test starts the actual Express app on an ephemeral port, registers two
 * real clients, and fires two `POST /appointments` requests for the same
 * stylist and the same minute with no coordination between them, then asserts
 * that exactly one is a 201 and the other a 409 `SLOT_TAKEN`.
 *
 * An in-process "call the handler twice" test would pass against a
 * read-then-write implementation, which is exactly the implementation this is
 * meant to rule out.
 *
 * It needs a database. Point `TEST_DATABASE_URL` (preferred) or
 * `DATABASE_URL` at a Postgres this test may write to and delete from, with
 * the migrations applied:
 *
 *     createdb fresh_fadez_test
 *     DATABASE_URL=postgresql://localhost:5432/fresh_fadez_test \
 *       npx prisma migrate deploy
 *     npm test
 *
 * With neither set, or with the database unreachable, every test here skips
 * with a message rather than failing — `npm test` has to work on a laptop that
 * has never run Postgres, the same way the engine tests do.
 */
import { strict as assert } from 'node:assert';
import { after, before, describe, test } from 'node:test';

import { config as loadEnv } from 'dotenv';

// `src/config.ts` loads .env too, but it does so when it is first imported —
// and the choice of database is made here, before that happens.
loadEnv();

const DB_URL = process.env.TEST_DATABASE_URL ?? process.env.DATABASE_URL;

// Set before anything imports config/prisma: the client reads the URL at
// construction, and the test database must never be the development one by
// accident.
if (DB_URL) process.env.DATABASE_URL = DB_URL;
process.env.NODE_ENV = 'test';
// A lead time of zero lets the test book later today instead of needing a
// fixture a week out; the engine's own lead-time behaviour is covered in
// availability.test.mjs.
process.env.MIN_BOOKING_LEAD_MINUTES = '0';
process.env.SLOT_GRANULARITY_MINUTES = '15';
process.env.SALON_UTC_OFFSET_MINUTES = '120';

/** State built in `before`, torn down in `after`. */
let ctx = null;
let skipReason = DB_URL
  ? null
  : 'no TEST_DATABASE_URL or DATABASE_URL set — skipping database tests';

const OFFSET = 120;
/** Marks every row this test creates, so cleanup can be exact. */
const TAG = `conctest-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;

/**
 * Reads a response exactly once and returns both halves.
 *
 * A `fetch` body can only be consumed once, and the obvious-looking
 * `assert.equal(res.status, 201, await res.text())` consumes it whether or not
 * the assertion fails — the message argument is evaluated eagerly. The next
 * `res.json()` then throws "Body is unusable", which surfaces as a hook
 * failure with no sign of the real problem. So: read once, assert afterwards.
 */
async function read(res) {
  const text = await res.text();
  let body = null;
  try {
    body = JSON.parse(text);
  } catch {
    // Left as null; `text` is what the assertion message needs anyway.
  }
  return { status: res.status, body, text };
}

before(async () => {
  if (skipReason) return;

  let prisma;
  let createApp;
  let time;
  try {
    ({ prisma } = await import('../dist/lib/prisma.js'));
    ({ createApp } = await import('../dist/app.js'));
    time = await import('../dist/lib/time.js');
    await prisma.$queryRaw`SELECT 1`;
  } catch (error) {
    skipReason = `database not reachable (${error.message.split('\n')[0]})`;
    return;
  }

  // Refuse to run without the constraint rather than quietly testing nothing:
  // a green concurrency test on a database with no exclusion constraint is
  // worse than no test at all.
  const constraints = await prisma.$queryRaw`
    SELECT conname FROM pg_constraint
    WHERE conname IN ('appointment_no_overlap', 'appointment_client_no_overlap')
  `;
  if (constraints.length < 2) {
    skipReason =
      'appointment exclusion constraints are missing — run `npx prisma migrate deploy` against the test database';
    return;
  }

  const { Role } = await import('@prisma/client');
  const { hashPassword } = await import('../dist/lib/password.js');

  // ------------------------------------------------------------ fixture ---
  // A dedicated service, stylist and two clients, all tagged, so this test
  // neither depends on the seed nor disturbs it.
  const passwordHash = await hashPassword('Password123!');

  const service = await prisma.service.create({
    data: {
      name: `${TAG} Fade`,
      description: 'Fixture service',
      category: TAG,
      priceCents: 4500,
      durationMinutes: 60,
    },
  });

  const staffUser = await prisma.user.create({
    data: {
      email: `${TAG}-stylist@test.local`,
      passwordHash,
      fullName: 'Fixture Stylist',
      role: Role.STYLIST,
    },
  });
  const stylist = await prisma.stylist.create({
    data: {
      userId: staffUser.id,
      title: 'Fixture Stylist',
      specialization: 'Fades',
      services: { create: [{ serviceId: service.id }] },
      // Rostered the full week, so the test never has to care which day it is.
      schedules: {
        create: [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({
          weekday,
          startMinute: 0,
          endMinute: 24 * 60,
        })),
      },
    },
  });

  // Business hours are global, so they cannot be faked per-test. Open every
  // day round the clock for the duration, and restore the real rows after.
  const originalHours = await prisma.businessHours.findMany();
  for (let weekday = 0; weekday <= 6; weekday += 1) {
    await prisma.businessHours.upsert({
      where: { weekday },
      create: { weekday, isClosed: false, openMinute: 0, closeMinute: 24 * 60 },
      update: { isClosed: false, openMinute: 0, closeMinute: 24 * 60 },
    });
  }

  const server = createApp().listen(0);
  await new Promise((resolve) => server.once('listening', resolve));
  const base = `http://127.0.0.1:${server.address().port}`;

  const clients = [];
  for (const name of ['one', 'two']) {
    const res = await read(
      await fetch(`${base}/auth/register`, {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({
          email: `${TAG}-client-${name}@test.local`,
          password: 'Password123!',
          fullName: `Fixture Client ${name}`,
        }),
      }),
    );
    assert.equal(res.status, 201, `register ${name}: ${res.text}`);
    clients.push({ token: res.body.accessToken, userId: res.body.user.id });
  }

  ctx = { prisma, base, server, service, stylist, clients, originalHours, time };
});

after(async () => {
  if (!ctx) {
    // The fixture never finished — but if Prisma connected before it failed,
    // its pool keeps the process alive and the run hangs instead of
    // reporting the failure. Disconnect whatever was opened.
    try {
      const { prisma } = await import('../dist/lib/prisma.js');
      await prisma.$disconnect();
    } catch {
      // Nothing was ever connected; nothing to close.
    }
    return;
  }
  const { prisma, server, originalHours } = ctx;

  // `fetch` keeps its sockets alive, and `server.close()` waits for every
  // open connection — so without this the test process hangs at the end
  // rather than failing, which is a far more confusing way to go wrong.
  server.closeAllConnections();
  await new Promise((resolve) => server.close(resolve));

  // Order matters: appointments reference the stylist and service, which
  // reference users.
  await prisma.appointment.deleteMany({ where: { stylistId: ctx.stylist.id } });
  await prisma.review.deleteMany({ where: { stylistId: ctx.stylist.id } });
  await prisma.stylistService.deleteMany({ where: { stylistId: ctx.stylist.id } });
  await prisma.stylistSchedule.deleteMany({ where: { stylistId: ctx.stylist.id } });
  await prisma.stylist.delete({ where: { id: ctx.stylist.id } });
  await prisma.service.delete({ where: { id: ctx.service.id } });
  await prisma.user.deleteMany({ where: { email: { contains: TAG } } });

  for (const row of originalHours) {
    await prisma.businessHours.update({
      where: { weekday: row.weekday },
      data: {
        isClosed: row.isClosed,
        openMinute: row.openMinute,
        closeMinute: row.closeMinute,
      },
    });
  }
  await prisma.$disconnect();
});

/** A fresh, offered slot, a few days out so nothing else has claimed it. */
async function nextFreeSlot(dayOffset = 3) {
  const { base, service, stylist, time } = ctx;
  const date = time.addDays(
    time.instantToLocalDate(new Date(), OFFSET),
    dayOffset,
  );

  const res = await read(
    await fetch(
      `${base}/availability?serviceId=${service.id}&stylistId=${stylist.id}&date=${date}`,
    ),
  );
  assert.equal(res.status, 200, res.text);
  assert.ok(
    res.body.slots.length > 0,
    `no slots offered on ${date}: ${res.text.slice(0, 400)}`,
  );
  return { date, slot: res.body.slots[0], all: res.body.slots };
}

/** Books a slot and returns `{ status, body, text }`. */
async function book(token, startsAt, overrides = {}) {
  return read(
    await fetch(`${ctx.base}/appointments`, {
      method: 'POST',
      headers: {
        'content-type': 'application/json',
        authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        serviceId: ctx.service.id,
        stylistId: ctx.stylist.id,
        startsAt,
        ...overrides,
      }),
    }),
  );
}

const skip = () => ({ skip: skipReason ?? false });

// ---------------------------------------------------------------------------

describe('double-booking is structurally impossible', () => {
  test('two simultaneous bookings for the same slot: exactly one wins', skip(), async () => {
    const { slot } = await nextFreeSlot(3);
    const [a, b] = ctx.clients;

    // No await between them: both requests are in flight before either
    // response arrives, which is the whole point.
    const results = await Promise.all([
      book(a.token, slot.startsAt),
      book(b.token, slot.startsAt),
    ]);

    const statuses = results.map((r) => r.status).sort();
    assert.deepEqual(
      statuses,
      [201, 409],
      `expected one 201 and one 409, got ${statuses.join(' and ')}: ${results
        .map((r) => r.text.slice(0, 200))
        .join(' | ')}`,
    );

    const loser = results.find((r) => r.status === 409).body;
    assert.equal(loser.error.code, 'SLOT_TAKEN');
    // The app shows this message verbatim, so it must read like a sentence.
    assert.match(loser.error.message, /just booked|another slot/i);

    // And the database agrees: one row, not two.
    const rows = await ctx.prisma.appointment.findMany({
      where: { stylistId: ctx.stylist.id, startsAt: new Date(slot.startsAt) },
    });
    assert.equal(rows.length, 1);
  });

  test('eight simultaneous bookings for one slot: still exactly one wins', skip(), async () => {
    const { slot } = await nextFreeSlot(4);
    const [a, b] = ctx.clients;

    // Four attempts from each client. The client-overlap constraint means a
    // client's own second attempt is rejected too, so this exercises both
    // constraints at once under real contention.
    const attempts = Array.from({ length: 8 }, (_, i) =>
      book(i % 2 === 0 ? a.token : b.token, slot.startsAt),
    );
    const results = await Promise.all(attempts);
    const statuses = results.map((r) => r.status).sort();

    assert.equal(
      statuses.filter((s) => s === 201).length,
      1,
      `expected exactly one success, got ${JSON.stringify(statuses)}`,
    );
    // Every loser must get the same 409, whether it lost the race before it
    // read availability or inside the write — one code for one situation, so
    // the app has one thing to handle. And nothing may fail with a 500: a lost
    // race is a conflict, not a crash.
    assert.deepEqual(
      statuses,
      [201, 409, 409, 409, 409, 409, 409, 409],
      `expected one 201 and seven 409s, got ${JSON.stringify(statuses)}: ${results
        .map((r) => r.text.slice(0, 120))
        .join(' | ')}`,
    );
    for (const result of results.filter((r) => r.status === 409)) {
      assert.ok(
        ['SLOT_TAKEN', 'CLIENT_DOUBLE_BOOKED'].includes(result.body.error.code),
        `unexpected conflict code: ${result.text}`,
      );
    }

    const rows = await ctx.prisma.appointment.findMany({
      where: { stylistId: ctx.stylist.id, startsAt: new Date(slot.startsAt) },
    });
    assert.equal(rows.length, 1);
  });

  test('the raw constraint rejects an overlap written behind the API', skip(), async () => {
    // Proves the guarantee does not depend on the application at all: a direct
    // insert that the handlers never produced is still refused.
    const { slot } = await nextFreeSlot(5);
    const start = new Date(slot.startsAt);
    const mid = new Date(start.getTime() + 30 * 60_000);

    const res = await book(ctx.clients[0].token, slot.startsAt);
    assert.equal(res.status, 201, res.text);

    await assert.rejects(
      () =>
        ctx.prisma.appointment.create({
          data: {
            userId: ctx.clients[1].userId,
            stylistId: ctx.stylist.id,
            serviceId: ctx.service.id,
            startsAt: mid, // overlaps the second half of the booking above
            endsAt: new Date(mid.getTime() + 60 * 60_000),
            priceCents: 4500,
            durationMinutes: 60,
          },
        }),
      (error) => {
        const text = `${error.message} ${JSON.stringify(error.meta ?? {})}`;
        assert.ok(
          text.includes('23P01') || text.includes('appointment_no_overlap'),
          `expected an exclusion violation, got: ${error.message}`,
        );
        return true;
      },
    );
  });

  test('a cancelled booking no longer blocks the slot', skip(), async () => {
    const { slot } = await nextFreeSlot(6);
    const [a, b] = ctx.clients;

    const booked = await book(a.token, slot.startsAt);
    assert.equal(booked.status, 201, booked.text);
    const appointment = booked.body;

    // While it stands, nobody else can have it.
    const blocked = await book(b.token, slot.startsAt);
    assert.equal(blocked.status, 409, blocked.text);

    const cancelled = await read(
      await fetch(`${ctx.base}/appointments/${appointment.id}/cancel`, {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          authorization: `Bearer ${a.token}`,
        },
        body: JSON.stringify({ reason: 'fixture' }),
      }),
    );
    assert.equal(cancelled.status, 200, cancelled.text);

    // CANCELLED sits outside the constraint's predicate, so the slot is free
    // again with no extra bookkeeping.
    const rebooked = await book(b.token, slot.startsAt);
    assert.equal(rebooked.status, 201, rebooked.text);
  });

  test('one client cannot hold two appointments at the same time', skip(), async () => {
    // A second stylist, so the stylist constraint is not what rejects this.
    const { Role } = await import('@prisma/client');
    const { hashPassword } = await import('../dist/lib/password.js');

    const otherUser = await ctx.prisma.user.create({
      data: {
        email: `${TAG}-stylist2@test.local`,
        passwordHash: await hashPassword('Password123!'),
        fullName: 'Fixture Stylist Two',
        role: Role.STYLIST,
      },
    });
    const other = await ctx.prisma.stylist.create({
      data: {
        userId: otherUser.id,
        title: 'Fixture Stylist Two',
        specialization: 'Fades',
        services: { create: [{ serviceId: ctx.service.id }] },
        schedules: {
          create: [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({
            weekday,
            startMinute: 0,
            endMinute: 24 * 60,
          })),
        },
      },
    });

    try {
      const { slot } = await nextFreeSlot(7);
      const [a] = ctx.clients;

      const first = await book(a.token, slot.startsAt);
      assert.equal(first.status, 201, first.text);

      const second = await read(
        await fetch(`${ctx.base}/appointments`, {
          method: 'POST',
          headers: {
            'content-type': 'application/json',
            authorization: `Bearer ${a.token}`,
          },
          body: JSON.stringify({
            serviceId: ctx.service.id,
            stylistId: other.id,
            startsAt: slot.startsAt,
          }),
        }),
      );

      assert.equal(second.status, 409, second.text);
      assert.equal(second.body.error.code, 'CLIENT_DOUBLE_BOOKED');
    } finally {
      await ctx.prisma.appointment.deleteMany({ where: { stylistId: other.id } });
      await ctx.prisma.stylistService.deleteMany({ where: { stylistId: other.id } });
      await ctx.prisma.stylistSchedule.deleteMany({ where: { stylistId: other.id } });
      await ctx.prisma.stylist.delete({ where: { id: other.id } });
      await ctx.prisma.user.delete({ where: { id: otherUser.id } });
    }
  });
});

describe('availability reflects the diary', () => {
  test('a booked slot disappears, and comes back when cancelled', skip(), async () => {
    const { date, slot } = await nextFreeSlot(8);
    const [a] = ctx.clients;

    const booked = await book(a.token, slot.startsAt);
    assert.equal(booked.status, 201, booked.text);
    const appointment = booked.body;

    const offered = async () => {
      const res = await read(
        await fetch(
          `${ctx.base}/availability?serviceId=${ctx.service.id}&stylistId=${ctx.stylist.id}&date=${date}`,
        ),
      );
      assert.equal(res.status, 200, res.text);
      return res.body.slots.map((s) => s.startsAt);
    };

    assert.ok(
      !(await offered()).includes(slot.startsAt),
      'the booked slot should no longer be offered',
    );

    const cancelled = await read(
      await fetch(`${ctx.base}/appointments/${appointment.id}/cancel`, {
        method: 'POST',
        headers: { authorization: `Bearer ${a.token}` },
      }),
    );
    assert.equal(cancelled.status, 200, cancelled.text);

    assert.ok(
      (await offered()).includes(slot.startsAt),
      'the cancelled slot should be offered again',
    );
  });

  test('a booking rejects a time the engine never offered', skip(), async () => {
    const { date } = await nextFreeSlot(9);
    const [a] = ctx.clients;

    // 09:07 — a real minute inside opening hours, but off the 15-minute grid.
    const offGrid = ctx.time.localToInstant(date, 9 * 60 + 7, OFFSET).toISOString();
    const res = await book(a.token, offGrid);

    assert.equal(res.status, 422, res.text);
    assert.equal(res.body.error.code, 'SLOT_NOT_AVAILABLE');
  });
});
