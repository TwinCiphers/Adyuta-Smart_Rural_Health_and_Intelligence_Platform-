import { FastifyInstance } from 'fastify';

export default async function govRoutes(fastify: FastifyInstance) {
  fastify.get('/gov/schemes', async (request, reply) => {
    return await fastify.prisma.governmentScheme.findMany({ take: 50 });
  });
}

