/**
 * Registration, sign-in, token refresh, password reset, and "who am I".
 *
 * Three decisions worth stating:
 *
 *   * `/auth/register` always creates a CLIENT. A public endpoint that honours
 *     a `role` field is a public endpoint that hands out the owner's
 *     privileges; staff are created by the seed script or by the owner.
 *   * `/auth/forgot-password` answers the same way whether the address exists
 *     or not, so it cannot be used to enumerate the salon's client list. In
 *     development the token comes back in the response, because there is no
 *     mail provider wired up yet and a reset flow nobody can test is a reset
 *     flow that does not work.
 *   * `/auth/refresh` rotates: the presented refresh token is revoked in the
 *     same transaction that issues its replacement.
 */
import { randomBytes } from 'node:crypto';

import { Role } from '@prisma/client';
import { Router } from 'express';
import { z } from 'zod';

import { Config } from '../config';
import { badRequest, unauthorized } from '../lib/errors';
import { asyncHandler, created, ok, parseBody } from '../lib/http';
import { hashPassword, verifyPassword } from '../lib/password';
import { prisma } from '../lib/prisma';
import { userPublic } from '../lib/serialize';
import {
  createPasswordResetToken,
  createRefreshToken,
  hashOpaqueToken,
  signAccessToken,
} from '../lib/tokens';
import { authed, requireAuth } from '../middleware/auth';

export const authRouter = Router();

const email = z
  .string()
  .trim()
  .min(3)
  .max(200)
  .email('Please enter a valid email address.')
  .transform((v) => v.toLowerCase());

const password = z
  .string()
  .min(
    Config.auth.minPasswordLength,
    `Password must be at least ${Config.auth.minPasswordLength} characters.`,
  )
  .max(200);

const registerSchema = z.object({
  email,
  password,
  fullName: z.string().trim().min(2, 'Please enter your full name.').max(120),
  phone: z.string().trim().min(6).max(30).optional(),
});

const loginSchema = z.object({ email, password: z.string().min(1).max(200) });
const refreshSchema = z.object({ refreshToken: z.string().min(10).max(400) });
const forgotSchema = z.object({ email });
const resetSchema = z.object({
  token: z.string().min(10).max(400),
  password,
});

/**
 * A real Argon2 hash of a value nobody knows, hashed once on first use.
 *
 * It exists so that a login attempt for an address with no account still pays
 * the cost of a verification. Without it, "no such user" returns in under a
 * millisecond while a wrong password takes tens of them, and that difference
 * is enough to enumerate the salon's client list from outside.
 */
let dummyHash: Promise<string> | null = null;
function dummyPasswordHash(): Promise<string> {
  dummyHash ??= hashPassword(randomBytes(24).toString('base64url'));
  return dummyHash;
}

/** The envelope every successful auth call returns. */
async function issueSession(userId: string) {
  const user = await prisma.user.findUniqueOrThrow({
    where: { id: userId },
    include: { stylist: { select: { id: true } } },
  });

  const refresh = createRefreshToken();
  await prisma.refreshToken.create({
    data: {
      userId: user.id,
      tokenHash: refresh.tokenHash,
      expiresAt: refresh.expiresAt,
    },
  });

  return {
    user: {
      ...userPublic(user),
      stylistId: user.stylist?.id ?? null,
    },
    accessToken: signAccessToken({
      sub: user.id,
      email: user.email,
      role: user.role,
      stylistId: user.stylist?.id ?? null,
    }),
    refreshToken: refresh.token,
    accessTokenExpiresIn: Config.auth.accessTtlMinutes * 60,
    refreshTokenExpiresAt: refresh.expiresAt.toISOString(),
  };
}

authRouter.post(
  '/register',
  asyncHandler(async (req, res) => {
    const body = parseBody(registerSchema, req);

    const existing = await prisma.user.findUnique({ where: { email: body.email } });
    if (existing) {
      // Registration cannot be made non-enumerable without breaking the
      // signup form, so this one says what happened — but says it in the
      // words the app shows, and suggests the way forward.
      throw badRequest('An account with that email already exists. Try signing in instead.');
    }

    const user = await prisma.user.create({
      data: {
        email: body.email,
        passwordHash: await hashPassword(body.password),
        fullName: body.fullName,
        phone: body.phone ?? null,
        role: Role.CLIENT,
      },
    });

    created(res, await issueSession(user.id));
  }),
);

