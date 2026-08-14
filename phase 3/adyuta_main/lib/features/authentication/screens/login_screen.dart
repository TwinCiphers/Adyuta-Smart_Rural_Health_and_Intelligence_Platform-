import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:adyuta_main/features/authentication/providers/auth_provider.dart';
import 'package:adyuta_main/core/widgets/adyuta_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } catch (e) {
      debugPrint('Login Error: $e');
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loginAnonymously() async {
    setState(() { _loading = true; _error = null; });
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signInAnonymously();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() { _loading = true; _error = null; });
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signInWithGoogle();
    } catch (e) {
      setState(() => _error = _cleanError(e.toString()));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _processMagicLink(String email) async {
    setState(() { _loading = true; _error = null; });
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.sendMagicLink(email);
      setState(() => _error = 'Magic link sent to $email! Check your inbox.');
    } catch (e) {
      debugPrint('Magic Link Error: $e');
      setState(() => _error = _cleanError(e.toString()));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMagicLinkDialog() {
    final magicEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text('Magic Link Sign In', style: GoogleFonts.inter(color: Colors.black87, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('We will send a secure login link directly to your email.', style: GoogleFonts.inter(color: Colors.black54, fontSize: 14)),
              const SizedBox(height: 16),
              TextField(
                controller: magicEmailController,
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                final email = magicEmailController.text.trim();
                if (email.isNotEmpty) {
                  Navigator.pop(context);
                  _processMagicLink(email);
                }
              },
              child: const Text('Send Link'),
            )
          ],
        );
      },
    );
  }

  String _cleanError(String error) {
    return error.split(']').last.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Subtle background mesh
          Positioned(
            top: -100, right: -50,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.primary.withOpacity(0.05)),
            ),
          ),
          Positioned(
            bottom: -50, left: -100,
            child: Container(
              width: 400, height: 400,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue.withOpacity(0.03)),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  // Logo & Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.change_history_rounded, color: Theme.of(context).colorScheme.primary, size: 36), // Placeholder for Adyuta logo
                      const SizedBox(width: 8),
                      Text('Adyuta', style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Secure. Simple. Seamless.', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                  Text('One account. Infinite possibilities.', style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 32),

                  // Main Form Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
                      ],
                    ),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 4),
                        Text('Sign in to continue to Adyuta', style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
                        const SizedBox(height: 24),

                        if (_error != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                            child: Text(_error!, style: TextStyle(color: Colors.red.shade800, fontSize: 13), textAlign: TextAlign.center),
                          ),

                        // OAuth Buttons
                        _buildSocialButton(icon: Icons.g_mobiledata, label: 'Continue with Google', onTap: _loginWithGoogle),
                        const SizedBox(height: 12),
                        _buildSocialButton(icon: Icons.link, label: 'Sign in with Magic Link', onTap: _showMagicLinkDialog),
                        const SizedBox(height: 12),
                        _buildSocialButton(
                          icon: Icons.person_outline, 
                          label: 'Continue as Guest', 
                          onTap: _loginAnonymously,
                          subtitle: 'Limited access • Auto sign out in 25 min',
                          isPrimary: true
                        ),

                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey.shade200)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text('OR', style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                            Expanded(child: Divider(color: Colors.grey.shade200)),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Email Form
                        Text('Email address', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDeco('you@example.com'),
                        ),
                        const SizedBox(height: 16),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Password', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                            Text('Forgot password?', style: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: _inputDeco('••••••••').copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade400, size: 20),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            )
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            SizedBox(
                              width: 24, height: 24,
                              child: Checkbox(
                                value: _rememberMe,
                                activeColor: Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                side: BorderSide(color: Colors.grey.shade300),
                                onChanged: (v) => setState(() => _rememberMe = v ?? false),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('Remember me', style: GoogleFonts.inter(fontSize: 13, color: Colors.black54)),
                          ],
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _loading 
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Text('Sign in', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('New to Adyuta? ', style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
                            GestureDetector(
                              onTap: () => context.go('/signup'),
                              child: Text('Sign up', style: GoogleFonts.inter(fontSize: 14, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  // Info Sidebar Card (Moved below for mobile)
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F5FF), // Light purple bg
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your security, our priority', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 24),
                        
                        _buildInfoItem(
                          icon: Icons.verified_user_outlined, 
                          title: 'Multi-factor authentication', 
                          desc: 'Add an extra layer of security with TOTP'
                        ),
                        const SizedBox(height: 24),
                        _buildInfoItem(
                          icon: Icons.access_time, 
                          title: 'Secure sessions', 
                          desc: 'We protect your data and respect your privacy'
                        ),
                        const SizedBox(height: 24),
                        _buildInfoItem(
                          icon: Icons.person_outline, 
                          title: 'Guest access', 
                          desc: 'Try Adyuta instantly as a guest. Session expires in 25 minutes.'
                        ),
                        const SizedBox(height: 32),
                        
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.primary.withOpacity(0.1))),
                              Icon(Icons.shield, size: 48, color: Theme.of(context).colorScheme.primary),
                              const Positioned(
                                child: Icon(Icons.lock, size: 20, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Icon(Icons.verified_user, size: 16, color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 8),
                              Expanded(child: Text('MFA is optional and can be enabled after you sign in.', style: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.primary))),
                            ],
                          ),
                        )
                      ],
                    ),
                  )

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({required IconData icon, required String label, required VoidCallback onTap, String? subtitle, bool isPrimary = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isPrimary ? Theme.of(context).colorScheme.primary.withOpacity(0.05) : Colors.white,
          border: Border.all(color: isPrimary ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isPrimary ? Theme.of(context).colorScheme.primary : Colors.black87),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: isPrimary ? Theme.of(context).colorScheme.primary : Colors.black87), overflow: TextOverflow.ellipsis),
                  if (subtitle != null) Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: Theme.of(context).colorScheme.primary.withOpacity(0.8)), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String title, required String desc}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
              const SizedBox(height: 4),
              Text(desc, style: GoogleFonts.inter(fontSize: 13, color: Colors.black54)),
            ],
          ),
        )
      ],
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5)),
    );
  }
}
