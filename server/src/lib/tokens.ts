/**
 * Access and refresh tokens.
 *
 * Access tokens are short-lived JWTs the app sends as `Authorization: Bearer`.
 * They are self-contained — role included — so the common case (every request)
 * needs no database read at all.
 *
 * Refresh tokens are long-lived and therefore cannot be trusted to be
 * stateless: signing out on a lost phone has to mean something. So each one is
 * also a row in `RefreshToken`, stored as a SHA-256 hash, and `/auth/refresh`
 * rotates it — the presented token is revoked as the replacement is issued.
 * Reusing a rotated token fails, which is how token theft surfaces instead of
 * going unnoticed.
 *
 * Hashing here is SHA-256, not Argon2. The input is 32 bytes of CSPRNG output,
 * so there is nothing to brute-force; the hash exists only so a database dump
 * cannot be replayed, and it has to be cheap because it runs on every refresh.
 */
import { createHash, randomBytes, timingSafeEqual } from 'node:crypto';

import jwt, { type JwtPayload } from 'jsonwebtoken';
import type { Role } from '@prisma/client';

import { Config } from '../config';
import { unauthorized } from './errors';

export interface AccessTokenClaims {
  sub: string;
  email: string;
  role: Role;
  /** Present for staff, so the agenda routes need no extra lookup. */
  stylistId?: string | null;
}

export function signAccessToken(claims: AccessTokenClaims): string {
  return jwt.sign(claims, Config.auth.accessSecret, {
    expiresIn: `${Config.auth.accessTtlMinutes}m`,
    issuer: 'fresh-fadez',
    audience: 'fresh-fadez-app',
  });
}

export function verifyAccessToken(token: string): AccessTokenClaims {
  let payload: string | JwtPayload;
  try {
    payload = jwt.verify(token, Config.auth.accessSecret, {
      issuer: 'fresh-fadez',
      audience: 'fresh-fadez-app',
    });
  } catch (error) {
    // The app refreshes on TOKEN_EXPIRED and signs out on anything else, so
    // the two cases have to be distinguishable.
    if (error instanceof jwt.TokenExpiredError) {
      throw unauthorized('Your session has expired.', 'TOKEN_EXPIRED');
    }
    throw unauthorized('Your session is no longer valid.', 'TOKEN_INVALID');
  }

  if (typeof payload === 'string' || !payload.sub || !payload.role) {
    throw unauthorized('Your session is no longer valid.', 'TOKEN_INVALID');
  }
  return {
    sub: payload.sub,
    email: String(payload.email ?? ''),
    role: payload.role as Role,
    stylistId: (payload.stylistId as string | null | undefined) ?? null,
  };
}

/** A raw token for the client plus the hash to store. The raw one is never persisted. */
export interface OpaqueToken {
  token: string;
  tokenHash: string;
  expiresAt: Date;
}

export function createRefreshToken(): OpaqueToken {
  const token = randomBytes(32).toString('base64url');
  return {
    token,
    tokenHash: hashOpaqueToken(token),
    expiresAt: new Date(
      Date.now() + Config.auth.refreshTtlDays * 24 * 60 * 60_000,
    ),
  };
}

export function createPasswordResetToken(): OpaqueToken {
  const token = randomBytes(32).toString('base64url');
  return {
    token,
    tokenHash: hashOpaqueToken(token),
    expiresAt: new Date(
      Date.now() + Config.auth.passwordResetTtlMinutes * 60_000,
    ),
  };
}

export function hashOpaqueToken(token: string): string {
  return createHash('sha256').update(token).digest('hex');
}

/** Constant-time comparison, for the rare path that compares hashes directly. */
export function hashesMatch(a: string, b: string): boolean {
  const left = Buffer.from(a, 'utf8');
  const right = Buffer.from(b, 'utf8');
  if (left.length !== right.length) return false;
  return timingSafeEqual(left, right);
}
