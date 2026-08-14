import { FastifyPluginAsync } from 'fastify';
import argon2 from 'argon2';
import crypto from 'crypto';
import { z } from 'zod';
import { SignupSchema, LoginSchema, RefreshSchema, LogoutSchema } from '../schemas/auth';

const authRoutes: FastifyPluginAsync = async (server) => {

  server.post('/signup', async (request, reply) => {
    try {
      const data = SignupSchema.parse(request.body);

      const existingUser = await server.prisma.user.findUnique({
        where: { email: data.email },
      });

      if (existingUser) {
        return reply.status(400).send({ error: 'Email already exists' });
      }

      const passwordHash = await argon2.hash(data.password);

      await server.prisma.user.create({
        data: {
          email: data.email,
          name: data.name,
          passwordHash,
        },
      });

      return reply.status(201).send({ message: 'User created' });
    } catch (err) {
      if (err instanceof z.ZodError) {
        return reply.status(400).send({ error: 'Invalid input', details: err.issues });
      }
      server.log.error(err);
      return reply.status(500).send({ error: 'Internal Server Error' });
    }
  });

  server.post('/login', {
    config: {
      rateLimit: {
        max: 5,
        timeWindow: '15 minutes'
      }
    }
  }, async (request, reply) => {
    try {
      const data = LoginSchema.parse(request.body);

      const user = await server.prisma.user.findUnique({
        where: { email: data.email },
      });

      if (!user) {
        // Sleep to prevent timing attacks / slow down brute force
        await new Promise(r => setTimeout(r, 1000));
        return reply.status(401).send({ error: 'Invalid credentials' });
      }

      const isValid = await argon2.verify(user.passwordHash, data.password);
      if (!isValid) {
        await new Promise(r => setTimeout(r, 1000));
        return reply.status(401).send({ error: 'Invalid credentials' });
      }

      // Generate Tokens
      const accessToken = server.jwt.sign({ 
        sub: user.id, 
        email: user.email || '',
        tokenVersion: user.tokenVersion
      }, { expiresIn: '15m' });
      
      const refreshToken = crypto.randomBytes(40).toString('hex');
      const refreshTokenHash = await argon2.hash(refreshToken);

      const thirtyDays = 30 * 24 * 60 * 60 * 1000;
      const expiresAt = new Date(Date.now() + thirtyDays);

      // Create or update session for this device
      const existingSession = await server.prisma.session.findFirst({
        where: { userId: user.id, deviceId: data.deviceId }
      });

      if (existingSession) {
        await server.prisma.session.update({
          where: { id: existingSession.id },
          data: {
            refreshTokenHash,
            revoked: false,
            lastUsedAt: new Date(),
            expiresAt,
            lastIp: request.ip
          }
        });
      } else {
        await server.prisma.session.create({
          data: {
            userId: user.id,
            deviceId: data.deviceId,
            refreshTokenHash,
            expiresAt,
            lastIp: request.ip
          }
        });
      }

      return reply.status(200).send({
        accessToken,
        refreshToken,
        expiresIn: 900, // 15 mins
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
        }
      });
    } catch (err) {
      if (err instanceof z.ZodError) {
        return reply.status(400).send({ error: 'Invalid input', details: err.issues });
      }
      server.log.error(err);
      return reply.status(500).send({ error: 'Internal Server Error' });
    }
  });

  server.post('/refresh', async (request, reply) => {
    try {
      const data = RefreshSchema.parse(request.body);
      const refreshToken = request.headers['x-refresh-token'];

      if (!refreshToken || typeof refreshToken !== 'string') {
        return reply.status(401).send({ error: 'Refresh token missing' });
      }

      // Find session by device ID (can also do by checking all sessions for a user, but this is faster)
      const sessions = await server.prisma.session.findMany({
        where: { deviceId: data.deviceId, revoked: false },
        include: { user: true }
      });

      let validSession = null;
      for (const session of sessions) {
        if (session.expiresAt < new Date()) {
          continue; // skip expired sessions
        }
        const isValid = await argon2.verify(session.refreshTokenHash, refreshToken);
        if (isValid) {
          validSession = session;
          break;
        }
      }

      if (!validSession) {
        return reply.status(401).send({ error: 'Invalid refresh token' });
      }

      const user = validSession.user;

      // Rotation
      const newRefreshToken = crypto.randomBytes(40).toString('hex');
      const newRefreshTokenHash = await argon2.hash(newRefreshToken);

      await server.prisma.session.update({
        where: { id: validSession.id },
        data: {
          refreshTokenHash: newRefreshTokenHash,
          lastUsedAt: new Date(),
          lastIp: request.ip
        }
      });

      const accessToken = server.jwt.sign({ 
        sub: user.id, 
        email: user.email || '',
        tokenVersion: user.tokenVersion
      }, { expiresIn: '15m' });

      return reply.status(200).send({
        accessToken,
        refreshToken: newRefreshToken,
        expiresIn: 900
      });

    } catch (err) {
      if (err instanceof z.ZodError) {
        return reply.status(400).send({ error: 'Invalid input' });
      }
      server.log.error(err);
      return reply.status(500).send({ error: 'Internal Server Error' });
    }
  });

  // Middleware to authenticate JWT
  const authenticate = async (request: any, reply: any) => {
    try {
      const decoded = await request.jwtVerify();
      // Check token version
      const user = await server.prisma.user.findUnique({
        where: { id: decoded.sub as string }
      });

      if (!user || user.tokenVersion !== decoded.tokenVersion) {
        throw new Error('Token revoked');
      }
      
      request.user = decoded;
    } catch (err) {
      reply.status(401).send({ error: 'Unauthorized' });
    }
  };

  server.post('/logout', { preValidation: [authenticate] }, async (request: any, reply) => {
    try {
      const data = LogoutSchema.parse(request.body);
      const userId = request.user.sub;

      await server.prisma.session.updateMany({
        where: {
          userId,
          deviceId: data.deviceId
        },
        data: {
          revoked: true
        }
      });

      return reply.send({ message: 'Logged out successfully' });
    } catch (err) {
      return reply.status(500).send({ error: 'Internal Server Error' });
    }
  });

  server.post('/logout-all', { preValidation: [authenticate] }, async (request: any, reply) => {
    try {
      const userId = request.user.sub;

      await server.prisma.$transaction([
        server.prisma.user.update({
          where: { id: userId },
          data: { tokenVersion: { increment: 1 } }
        }),
        server.prisma.session.updateMany({
          where: { userId },
          data: { revoked: true }
        })
      ]);

      return reply.send({ message: 'All sessions revoked' });
    } catch (err) {
      return reply.status(500).send({ error: 'Internal Server Error' });
    }
  });

};

export default authRoutes;
