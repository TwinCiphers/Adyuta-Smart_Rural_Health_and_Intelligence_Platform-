import { FastifyInstance } from 'fastify';


export default async function dashboardRoutes(fastify: FastifyInstance) {
  // Use fastify.authenticate from our auth plugin
  fastify.get('/dashboard', { preValidation: [(fastify as any).authenticate] }, async (request, reply) => {
    const userId = (request.user as any).id;
    
    const user = await fastify.prisma.user.findUnique({
      where: { id: userId },
      select: { name: true, role: true }
    });

    if (!user) {
      return reply.status(404).send({ error: 'User not found' });
    }

    const domainProfiles = await fastify.prisma.domainProfile.findMany({
      where: { userId }
    });
    
    const activityFeed = await fastify.prisma.activityLog.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      take: 10
    });

    const defaults = ['health', 'agriculture', 'safety', 'education', 'governance'];
    const domains = defaults.map(d => {
      const existing = domainProfiles.find((p: any) => p.domain === d);
      return existing ? { domain: existing.domain, data: existing.data } : { domain: d, data: {} };
    });

    return reply.send({
      profile: { display_name: user.name, role: user.role },
      domains: domains,
      feed: activityFeed
    });
  });
}


