import fp from 'fastify-plugin';
import Redis from 'ioredis';

export default fp(async (server, options) => {
  const redisUrl = process.env.REDIS_URL || 'redis://localhost:6379';
  const redis = new Redis(redisUrl);

  server.decorate('redis', redis);

  server.addHook('onClose', async (server) => {
    await server.redis.quit();
  });
});

declare module 'fastify' {
  interface FastifyInstance {
    redis: Redis;
  }
}
