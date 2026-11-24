/**
 * The Express app, exported separately from the process that listens.
 *
 * Keeping `app.ts` free of `listen()` is what lets a test spin the whole API
 * up on an ephemeral port — which is how the concurrency test fires two real
 * HTTP bookings at once rather than calling a function twice and hoping that
 * resembles the real thing.
 */
import cors from 'cors';
import express from 'express';
import helmet from 'helmet';

import { Config } from './config';
import { errorHandler, notFoundHandler } from './middleware/error';
import { appointmentsRouter } from './routes/appointments';
import { authRouter } from './routes/auth';
import { availabilityRouter } from './routes/availability';
import { servicesRouter } from './routes/services';
import { staffRouter } from './routes/staff';
import { stylistsRouter } from './routes/stylists';

export function createApp() {
  const app = express();

  app.disable('x-powered-by');
  app.use(helmet());
  app.use(
    cors({
      origin: Config.corsOrigins.includes('*') ? true : Config.corsOrigins,
      methods: ['GET', 'POST', 'PATCH', 'PUT', 'DELETE', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization'],
    }),
  );
  // A booking payload is a few hundred bytes; anything near this limit is a
  // mistake or an attack.
  app.use(express.json({ limit: '100kb' }));

  if (!Config.isProduction) {
    app.use((req, _res, next) => {
      console.log(`${req.method} ${req.originalUrl}`);
      next();
    });
  }

  /**
   * Liveness, and Render's health check. Touches no database on purpose: a
   * free instance cold-starts on every ping, and a health check that opens a
   * connection is a health check that exhausts the pool.
   */
  app.get('/', (_req, res) => {
    res.json({
      service: 'fresh-fadez-api',
      salon: Config.salon.name,
      status: 'ok',
      env: Config.env,
    });
  });

  app.use('/auth', authRouter);
  app.use('/services', servicesRouter);
  app.use('/stylists', stylistsRouter);
  app.use('/appointments', appointmentsRouter);
  app.use('/staff', staffRouter);
  // Mounted at the root because its paths are `/availability` and `/salon`.
  app.use('/', availabilityRouter);

  app.use(notFoundHandler);
  app.use(errorHandler);

  return app;
}

export default createApp;
