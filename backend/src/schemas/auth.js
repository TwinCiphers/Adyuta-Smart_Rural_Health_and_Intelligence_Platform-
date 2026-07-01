"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.VerifyOTPSchema = exports.SendOTPSchema = exports.LogoutSchema = exports.RefreshSchema = exports.LoginSchema = exports.SignupSchema = void 0;
const zod_1 = require("zod");
exports.SignupSchema = zod_1.z.object({
    email: zod_1.z.string().email(),
    password: zod_1.z.string().min(8),
    name: zod_1.z.string().min(2),
});
exports.LoginSchema = zod_1.z.object({
    email: zod_1.z.string().email(),
    password: zod_1.z.string(),
    deviceId: zod_1.z.string(),
});
exports.RefreshSchema = zod_1.z.object({
    deviceId: zod_1.z.string(),
});
exports.LogoutSchema = zod_1.z.object({
    deviceId: zod_1.z.string(),
});
exports.SendOTPSchema = zod_1.z.object({
    phoneNumber: zod_1.z.string().min(10).max(15),
});
exports.VerifyOTPSchema = zod_1.z.object({
    phoneNumber: zod_1.z.string().min(10).max(15),
    otpCode: zod_1.z.string().length(6),
    deviceId: zod_1.z.string(),
});
//# sourceMappingURL=auth.js.map