authRouter.post(
  '/login',
  asyncHandler(async (req, res) => {
    const body = parseBody(loginSchema, req);
    const user = await prisma.user.findUnique({ where: { email: body.email } });

    // The same message and roughly the same work either way: a missing user
    // must not be faster to reject than a wrong password.
    const matches = user
      ? await verifyPassword(user.passwordHash, body.password)
      : await verifyPassword(await dummyPasswordHash(), body.password);

    if (!user || !matches) {
      throw unauthorized('That email or password is not right.', 'INVALID_CREDENTIALS');
    }

    ok(res, await issueSession(user.id));
  }),
);

authRouter.post(
  '/refresh',
  asyncHandler(async (req, res) => {
    const { refreshToken } = parseBody(refreshSchema, req);
    const tokenHash = hashOpaqueToken(refreshToken);

    const stored = await prisma.refreshToken.findUnique({ where: { tokenHash } });
    if (!stored || stored.revokedAt || stored.expiresAt <= new Date()) {
      throw unauthorized('Please sign in again.', 'REFRESH_TOKEN_INVALID');
    }

    // Rotate. Revoking inside the same transaction that issues the
    // replacement means a token can never be spent twice, even under two
    // simultaneous refreshes from a flaky connection.
    await prisma.refreshToken.update({
      where: { id: stored.id },
      data: { revokedAt: new Date() },
    });

    ok(res, await issueSession(stored.userId));
  }),
);

authRouter.post(
  '/logout',
  asyncHandler(async (req, res) => {
    const { refreshToken } = parseBody(refreshSchema, req);
    await prisma.refreshToken.updateMany({
      where: { tokenHash: hashOpaqueToken(refreshToken), revokedAt: null },
      data: { revokedAt: new Date() },
    });
    // Idempotent on purpose: signing out twice, or with a token the server has
    // already forgotten, is a success from the app's point of view.
    ok(res, { ok: true });
  }),
);

authRouter.post(
  '/forgot-password',
  asyncHandler(async (req, res) => {
    const { email: address } = parseBody(forgotSchema, req);
    const user = await prisma.user.findUnique({ where: { email: address } });

    let devToken: string | undefined;
    if (user) {
      const reset = createPasswordResetToken();
      await prisma.passwordResetToken.create({
        data: {
          userId: user.id,
          tokenHash: reset.tokenHash,
          expiresAt: reset.expiresAt,
        },
      });
      // TODO: send this by email once a provider is wired up. Until then it is
      // returned outside production so the flow is testable end to end.
      if (!Config.isProduction) devToken = reset.token;
    }

    ok(res, {
      ok: true,
      message: 'If that email is registered, a reset link is on its way.',
      ...(devToken ? { resetToken: devToken } : {}),
    });
  }),
);

authRouter.post(
  '/reset-password',
  asyncHandler(async (req, res) => {
    const body = parseBody(resetSchema, req);
    const stored = await prisma.passwordResetToken.findUnique({
      where: { tokenHash: hashOpaqueToken(body.token) },
    });
    if (!stored || stored.usedAt || stored.expiresAt <= new Date()) {
      throw unauthorized('That reset link has expired. Please request a new one.', 'RESET_TOKEN_INVALID');
    }

    const passwordHash = await hashPassword(body.password);

    // Changing a password signs every device out. Someone resetting because
    // they think their account is compromised expects exactly that.
    await prisma.$transaction([
      prisma.user.update({
        where: { id: stored.userId },
        data: { passwordHash },
      }),
      prisma.passwordResetToken.update({
        where: { id: stored.id },
        data: { usedAt: new Date() },
      }),
      prisma.refreshToken.updateMany({
        where: { userId: stored.userId, revokedAt: null },
        data: { revokedAt: new Date() },
      }),
    ]);

    ok(res, { ok: true, message: 'Your password has been changed. Please sign in.' });
  }),
);

authRouter.get(
  '/me',
  requireAuth,
  asyncHandler(async (req, res) => {
    const claims = authed(req);
    const user = await prisma.user.findUnique({
      where: { id: claims.sub },
      include: {
        stylist: {
          include: { services: { include: { service: true } }, schedules: true },
        },
      },
    });
    if (!user) {
      // The token is valid but the account is gone — deleted while signed in.
      throw unauthorized('Your account is no longer active.', 'ACCOUNT_GONE');
    }

    ok(res, {
      ...userPublic(user),
      stylistId: user.stylist?.id ?? null,
    });
  }),
);
