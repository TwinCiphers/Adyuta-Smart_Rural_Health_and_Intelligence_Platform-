import { FastifyInstance } from 'fastify';

export default async function healthRoutes(fastify: FastifyInstance) {
  fastify.get('/health/hospitals', async (request, reply) => {
    return await fastify.prisma.hospital.findMany({ take: 20 });
  });
  fastify.get('/health/pharmacies', async (request, reply) => {
    return await fastify.prisma.pharmacy.findMany({ take: 20 });
  });
}

