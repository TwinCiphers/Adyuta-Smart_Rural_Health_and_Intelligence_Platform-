import { FastifyPluginAsync } from 'fastify';

const marketplaceRoutes: FastifyPluginAsync = async (server) => {
  server.get('/marketplace/products', async (request, reply) => {
    const products = await server.prisma.product.findMany();
    return reply.send({ products });
  });

  // Protected routes for Cart
  server.register(async (protectedServer) => {
    protectedServer.addHook('preValidation', (protectedServer as any).authenticate);

    protectedServer.get('/marketplace/cart', async (request, reply) => {
      const userId = (request.user as any).id;
      const cartItems = await protectedServer.prisma.cartItem.findMany({
        where: { userId },
        include: { product: true }
      });
      return reply.send({ cartItems });
    });

    protectedServer.post('/marketplace/cart', async (request, reply) => {
      const userId = (request.user as any).id;
      const { productId, quantity } = request.body as { productId: string, quantity: number };
      
      const item = await protectedServer.prisma.cartItem.create({
        data: { userId, productId, quantity }
      });
      return reply.send({ item });
    });
  });
};

export default marketplaceRoutes;
