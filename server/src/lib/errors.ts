/**
 * One error type for the whole API.
 *
 * Every failure the app can act on carries three things: an HTTP status, a
 * stable machine `code` the Flutter layer can branch on, and a `message`
 * written for a client reading it on a phone. The codes matter more than they
 * look — `SLOT_TAKEN` is what lets the booking screen say "that slot was just
 * taken, here are the next three" instead of a generic red banner.
 */
export class ApiError extends Error {
  readonly status: number;
  readonly code: string;
  readonly details?: unknown;

  constructor(
    status: number,
    code: string,
    message: string,
    details?: unknown,
  ) {
    super(message);
    this.name = 'ApiError';
    this.status = status;
    this.code = code;
    this.details = details;
  }

  toJSON() {
    return {
      error: {
        code: this.code,
        message: this.message,
        ...(this.details === undefined ? {} : { details: this.details }),
      },
    };
  }
}

export const badRequest = (message: string, details?: unknown) =>
  new ApiError(400, 'BAD_REQUEST', message, details);

export const validationFailed = (details: unknown) =>
  new ApiError(422, 'VALIDATION_FAILED', 'Please check the details you entered.', details);

export const unauthorized = (
  message = 'Please sign in and try again.',
  code = 'UNAUTHORIZED',
) => new ApiError(401, code, message);

export const forbidden = (message = 'You do not have access to do that.') =>
  new ApiError(403, 'FORBIDDEN', message);

export const notFound = (message: string) =>
  new ApiError(404, 'NOT_FOUND', message);

export const conflict = (code: string, message: string, details?: unknown) =>
  new ApiError(409, code, message, details);

/**
 * The one the booking screen cares about most: the slot was free when it was
 * offered and is not free now.
 */
export const slotTaken = (details?: unknown) =>
  conflict(
    'SLOT_TAKEN',
    'That time was just booked by someone else. Please pick another slot.',
    details,
  );

export const unprocessable = (code: string, message: string) =>
  new ApiError(422, code, message);

export const tooManyRequests = (message: string) =>
  new ApiError(429, 'TOO_MANY_REQUESTS', message);

export const internal = (message = 'Something went wrong. Please try again.') =>
  new ApiError(500, 'INTERNAL', message);

/** The two exclusion constraints created by the raw-SQL migration. */
export const STYLIST_OVERLAP_CONSTRAINT = 'appointment_no_overlap';
export const CLIENT_OVERLAP_CONSTRAINT = 'appointment_client_no_overlap';

/** SQLSTATE `exclusion_violation`. */
const EXCLUSION_VIOLATION = '23P01';

/**
 * Flattens a Prisma error into one searchable string.
 *
 * Prisma reports a constraint violation it does not model through several
 * different error classes depending on whether the statement came from the
 * query builder or from raw SQL, and the shape has moved between versions. The
 * SQLSTATE and the constraint name are always *somewhere* in there, and both
 * are specific enough that searching for them cannot plausibly match
 * something else — which is far more durable than matching a class.
 */
function errorText(error: unknown): string {
  if (!error || typeof error !== 'object') return '';
  const meta = (error as { meta?: unknown }).meta;
  return [
    (error as { message?: unknown }).message,
    (error as { code?: unknown }).code,
    meta ? JSON.stringify(meta) : '',
  ]
    .filter((v) => typeof v === 'string' || typeof v === 'number')
    .join(' ');
}

/** Any exclusion violation from the appointment table. */
export function isOverlapError(error: unknown): boolean {
  const text = errorText(error);
  return (
    text.includes(EXCLUSION_VIOLATION) ||
    text.includes(STYLIST_OVERLAP_CONSTRAINT) ||
    text.includes(CLIENT_OVERLAP_CONSTRAINT)
  );
}

/** The client already has an appointment across the requested time. */
export function isClientOverlapError(error: unknown): boolean {
  return errorText(error).includes(CLIENT_OVERLAP_CONSTRAINT);
}

/** The stylist's chair is already taken across the requested time. */
export function isStylistOverlapError(error: unknown): boolean {
  if (isClientOverlapError(error)) return false;
  return isOverlapError(error);
}

export const clientDoubleBooked = () =>
  conflict(
    'CLIENT_DOUBLE_BOOKED',
    'You already have an appointment at that time.',
  );
