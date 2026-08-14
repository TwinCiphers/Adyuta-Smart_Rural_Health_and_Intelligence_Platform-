import { z } from 'zod';
export declare const SignupSchema: z.ZodObject<{
    email: z.ZodString;
    password: z.ZodString;
    name: z.ZodString;
}, z.core.$strip>;
export declare const LoginSchema: z.ZodObject<{
    email: z.ZodString;
    password: z.ZodString;
    deviceId: z.ZodString;
}, z.core.$strip>;
export declare const RefreshSchema: z.ZodObject<{
    deviceId: z.ZodString;
}, z.core.$strip>;
export declare const LogoutSchema: z.ZodObject<{
    deviceId: z.ZodString;
}, z.core.$strip>;
export declare const SendOTPSchema: z.ZodObject<{
    phoneNumber: z.ZodString;
}, z.core.$strip>;
export declare const VerifyOTPSchema: z.ZodObject<{
    phoneNumber: z.ZodString;
    otpCode: z.ZodString;
    deviceId: z.ZodString;
}, z.core.$strip>;
//# sourceMappingURL=auth.d.ts.map