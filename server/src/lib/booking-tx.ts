/**
 * The transaction wrapper every appointment write goes through.
 *
 * ### Why this exists
 *
 * The exclusion constraint on `Appointment` is what makes double-booking
 * impossible, and it does that job perfectly. But *how* PostgreSQL enforces it
 * under concurrency is worth knowing, because it surprised this codebase once
 * already.
 *
 * For a unique index, two concurrent conflicting inserts are resolved by
 * speculative insertion: one waits briefly, then gets a clean unique
 * violation. Exclusion constraints have no such path. Each inserter finds the
 * other's uncommitted tuple and waits for that transaction to finish — so two
 * simultaneous bookings for the same slot wait on *each other*, and PostgreSQL
 * breaks the cycle by aborting one with SQLSTATE 40P01, `deadlock detected`.
 *
 * A deadlock is not a useful answer to give a client tapping "confirm". It is
 * also not the right answer: the slot was taken, and the app should be told
 * that in the one way it knows how to handle.
 *
 * So two things happen here.
 *
 * **An advisory lock makes the common case orderly.** Before inserting, the
 * transaction takes a transaction-scoped advisory lock on the stylist and then
 * on the client, always in that order. Two bookings for the same stylist
 * therefore queue instead of racing: the first inserts and commits, the second
 * wakes to find a *committed* conflicting row and gets a clean 23P01, which
 * becomes a 409 `SLOT_TAKEN`. The fixed lock order is what keeps the locks
 * themselves deadlock-free.
 *
 * This is emphatically *not* a read-then-write check wearing a hat. The lock
 * does not decide whether the slot is free — the constraint still does, and
 * still would if this file were deleted. The lock only decides who asks first,
 * turning a deadlock into a queue.
 *
 * **A retry covers everything else.** Another writer — a migration, a script,
 * a future endpoint that forgets this helper — can still produce a deadlock,
 * and a retry resolves it correctly every time: the winner has committed by
 * then, so the retry sees the row and fails with 23P01 instead. Retrying is
 * safe because the whole transaction is rolled back first, so nothing is
 * written twice.
 */
import { Prisma } from '@prisma/client';

import { prisma } from './prisma';

/**
 * Advisory lock namespaces. Arbitrary but fixed: `pg_advisory_xact_lock` takes
 * two int4s, and keeping stylist and client keys in separate namespaces stops
 * a stylist id hashing onto the same lock as an unrelated client id.
 */
const STYLIST_LOCK_NAMESPACE = 8471;
const CLIENT_LOCK_NAMESPACE = 8472;

/** `deadlock_detected` and `serialization_failure`. */
const RETRYABLE_SQLSTATES = ['40P01', '40001'];

const MAX_ATTEMPTS = 4;

export function isRetryableTransactionError(error: unknown): boolean {
  if (!error || typeof error !== 'object') return false;
  const meta = (error as { meta?: unknown }).meta;
  const text = [
    (error as { message?: unknown }).message,
    meta ? JSON.stringify(meta) : '',
  ]
    .filter((v) => typeof v === 'string')
    .join(' ');
  return RETRYABLE_SQLSTATES.some((code) => text.includes(code));
}

export interface BookingLockKeys {
  stylistId: string;
  /** The client the appointment belongs to. */
  userId: string;
}

/**
 * Runs `work` in a transaction that holds the stylist and client booking
 * locks, retrying the whole thing if PostgreSQL reports a deadlock or
 * serialisation failure.
 *
 * `work` must be idempotent in the sense that running it twice from a
 * rolled-back start is harmless — true of a single insert or update, which is
 * all it is ever given.
 */
export async function withBookingLock<T>(
  keys: BookingLockKeys,
  work: (tx: Prisma.TransactionClient) => Promise<T>,
): Promise<T> {
  let lastError: unknown;

  for (let attempt = 1; attempt <= MAX_ATTEMPTS; attempt += 1) {
    try {
      return await prisma.$transaction(async (tx) => {
        // Always stylist first, then client. A consistent global order is the
        // whole reason these locks cannot deadlock against each other.
        // The `::int4` casts are required: Prisma binds a JavaScript number as
        // bigint, and `pg_advisory_xact_lock` has no (bigint, integer) overload.
        await tx.$executeRaw`SELECT pg_advisory_xact_lock(${STYLIST_LOCK_NAMESPACE}::int4, hashtext(${keys.stylistId}))`;
        await tx.$executeRaw`SELECT pg_advisory_xact_lock(${CLIENT_LOCK_NAMESPACE}::int4, hashtext(${keys.userId}))`;
        return work(tx);
      });
    } catch (error) {
      if (!isRetryableTransactionError(error) || attempt === MAX_ATTEMPTS) {
        throw error;
      }
      lastError = error;
      // A short, growing, jittered pause. Without the jitter two retrying
      // transactions march in step and deadlock again at the same moment.
      await sleep(attempt * 10 + Math.random() * 15);
    }
  }

  throw lastError;
}

const sleep = (ms: number) =>
  new Promise<void>((resolve) => {
    setTimeout(resolve, ms);
  });
