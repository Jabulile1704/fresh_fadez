/**
 * The one Prisma client for the process.
 *
 * A single instance matters more than it usually does here: each client owns
 * its own connection pool, and Render's free Postgres allows very few
 * connections. Two clients is a server that works in development and runs out
 * of connections in production.
 */
import { PrismaClient } from '@prisma/client';

import { Config } from '../config';

export const prisma = new PrismaClient({
  // Under test, Prisma's own `error` log prints a full stack for every
  // exclusion-constraint rejection — and in the concurrency tests those
  // rejections are the expected result, so the real output drowns in them.
  // Everywhere else the log stays on: a query error nobody prints is a query
  // error nobody notices.
  log: Config.env === 'test' ? ['warn'] : ['warn', 'error'],
});

export async function disconnect(): Promise<void> {
  await prisma.$disconnect();
}
