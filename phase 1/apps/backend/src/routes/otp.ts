import { FastifyPluginAsync } from 'fastify';
import crypto from 'crypto';
import argon2 from 'argon2';
import { z } from 'zod';
import { SendOTPSchema, VerifyOTPSchema } from '../schemas/auth';

const otpRoutes: FastifyPluginAsync = async (server) => {

  server.post('/send', {
    config: {
      rateLimit: {
        max: 3,
        timeWindow: '5 minutes'
      }
    }
  }, async (request, reply) => {
    try {
      const data = SendOTPSchema.parse(request.body);

      // Generate a 6-digit OTP
      const otpCode = Math.floor(100000 + Math.random() * 900000).toString();
      
      // Store OTP in Redis with a 5-minute TTL
      const redisKey = `otp:${data.phoneNumber}`;
      await server.redis.set(redisKey, otpCode, 'EX', 300);

      // TODO: Integrate with real SMS provider (Twilio, Supabase, AWS SNS) here
      // For now, we just log it
      server.log.info(`[MOCK SMS] Sent OTP ${otpCode} to ${data.phoneNumber}`);

      return reply.send({ message: 'OTP sent successfully' });
    } catch (err) {
      if (err instanceof z.ZodError) {
        return reply.status(400).send({ error: 'Invalid input', details: err.issues });
      }
      server.log.error(err);
      return reply.status(500).send({ error: 'Internal Server Error' });
    }
  });

  server.post('/verify', async (request, reply) => {
    try {
      const data = VerifyOTPSchema.parse(request.body);
      const redisKey = `otp:${data.phoneNumber}`;

      const storedOtp = await server.redis.get(redisKey);
      
      if (!storedOtp || storedOtp !== data.otpCode) {
        return reply.status(401).send({ error: 'Invalid or expired OTP' });
      }

      // OTP is valid, delete it from Redis
      await server.redis.del(redisKey);

      // Find or create user by phone number
      let user = await server.prisma.user.findUnique({
        where: { phoneNumber: data.phoneNumber }
      });

      if (!user) {
        user = await server.prisma.user.create({
          data: {
            phoneNumber: data.phoneNumber,
            name: `User ${data.phoneNumber}`,
            passwordHash: 'otp-login-no-password' 
          }
        });
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

      // Create or update session
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
        expiresIn: 900,
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

};

export default otpRoutes;
