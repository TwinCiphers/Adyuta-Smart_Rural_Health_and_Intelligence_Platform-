import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adyuta_main/features/authentication/providers/auth_provider.dart';

class MfaSetupScreen extends ConsumerStatefulWidget {
  const MfaSetupScreen({super.key});

  @override
  ConsumerState<MfaSetupScreen> createState() => _MfaSetupScreenState();
}

class _MfaSetupScreenState extends ConsumerState<MfaSetupScreen> {
  final _codeController = TextEditingController();
  
  bool _loading = false;
  String? _error;
  String? _qrCodeSvg;
  String? _factorId;
  String? _secret;

  @override
  void initState() {
    super.initState();
    _checkMfaStatus();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _checkMfaStatus() async {
    // Currently, Supabase Flutter doesn't have a direct "is MFA enabled" flag easily, 
    // but we can look at the user's factors
    final user = ref.read(supabaseClientProvider).auth.currentUser;
    // We will just start enrollment if they click "Setup MFA"
  }

  Future<void> _startEnrollment() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res = await ref.read(supabaseClientProvider).auth.mfa.enroll(
        friendlyName: 'Adyuta MFA ${DateTime.now().millisecondsSinceEpoch}',
      );
      setState(() {
        _factorId = res.id;
        _qrCodeSvg = res.totp.qrCode;
        _secret = res.totp.secret;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _verifyAndEnable() async {
    final code = _codeController.text.trim();
    if (code.length != 6 || _factorId == null) return;

    setState(() { _loading = true; _error = null; });
    try {
      final challenge = await ref.read(supabaseClientProvider).auth.mfa.challenge(factorId: _factorId!);
      await ref.read(supabaseClientProvider).auth.mfa.verify(
        factorId: _factorId!,
        challengeId: challenge.id,
        code: code,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('MFA successfully enabled!')));
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _error = 'Invalid code. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Two-Factor Auth (MFA)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.security, size: 64, color: Color(0xFF3366FF)),
            const SizedBox(height: 16),
            Text(
              'Secure your account',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Add an extra layer of security using an authenticator app like Google Authenticator.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),

            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
                child: Text(_error!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
              ),

            if (_qrCodeSvg == null)
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _startEnrollment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3366FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Setup Authenticator App', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    )
            else
              Column(
                children: [
                  Text('1. Scan QR Code', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: SvgPicture.string(_qrCodeSvg!, height: 200, width: 200),
                  ),
                  const SizedBox(height: 24),
                  Text('2. Enter 6-digit Code', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _loading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _verifyAndEnable,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3366FF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('Verify & Enable', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                          ),
                        ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
