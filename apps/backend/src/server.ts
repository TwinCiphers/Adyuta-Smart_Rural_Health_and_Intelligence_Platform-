import Fastify from 'fastify';
import cors from '@fastify/cors';
import helmet from '@fastify/helmet';
import fastifyJwt from '@fastify/jwt';
import fastifyRateLimit from '@fastify/rate-limit';
import fs from 'fs';
import path from 'path';

import prismaPlugin from './plugins/prisma';
import redisPlugin from './plugins/redis';
import authRoutes from './routes/auth';
import otpRoutes from './routes/otp';

const buildServer = async () => {
  const server = Fastify({
    logger: true,
  });

  // Security headers
  await server.register(helmet);

  // CORS - restrict to your app's domain in production
  await server.register(cors, {
    origin: '*', 
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
  });

  // Register Prisma and Redis
  await server.register(prismaPlugin);
  await server.register(redisPlugin);

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
    redis: server.redis, // use the redis instance from our plugin
  });

  // Routes
  server.register(authRoutes, { prefix: '/api/auth' });
  server.register(otpRoutes, { prefix: '/api/auth/otp' });

  // Health check route
  server.get('/', async (request, reply) => {
    return reply.send({ status: 'ok', message: 'ADYUTA Auth API is running smoothly!' });
  });

  return server;
};

export default buildServer;
