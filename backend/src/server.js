"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const fastify_1 = __importDefault(require("fastify"));
const cors_1 = __importDefault(require("@fastify/cors"));
const helmet_1 = __importDefault(require("@fastify/helmet"));
const jwt_1 = __importDefault(require("@fastify/jwt"));
const rate_limit_1 = __importDefault(require("@fastify/rate-limit"));
const fs_1 = __importDefault(require("fs"));
const path_1 = __importDefault(require("path"));
const prisma_1 = __importDefault(require("./plugins/prisma"));
const redis_1 = __importDefault(require("./plugins/redis"));
const auth_1 = __importDefault(require("./routes/auth"));
const otp_1 = __importDefault(require("./routes/otp"));
const buildServer = async () => {
    const server = (0, fastify_1.default)({
        logger: true,
    });
    // Security headers
    await server.register(helmet_1.default);
    // CORS - restrict to your app's domain in production
    await server.register(cors_1.default, {
        origin: '*',
        methods: ['GET', 'POST', 'PUT', 'DELETE'],
    });
    // Register Prisma and Redis
    await server.register(prisma_1.default);
    await server.register(redis_1.default);
    // Read RSA keys for JWT
    const keysDir = path_1.default.join(__dirname, '../keys');
    const publicKey = fs_1.default.readFileSync(path_1.default.join(keysDir, 'public.pem'), 'utf8');
    const privateKey = fs_1.default.readFileSync(path_1.default.join(keysDir, 'private.pem'), 'utf8');
    // JWT configuration
    await server.register(jwt_1.default, {
        secret: {
            private: privateKey,
            public: publicKey,
        },
        sign: { algorithm: 'RS256' },
    });
    // Rate Limiting
    await server.register(rate_limit_1.default, {
        max: 100,
        timeWindow: '1 minute',
        redis: server.redis, // use the redis instance from our plugin
    });
    // Routes
    server.register(auth_1.default, { prefix: '/api/auth' });
    server.register(otp_1.default, { prefix: '/api/auth/otp' });
    return server;
};
exports.default = buildServer;
//# sourceMappingURL=server.js.map