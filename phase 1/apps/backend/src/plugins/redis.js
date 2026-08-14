"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const fastify_plugin_1 = __importDefault(require("fastify-plugin"));
const ioredis_1 = __importDefault(require("ioredis"));
exports.default = (0, fastify_plugin_1.default)(async (server, options) => {
    const redisUrl = process.env.REDIS_URL || 'redis://localhost:6379';
    const redis = new ioredis_1.default(redisUrl);
    server.decorate('redis', redis);
    server.addHook('onClose', async (server) => {
        await server.redis.quit();
    });
});
//# sourceMappingURL=redis.js.map