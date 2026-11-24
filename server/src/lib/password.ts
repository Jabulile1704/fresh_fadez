/**
 * Password hashing with Argon2id.
 *
 * Argon2id is the current recommendation precisely because it is deliberately
 * expensive in both time and memory, which is what makes a stolen hash table
 * uneconomical to attack. The parameters below are the OWASP minimum
 * (19 MiB, 2 iterations) — comfortable on a free Render instance and still
 * several orders of magnitude harder than bcrypt at default cost.
 *
 * `@node-rs/argon2` is used rather than the `argon2` package because it ships
 * prebuilt N-API binaries for every platform this runs on, so `npm ci` on a
 * clean build host never has to compile C.
 */
import { Algorithm, hash, verify } from '@node-rs/argon2';

const OPTIONS = {
  algorithm: Algorithm.Argon2id,
  memoryCost: 19_456, // KiB — 19 MiB
  timeCost: 2,
  parallelism: 1,
} as const;

export function hashPassword(plain: string): Promise<string> {
  return hash(plain, OPTIONS);
}

/**
 * Never throws. A malformed stored hash — a row written by hand, or by an
 * older scheme — must read as "wrong password", not as a 500 that tells an
 * attacker the account exists.
 */
export async function verifyPassword(
  storedHash: string,
  plain: string,
): Promise<boolean> {
  try {
    return await verify(storedHash, plain);
  } catch {
    return false;
  }
}
