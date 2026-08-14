import { FastifyPluginAsync } from 'fastify';
import { generateRegistrationOptions, verifyRegistrationResponse, generateAuthenticationOptions, verifyAuthenticationResponse } from '@simplewebauthn/server';
import crypto from 'crypto';
import argon2 from 'argon2';

// In a real app, this should be the relying party ID and origin from environment variables
const rpName = 'ADYUTA Platform';
const rpID = process.env.RP_ID || 'localhost';
const origin = process.env.ORIGIN || `http://${rpID}:3000`;

const passkeyRoutes: FastifyPluginAsync = async (server) => {

  // Generate options for registering a new passkey
  server.post('/generate-registration-options', {
    preValidation: [async (request: any, reply: any) => {
      try {
        await request.jwtVerify();
      } catch (err) {
        reply.status(401).send({ error: 'Unauthorized' });
      }
    }]
  }, async (request: any, reply) => {
    try {
      const userId = request.user.sub;
      const user = await server.prisma.user.findUnique({
        where: { id: userId },
        include: { passkeys: true }
      });

      if (!user) {
        return reply.status(404).send({ error: 'User not found' });
      }

      const userPasskeys = user.passkeys.map(passkey => ({
        id: passkey.credentialID,
        type: 'public-key' as const,
      }));

      const options = await generateRegistrationOptions({
        rpName,
        rpID,
        userID: Buffer.from(user.id),
        userName: user.email || user.phoneNumber || user.id,
        // Don't prompt users for their authenticator if they've already registered it
        excludeCredentials: userPasskeys,
        authenticatorSelection: {
          residentKey: 'preferred',
          userVerification: 'preferred',
        },
      });

      // Store challenge in redis (TTL 5 mins)
      await server.redis.set(`passkey-challenge:${userId}`, options.challenge, 'EX', 300);

      return reply.send(options);
    } catch (error) {
      server.log.error(error);
      return reply.status(500).send({ error: 'Internal Server Error' });
    }
  });

  // Verify registration response
  server.post('/verify-registration', {
    preValidation: [async (request: any, reply: any) => {
      try {
        await request.jwtVerify();
      } catch (err) {
        reply.status(401).send({ error: 'Unauthorized' });
      }
    }]
  }, async (request: any, reply) => {
    try {
      const userId = request.user.sub;
      const body = request.body as any;

      const expectedChallenge = await server.redis.get(`passkey-challenge:${userId}`);
      if (!expectedChallenge) {
        return reply.status(400).send({ error: 'Challenge expired or not found' });
      }

      let verification;
      try {
        verification = await verifyRegistrationResponse({
          response: body,
          expectedChallenge,
          expectedOrigin: origin,
          expectedRPID: rpID,
        });
      } catch (error: any) {
        return reply.status(400).send({ error: error.message });
      }

      if (verification.verified && verification.registrationInfo) {
        const { credential } = verification.registrationInfo;

        await server.prisma.passkey.create({
          data: {
            userId,
            credentialID: credential.id,
            publicKey: Buffer.from(credential.publicKey),
            counter: BigInt(credential.counter),
          }
        });

        await server.redis.del(`passkey-challenge:${userId}`);
        return reply.send({ verified: true });
      }

      return reply.status(400).send({ error: 'Verification failed' });
    } catch (error) {
      server.log.error(error);
      return reply.status(500).send({ error: 'Internal Server Error' });
    }
  });

  // Generate options for authenticating via passkey
  server.post('/generate-authentication-options', async (request: any, reply) => {
    try {
      const { email, phoneNumber } = request.body as any;
      let user = null;

      if (email) {
        user = await server.prisma.user.findUnique({ where: { email }, include: { passkeys: true } });
      } else if (phoneNumber) {
        user = await server.prisma.user.findUnique({ where: { phoneNumber }, include: { passkeys: true } });
      }

      if (!user) {
        // Sleep to prevent timing attacks
        await new Promise(r => setTimeout(r, 1000));
        return reply.status(404).send({ error: 'User not found' });
      }

      const options = await generateAuthenticationOptions({
        rpID,
        allowCredentials: user.passkeys.map(passkey => ({
          id: passkey.credentialID,
          type: 'public-key' as const,
        })),
        userVerification: 'preferred',
      });

      // Store challenge in redis (TTL 5 mins)
      await server.redis.set(`passkey-auth-challenge:${user.id}`, options.challenge, 'EX', 300);

      return reply.send({ options, userId: user.id });
    } catch (error) {
      server.log.error(error);
      return reply.status(500).send({ error: 'Internal Server Error' });
    }
  });

  // Verify authentication response
  server.post('/verify-authentication', async (request: any, reply) => {
    try {
      const { userId, response, deviceId } = request.body as any;

      if (!userId || !response || !deviceId) {
        return reply.status(400).send({ error: 'Missing parameters' });
      }

      const user = await server.prisma.user.findUnique({
        where: { id: userId },
        include: { passkeys: true }
      });

      if (!user) {
        return reply.status(404).send({ error: 'User not found' });
      }

      const expectedChallenge = await server.redis.get(`passkey-auth-challenge:${userId}`);
      if (!expectedChallenge) {
        return reply.status(400).send({ error: 'Challenge expired or not found' });
      }

      const passkey = user.passkeys.find(p => p.credentialID === response.id);
      if (!passkey) {
        return reply.status(400).send({ error: 'Passkey not found' });
      }

      let verification;
      try {
        verification = await verifyAuthenticationResponse({
          response,
          expectedChallenge,
          expectedOrigin: origin,
          expectedRPID: rpID,
          credential: {
            id: passkey.credentialID,
            publicKey: new Uint8Array(passkey.publicKey),
            counter: Number(passkey.counter),
            transports: passkey.transports ? JSON.parse(passkey.transports) : undefined,
          },
        });
      } catch (error: any) {
        return reply.status(400).send({ error: error.message });
      }

      if (verification.verified && verification.authenticationInfo) {
        // Update counter
        await server.prisma.passkey.update({
          where: { id: passkey.id },
          data: { counter: BigInt(verification.authenticationInfo.newCounter) }
        });

        await server.redis.del(`passkey-auth-challenge:${userId}`);

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

        const existingSession = await server.prisma.session.findFirst({
          where: { userId: user.id, deviceId }
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
              deviceId,
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
            phoneNumber: user.phoneNumber,
            name: user.name,
          }
        });
      }

      return reply.status(400).send({ error: 'Verification failed' });
    } catch (error) {
      server.log.error(error);
      return reply.status(500).send({ error: 'Internal Server Error' });
    }
  });
};

export default passkeyRoutes;
