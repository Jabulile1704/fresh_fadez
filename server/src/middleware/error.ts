/**
 * The single exit for every failure.
 *
 * Two rules hold throughout: the response body always has the same shape,
 * `{ error: { code, message, details? } }`, so the Flutter layer has one
 * parser; and nothing a client sees mentions Prisma, SQL or a stack trace.
 * Unrecognised errors are logged in full on the server and reported as a flat
 * INTERNAL, because an error message is the cheapest way to leak a schema.
 */
import type { ErrorRequestHandler, RequestHandler } from 'express';

import { ApiError, isOverlapError, slotTaken } from '../lib/errors';

export const notFoundHandler: RequestHandler = (req, res) => {
  res.status(404).json({
    error: {
      code: 'NOT_FOUND',
      message: `No such endpoint: ${req.method} ${req.path}`,
    },
  });
};

export const errorHandler: ErrorRequestHandler = (error, _req, res, _next) => {
  if (error instanceof ApiError) {
    res.status(error.status).json(error.toJSON());
    return;
  }

  // An overlap that escaped a route's own handling is still a slot conflict,
  // and far more useful to the app as a 409 than as a 500.
  if (isOverlapError(error)) {
    const conflictError = slotTaken();
    res.status(conflictError.status).json(conflictError.toJSON());
    return;
  }

  // Prisma's own codes, for the handful that map cleanly onto HTTP.
  const code = (error as { code?: string }).code;
  if (code === 'P2002') {
    res.status(409).json({
      error: {
        code: 'ALREADY_EXISTS',
        message: 'That record already exists.',
      },
    });
    return;
  }
  if (code === 'P2025') {
    res.status(404).json({
      error: { code: 'NOT_FOUND', message: 'That record no longer exists.' },
    });
    return;
  }
  if (error instanceof SyntaxError && 'body' in error) {
    res.status(400).json({
      error: { code: 'MALFORMED_JSON', message: 'The request body is not valid JSON.' },
    });
    return;
  }

  console.error('Unhandled error', error);
  res.status(500).json({
    error: {
      code: 'INTERNAL',
      message: 'Something went wrong. Please try again.',
    },
  });
};
