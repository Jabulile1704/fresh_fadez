/**
 * Process entry point: start listening, and shut down without dropping
 * in-flight requests.
 *
 * The graceful shutdown is not ceremony on Render — a deploy sends SIGTERM,
 * and a server that exits immediately turns the last few requests into failed
 * bookings for whoever happened to be tapping "confirm".
 */
import type { Server } from 'node:http';

import { createApp } from './app';
import { Config } from './config';
import { disconnect, prisma } from './lib/prisma';

async function main(): Promise<void> {
  // Fail at boot, not on the first booking, if the database is unreachable.
  await prisma.$queryRaw`SELECT 1`;

  const app = createApp();
  const server: Server = app.listen(Config.port, () => {
    console.log(`fresh-fadez-api listening on :${Config.port} (${Config.env})`);
  });

  const shutdown = (signal: string) => {
    console.log(`${signal} received, shutting down`);
    server.close(async () => {
      await disconnect();
      process.exit(0);
    });
    // If a request is wedged, do not hang the deploy forever.
    setTimeout(() => process.exit(1), 10_000).unref();
  };

  process.on('SIGTERM', () => shutdown('SIGTERM'));
  process.on('SIGINT', () => shutdown('SIGINT'));
}

main().catch((error) => {
  console.error('Failed to start fresh-fadez-api', error);
  process.exit(1);
});
