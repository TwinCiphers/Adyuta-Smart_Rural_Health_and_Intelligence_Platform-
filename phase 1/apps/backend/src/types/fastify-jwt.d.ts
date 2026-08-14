import '@fastify/jwt';

declare module '@fastify/jwt' {
  interface FastifyJWT {
    payload: {
      sub: string;
      email: string;
      tokenVersion: number;
    };
    user: {
      sub: string;
      email: string;
      tokenVersion: number;
    };
  }
}
