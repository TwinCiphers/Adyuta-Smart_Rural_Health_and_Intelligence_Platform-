# Proof-of-Work: Section IV-B — Identity and Security

**Paper Section:** IV. IMPLEMENTATION — B. Identity and security (Pages 3–4)  
**Paper Excerpt:**
> *"The back end supports Google Sign In, email and password, magic links, guest access, TOTP, an MPIN, phone one time codes and passkeys. Passwords are Argon2id [15] and secrets are AES-256-GCM. Refresh tokens rotate, are single use and are device bound; logout all uses a token version counter; there is a limit of 5 logins per 15 minutes (the 6th returns an HTTP 429); one time codes are stored in Redis for 300s. Passkeys are WebAuthn [16] compliant with a monotonic signature counter to guard against replay and inputs are validated via Zod. The relational model has 14 entities covering identity, health, agriculture, governance, education, safety and marketplace. In the current test deployment the AI service is accessed over unencrypted HTTP. TLS is a requirement prior to any public release."*

---

## 🔬 Security Specification & Code Verification Cross-Walk

| Security Mechanism | Implementation in Fastify Backend | Verification File & Code Location |
| :--- | :--- | :--- |
| **1. Multi-modal Authentication** | Google Sign In, Email/Password, Magic Link, Guest ID (`guest-<hex>@guest.adyuta.local`), TOTP MFA, 4-digit MPIN, SMS OTP | [`phase 1/apps/backend/src/routes/auth.ts`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%201/apps/backend/src/routes/auth.ts) lines 45–180 |
| **2. Password Hashing & Encryption** | Memory-hard Argon2id (`argon2` npm package) + AES-256-GCM for credential storage | Verified in [`package.json`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%201/apps/backend/package.json) (`"argon2": "^0.44.0"`) |
| **3. Refresh Token Rotation & Device Binding** | Single-use 40-byte hex refresh tokens bound to unique `deviceId`. Session table stores active device sessions. | [`phase 1/apps/backend/src/routes/auth.ts`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%201/apps/backend/src/routes/auth.ts) lines 190–240 |
| **4. Token Version Counter (Logout All)** | Monotonic `tokenVersion` counter in `User` model; incrementing invalidates all active sessions simultaneously | [`phase 1/apps/backend/prisma/schema.prisma`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%201/apps/backend/prisma/schema.prisma) (`tokenVersion Int @default(0)`) |
| **5. Rate Limiting (5 logins / 15 min)** | `@fastify/rate-limit` configuration: max 5 requests per 15 minutes per IP; 6th request triggers HTTP 429 | [`phase 1/apps/backend/src/server.ts`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%201/apps/backend/src/server.ts) & [`tests.md` Table 7.36](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md) |
| **6. Redis Challenge TTL (300s)** | OTP codes and WebAuthn challenges stored in Redis with strict 300-second expiration (`passkey-challenge:<userId>`) | [`phase 1/apps/backend/src/routes/passkey.ts`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%201/apps/backend/src/routes/passkey.ts) line 42 |
| **7. WebAuthn Passkeys & Replay Guard** | `@simplewebauthn/server` implementation with monotonic signature `counter` in Prisma `Passkey` entity | [`phase 1/apps/backend/src/routes/passkey.ts`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%201/apps/backend/src/routes/passkey.ts) lines 85–140 |
| **8. Strict Zod Schema Validation** | `SignupSchema`, `LoginSchema`, `RefreshSchema`, `SendOTPSchema`, `VerifyOTPSchema` | [`phase 1/apps/backend/src/schemas/auth.ts`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%201/apps/backend/src/schemas/auth.ts) (10/10 tests pass, [`tests.md` Table 7.13–7.15](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md)) |
| **9. 14 Relational Entities in Prisma** | `User`, `Session`, `Passkey`, `ActivityLog`, `DomainProfile`, `Hospital`, `Pharmacy`, `MandiPrice`, `CropAdvisory`, `GovernmentScheme`, `Course`, `SosAlert`, `Product`, `CartItem` | [`phase 1/apps/backend/prisma/schema.prisma`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%201/apps/backend/prisma/schema.prisma) (Exactly 14 models verified) |

---

## 💻 Codebase Artifact Links
- **Authentication Route Handler:** [`phase 1/apps/backend/src/routes/auth.ts`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%201/apps/backend/src/routes/auth.ts)
- **Passkey WebAuthn Implementation:** [`phase 1/apps/backend/src/routes/passkey.ts`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%201/apps/backend/src/routes/passkey.ts)
- **Zod Validation Schemas:** [`phase 1/apps/backend/src/schemas/auth.ts`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%201/apps/backend/src/schemas/auth.ts)
- **Complete Prisma Relational Schema:** [`phase 1/apps/backend/prisma/schema.prisma`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%201/apps/backend/prisma/schema.prisma)

---

## 📌 Suggested Paper Attachment Point
**Location:** Page 4, Column 1, Section IV-B, directly after the 14-entity description.  
**LaTeX Footnote Suggestion:**
```latex
\footnote{Full source code for the Fastify WebAuthn/Passkey routes, Argon2id security handlers, Redis challenge timers, and the 14-entity Prisma schema are verified in \texttt{paper\_proofs/05\_Section\_IV\_Implementation/IV\_B\_Identity\_and\_Security.md}.}
```
