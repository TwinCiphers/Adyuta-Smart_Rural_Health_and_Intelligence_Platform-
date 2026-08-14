import { FastifyInstance, FastifyPluginAsync } from 'fastify';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const profileRoutes: FastifyPluginAsync = async (fastify: FastifyInstance) => {
  fastify.post('/profile', async (request, reply) => {
    try {
      const { id, name, role, phone, email, privacyAccepted } = request.body as any;

      if (!id || !name || !role) {
        return reply.status(400).send({ error: 'Missing required fields' });
      }

      // Upsert the user profile in Postgres
      const user = await prisma.user.upsert({
        where: { id },
        update: {
          name,
          role,
          privacyAccepted: privacyAccepted ? new Date() : null,
        },
        create: {
          id,
          name,
          role,
          phone,
          email,
          privacyAccepted: privacyAccepted ? new Date() : null,
        },
      });

      return reply.status(200).send({ success: true, user });
    } catch (error) {
      request.log.error(error);
      return reply.status(500).send({ error: 'Internal Server Error' });
    }
  });
};

export default profileRoutes;
