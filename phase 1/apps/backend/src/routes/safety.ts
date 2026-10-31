import { FastifyInstance } from 'fastify';

export default async function safetyRoutes(fastify: FastifyInstance) {
  fastify.post('/safety/sos', { preValidation: [(fastify as any).authenticate] }, async (request, reply) => {
    const userId = (request.user as any).id;
    const { latitude, longitude } = request.body as any;
    const alert = await fastify.prisma.sosAlert.create({
      data: { userId, latitude, longitude }
    });
    // In real app, trigger websocket broadcast here
    return reply.status(201).send(alert);
  });
}



