import Fastify from 'fastify';
import cors from '@fastify/cors';
import helmet from '@fastify/helmet';
import fastifyJwt from '@fastify/jwt';
import fastifyRateLimit from '@fastify/rate-limit';
import fs from 'fs';
import path from 'path';

import prismaPlugin from './plugins/prisma';
// No redis
import authRoutes from './routes/auth';
import otpRoutes from './routes/otp';
import profileRoutes from './routes/profile';
import healthRoutes from './routes/health';
import agriRoutes from './routes/agri';
import govRoutes from './routes/gov';
import eduRoutes from './routes/edu';
import safetyRoutes from './routes/safety';
import dashboardRoutes from './routes/dashboard';
import marketplaceRoutes from './routes/marketplace';

const buildServer = async () => {
  const server = Fastify({
    logger: true,
  });

  // Security headers
  await server.register(helmet);

  // CORS - restrict to your app's domain in production
  await server.register(cors, {
    origin: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'x-refresh-token'],
    credentials: true,
  });

  // Register Prisma and Redis
  await server.register(prismaPlugin);
  // Real JWT Authenticate
  server.decorate('authenticate', async (request: any, reply: any) => {
    try {
      await request.jwtVerify();
      const user = await server.prisma.user.findUnique({
        where: { id: request.user.sub as string }
      });
      if (!user || user.tokenVersion !== request.user.tokenVersion) {
        throw new Error('Token revoked');
      }
      request.user = { id: user.id, email: user.email, role: user.role };
    } catch (err) {
      server.log.error(err); reply.status(401).send({ error: 'Unauthorized', detail: String(err) });
    }
  });

  // No redis

  // Read RSA keys for JWT
  const keysDir = path.join(__dirname, '../keys');
  const publicKey = fs.readFileSync(path.join(keysDir, 'public.pem'), 'utf8');
  const privateKey = fs.readFileSync(path.join(keysDir, 'private.pem'), 'utf8');

  // JWT configuration
  await server.register(fastifyJwt, {
    secret: {
      private: privateKey,
      public: publicKey,
    },
    sign: { algorithm: 'RS256' },
  });

  // Rate Limiting
  await server.register(fastifyRateLimit, {
    max: 100,
    timeWindow: '1 minute',
    // No redis // use the redis instance from our plugin
  });

  // Routes
  server.register(authRoutes, { prefix: '/api/auth' });
  server.register(otpRoutes, { prefix: '/api/auth/otp' });
  server.register(profileRoutes, { prefix: '/api' });
  server.register(healthRoutes, { prefix: '/api' });
  server.register(agriRoutes, { prefix: '/api' });
  server.register(govRoutes, { prefix: '/api' });
  server.register(eduRoutes, { prefix: '/api' });
  server.register(safetyRoutes, { prefix: '/api' });
  server.register(dashboardRoutes, { prefix: '/api' });
  server.register(marketplaceRoutes, { prefix: '/api/agri' });

  // Health check route
  server.get('/', async (request, reply) => {
    return reply.send({ status: 'ok', message: 'ADYUTA Auth API is running smoothly!' });
  });

  return server;
};

export default buildServer;









