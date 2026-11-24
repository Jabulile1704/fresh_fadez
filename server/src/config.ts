/**
 * Every tunable number in one place.
 *
 * The booking rules here are the ones the salon owner will want changed after
 * a fortnight of real use ("two hours' notice is too much", "open the diary
 * three months out"), so they are environment variables rather than literals
 * buried in a handler. Defaults are the sensible starting point, not a
 * requirement — the server boots with none of them set.
 */
import { config as loadEnv } from 'dotenv';

loadEnv();

function int(name: string, fallback: number): number {
  const raw = process.env[name];
  if (raw === undefined || raw.trim() === '') return fallback;
  const value = Number(raw);
  if (!Number.isFinite(value)) {
    throw new Error(`${name} must be a number, got "${raw}".`);
  }
  return Math.trunc(value);
}

function str(name: string, fallback?: string): string {
  const raw = process.env[name];
  if (raw === undefined || raw.trim() === '') {
    if (fallback !== undefined) return fallback;
    throw new Error(`${name} must be set.`);
  }
  return raw.trim();
}

const isProduction = process.env.NODE_ENV === 'production';

/**
 * In production a missing secret must stop the deploy, not quietly fall back
 * to a value that is in a public repository. In development the fallback keeps
 * `npm run dev` working on a fresh clone with no .env at all.
 */
function secret(name: string): string {
  if (isProduction) {
    const value = str(name);
    if (value.length < 32) {
      throw new Error(`${name} must be at least 32 characters in production.`);
    }
    return value;
  }
  return str(name, `dev-only-insecure-${name.toLowerCase()}-do-not-ship`);
}

export const Config = {
  env: process.env.NODE_ENV ?? 'development',
  isProduction,
  port: int('PORT', 8080),

  /**
   * Allowed CORS origins. The Flutter app sends no cookies and authenticates
   * with a bearer token, so a permissive default costs nothing; a browser
   * admin panel would want this narrowed.
   */
  corsOrigins: str('CORS_ORIGINS', '*')
    .split(',')
    .map((o) => o.trim())
    .filter(Boolean),

  auth: {
    accessSecret: secret('JWT_ACCESS_SECRET'),
    refreshSecret: secret('JWT_REFRESH_SECRET'),
    accessTtlMinutes: int('ACCESS_TOKEN_TTL_MINUTES', 30),
    refreshTtlDays: int('REFRESH_TOKEN_TTL_DAYS', 30),
    passwordResetTtlMinutes: int('PASSWORD_RESET_TTL_MINUTES', 30),
    minPasswordLength: 8,
  },

  booking: {
    /**
     * The salon's local time as a fixed offset from UTC, in minutes.
     * Africa/Johannesburg is UTC+2 the whole year — South Africa observes no
     * daylight saving — so one offset is the correct model, not a shortcut.
     * A salon that ever opens somewhere with DST needs a real tz database
     * here, and the availability engine would not change: it already takes
     * absolute instants.
     */
    utcOffsetMinutes: int('SALON_UTC_OFFSET_MINUTES', 120),
    /** Soonest a client may book, measured from now. */
    leadTimeMinutes: int('MIN_BOOKING_LEAD_MINUTES', 120),
    /** Grid the offered start times sit on. */
    slotStepMinutes: int('SLOT_GRANULARITY_MINUTES', 15),
    /** How far ahead the diary is open. */
    maxDaysAhead: int('MAX_BOOKING_DAYS_AHEAD', 60),
    /** Clients may not cancel inside this window. Staff always may. */
    cancellationWindowHours: int('CANCELLATION_WINDOW_HOURS', 4),
  },

  salon: {
    name: 'After8 Hair Salon',
    brand: 'Fresh Fadez',
    address: '123 Willows Street, Bloemfontein',
    phone: '+27 (51) 123-4567',
    currency: 'ZAR',
  },
} as const;

export type AppConfig = typeof Config;
