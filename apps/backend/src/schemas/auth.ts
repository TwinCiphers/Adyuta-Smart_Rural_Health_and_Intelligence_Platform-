import { z } from 'zod';

export const SignupSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
  name: z.string().min(2),
});

export const LoginSchema = z.object({
  email: z.string().email(),
  password: z.string(),
  deviceId: z.string(),
});

export const RefreshSchema = z.object({
  deviceId: z.string(),
});

export const LogoutSchema = z.object({
  deviceId: z.string(),
});

export const SendOTPSchema = z.object({
  phoneNumber: z.string().min(10).max(15),
});

export const VerifyOTPSchema = z.object({
  phoneNumber: z.string().min(10).max(15),
  otpCode: z.string().length(6),
  deviceId: z.string(),
});
