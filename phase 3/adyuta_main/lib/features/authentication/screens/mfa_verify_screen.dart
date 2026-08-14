import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:adyuta_main/features/authentication/providers/auth_provider.dart';

class MfaVerifyScreen extends ConsumerStatefulWidget {
  const MfaVerifyScreen({super.key});

  @override
  ConsumerState<MfaVerifyScreen> createState() => _MfaVerifyScreenState();
}

class _MfaVerifyScreenState extends ConsumerState<MfaVerifyScreen> {
  final _codeController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _verifyCode() async {
    final code = _codeController.text.trim();
    if (code.length != 6) return;

    setState(() { _loading = true; _error = null; });
    try {
      final client = ref.read(supabaseClientProvider);
      
      // Get the enrolled factors
      final factors = client.auth.currentUser?.factors;
      if (factors == null || factors.isEmpty) {
        throw Exception("No MFA factors found.");
      }
      
      final totpFactor = factors.firstWhere((f) => f.factorType == FactorType.totp);
      
      // Challenge the factor
      final challenge = await client.auth.mfa.challenge(factorId: totpFactor.id);
      
      // Verify the code
      await client.auth.mfa.verify(
        factorId: totpFactor.id,
        challengeId: challenge.id,
        code: code,
      );
      
      // If successful, GoRouter will automatically redirect to /home since AAL is now AAL2
    } catch (e) {
      setState(() => _error = 'Invalid code. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade900,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.lock_clock, size: 64, color: Colors.white),
                const SizedBox(height: 24),
                Text(
                  'Two-Factor Authentication',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter the 6-digit code from your authenticator app to sign in.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 32),
                
                if (_error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    child: Text(_error!, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
                  ),

                TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold, color: Colors.black87),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    counterText: "",
                  ),
                ),
                const SizedBox(height: 24),
                
                _loading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : ElevatedButton(
                        onPressed: _verifyCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.indigo.shade900,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Verify Code', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    ref.read(authRepositoryProvider).signOut();
                  },
                  child: const Text('Cancel & Sign Out', style: TextStyle(color: Colors.white70)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
