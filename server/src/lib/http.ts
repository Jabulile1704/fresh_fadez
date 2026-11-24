/**
 * Express plumbing: async handlers, request validation, and the serialisers
 * that decide the exact JSON the Flutter data layer parses.
 */
import type { NextFunction, Request, RequestHandler, Response } from 'express';
import { ZodError, type ZodTypeAny, type z } from 'zod';

import { validationFailed } from './errors';

/**
 * Express 4 does not catch a rejected promise from a handler, so an `await`
 * that throws becomes a request that hangs until the client times out. Every
 * async route in this server is wrapped in this.
 */
export function asyncHandler(
  fn: (req: Request, res: Response, next: NextFunction) => Promise<unknown>,
): RequestHandler {
  return (req, res, next) => {
    fn(req, res, next).catch(next);
  };
}

/** Flattens a Zod failure into `{ field: [messages] }`, which the app shows per input. */
function formatZodError(error: ZodError): Record<string, string[]> {
  const out: Record<string, string[]> = {};
  for (const issue of error.issues) {
    const key = issue.path.length ? issue.path.join('.') : '_';
    (out[key] ??= []).push(issue.message);
  }
  return out;
}

export function parseBody<S extends ZodTypeAny>(
  schema: S,
  req: Request,
): z.infer<S> {
  try {
    return schema.parse(req.body ?? {});
  } catch (error) {
    if (error instanceof ZodError) throw validationFailed(formatZodError(error));
    throw error;
  }
}

export function parseQuery<S extends ZodTypeAny>(
  schema: S,
  req: Request,
): z.infer<S> {
  try {
    return schema.parse(req.query ?? {});
  } catch (error) {
    if (error instanceof ZodError) throw validationFailed(formatZodError(error));
    throw error;
  }
}

export const ok = (res: Response, body: unknown) => res.status(200).json(body);
export const created = (res: Response, body: unknown) => res.status(201).json(body);
export const noContent = (res: Response) => res.status(204).end();
