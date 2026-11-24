/**
 * Authentication and role enforcement, as middleware.
 *
 * Roles are checked here and nowhere else. A handler that wants staff asks for
 * staff in its route definition (`router.post('/x', requireStaff, ...)`) and
 * can then assume it has them. The alternative — an `if (user.role !== ...)`
 * at the top of each handler — is the arrangement where the twelfth handler
 * forgets, and the forgetting is invisible in review.
 *
 * The only per-record judgement left to a handler is ownership ("is this *my*
 * appointment"), which middleware cannot know; `assertCanActOn` below is the
 * shared helper for that so the rule is still written once.
 */
import { Role } from '@prisma/client';
import type { NextFunction, Request, RequestHandler, Response } from 'express';

import { forbidden, unauthorized } from '../lib/errors';
import { AccessTokenClaims, verifyAccessToken } from '../lib/tokens';

declare global {
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace Express {
    interface Request {
      auth?: AccessTokenClaims;
    }
  }
}

function readBearer(req: Request): string | null {
  const header = req.get('authorization');
  if (!header) return null;
  const [scheme, token] = header.split(' ');
  if (!token || scheme.toLowerCase() !== 'bearer') return null;
  return token.trim() || null;
}

/** Rejects the request unless a valid access token is present. */
export const requireAuth: RequestHandler = (req, _res, next) => {
  const token = readBearer(req);
  if (!token) {
    next(unauthorized('Please sign in and try again.', 'TOKEN_MISSING'));
    return;
  }
  try {
    req.auth = verifyAccessToken(token);
    next();
  } catch (error) {
    next(error);
  }
};

/**
 * Attaches the caller if they sent a token, and carries on if they did not.
 * Used by the public catalogue routes, which show the same services to
 * everyone but can personalise when they know who is asking.
 */
export const optionalAuth: RequestHandler = (req, _res, next) => {
  const token = readBearer(req);
  if (!token) {
    next();
    return;
  }
  try {
    req.auth = verifyAccessToken(token);
  } catch {
    // A stale token on a public route is not an error worth failing over.
  }
  next();
};

export function requireRole(...roles: Role[]): RequestHandler {
  return (req: Request, _res: Response, next: NextFunction) => {
    if (!req.auth) {
      next(unauthorized('Please sign in and try again.', 'TOKEN_MISSING'));
      return;
    }
    if (!roles.includes(req.auth.role)) {
      next(forbidden('You do not have access to do that.'));
      return;
    }
    next();
  };
}

/** Anyone who works at the salon. */
export const requireStaff = requireRole(Role.STYLIST, Role.OWNER);

/** The owner only — the catalogue and anything priced. */
export const requireOwner = requireRole(Role.OWNER);

/** Narrows `req.auth` for handlers that sit behind `requireAuth`. */
export function authed(req: Request): AccessTokenClaims {
  if (!req.auth) {
    // Reaching here means a route was mounted without `requireAuth`, which is
    // a wiring mistake, not a client error.
    throw unauthorized('Please sign in and try again.', 'TOKEN_MISSING');
  }
  return req.auth;
}

export const isStaff = (claims: AccessTokenClaims): boolean =>
  claims.role === Role.STYLIST || claims.role === Role.OWNER;

/**
 * The ownership rule, written once: a client may act on their own records, a
 * stylist on records attached to them, and the owner on anything.
 */
export function assertCanActOn(
  claims: AccessTokenClaims,
  record: { userId: string; stylistId?: string | null },
): void {
  if (claims.role === Role.OWNER) return;
  if (record.userId === claims.sub) return;
  if (
    claims.role === Role.STYLIST &&
    claims.stylistId &&
    record.stylistId === claims.stylistId
  ) {
    return;
  }
  throw forbidden('You do not have access to do that.');
}
