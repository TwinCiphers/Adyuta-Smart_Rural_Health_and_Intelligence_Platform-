import { FastifyInstance } from 'fastify';

export default async function eduRoutes(fastify: FastifyInstance) {
  fastify.get('/edu/courses', async (request, reply) => {
    return await fastify.prisma.course.findMany({ take: 50 });
  });
}

