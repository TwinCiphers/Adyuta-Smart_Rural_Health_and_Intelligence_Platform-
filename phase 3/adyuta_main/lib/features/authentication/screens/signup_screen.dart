import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:adyuta_main/features/authentication/providers/auth_provider.dart';
import 'package:adyuta_main/core/widgets/adyuta_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _loading = false;
  String? _error;
  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  int _selectedTab = 0; // 0 = Email, 1 = Guest
  
  Color get _primaryPurple => Theme.of(context).colorScheme.primary;

  // Password requirements state
  bool _has8Chars = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_evaluatePassword);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _evaluatePassword() {
    final pass = _passwordController.text;
    setState(() {
      _has8Chars = pass.length >= 8;
      _hasNumber = RegExp(r'[0-9]').hasMatch(pass);
      _hasSpecialChar = RegExp(r'[!@#\$&*~]').hasMatch(pass);
    });
  }

  Future<void> _signup() async {
    final pass = _passwordController.text.trim();

    if (!_has8Chars || !_hasNumber || !_hasSpecialChar) {
      setState(() => _error = 'Please meet all password requirements.');
      return;
    }
    
    if (!_agreedToTerms) {
      setState(() => _error = 'Please agree to the Terms of Service.');
      return;
    }

    setState(() { _loading = true; _error = null; });
    try {
      final authRepo = ref.read(authRepositoryProvider);
      final res = await authRepo.signUpWithEmail(
        _emailController.text.trim(),
        pass,
        fullName: _fullNameController.text.trim().isNotEmpty ? _fullNameController.text.trim() : null,
        phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
      );
      if (res.session == null) {
        setState(() => _error = 'Account created successfully! Please check your email to verify it.');
      }
    } catch (e) {
      debugPrint('Signup Error: $e');
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signupAsGuest() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          Positioned(
            top: -100, left: -50,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(shape: BoxShape.circle, color: _primaryPurple.withOpacity(0.05)),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_back, size: 20, color: Colors.black87),
                            const SizedBox(width: 4),
                            Text('Back', style: GoogleFonts.inter(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Main Card
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
                        Text('Create your account', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 4),
                        Text('Join Adyuta and start your journey', style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
                        const SizedBox(height: 24),

                        if (_error != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                            child: Text(_error!, style: TextStyle(color: Colors.red.shade800, fontSize: 13), textAlign: TextAlign.center),
                          ),

                        // Segmented Control
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedTab = 0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _selectedTab == 0 ? _primaryPurple : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.email_outlined, size: 16, color: _selectedTab == 0 ? Colors.white : Colors.black54),
                                        const SizedBox(width: 8),
                                        Text('Email', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: _selectedTab == 0 ? Colors.white : Colors.black54)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedTab = 1),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _selectedTab == 1 ? _primaryPurple : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.person_outline, size: 16, color: _selectedTab == 1 ? Colors.white : Colors.black54),
                                        const SizedBox(width: 8),
                                        Text('Guest', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: _selectedTab == 1 ? Colors.white : Colors.black54)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        if (_selectedTab == 0) ...[
                          Text('Full name', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _fullNameController,
                            decoration: _inputDeco('Enter your full name'),
                          ),
                          const SizedBox(height: 16),
                          
                          Text('Mobile number', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: _inputDeco('98765 43210').copyWith(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                child: Text('🇮🇳 +91   |', style: GoogleFonts.inter(color: Colors.black87, fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Text('Date of birth', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _dobController,
                            decoration: _inputDeco('DD / MM / YYYY').copyWith(prefixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.black54, size: 20)),
                          ),
                          const SizedBox(height: 16),

                          Text('Email address', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _inputDeco('you@example.com'),
                          ),
                          const SizedBox(height: 16),

                          Text('Password', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: _inputDeco('Create a strong password').copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade400, size: 20),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              )
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Password Requirements
                          Row(
                            children: [
                              _buildReqItem('At least 8 characters', _has8Chars),
                              const SizedBox(width: 8),
                              _buildReqItem('Includes a number', _hasNumber),
                            ],
                          ),
                          const SizedBox(height: 4),
                          _buildReqItem('Includes a special character', _hasSpecialChar),
                          const SizedBox(height: 24),

                          Row(
                            children: [
                              SizedBox(
                                width: 24, height: 24,
                                child: Checkbox(
                                  value: _agreedToTerms,
                                  activeColor: _primaryPurple,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  side: BorderSide(color: Colors.grey.shade300),
                                  onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: 'I agree to the ',
                                    style: GoogleFonts.inter(fontSize: 12, color: Colors.black54),
                                    children: [
                                      TextSpan(text: 'Terms of Service', style: TextStyle(color: _primaryPurple)),
                                      const TextSpan(text: ' and '),
                                      TextSpan(text: 'Privacy Policy', style: TextStyle(color: _primaryPurple)),
                                    ]
                                  )
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          AdyutaButton(
                            text: 'Create account',
                            isLoading: _loading,
                            onPressed: _signup,
                          ),
                        ] else ...[
                          // Guest Mode Info
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              children: [
                                Icon(Icons.person_outline, size: 64, color: _primaryPurple),
                                const SizedBox(height: 16),
                                Text('Try Adyuta as a Guest', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                                const SizedBox(height: 8),
                                Text('You will have limited access. Your session will automatically sign out in 25 minutes for security.', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _loading ? null : _signupAsGuest,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _primaryPurple,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: _loading 
                                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                      : Text('Continue as Guest', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account? ', style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
                            GestureDetector(
                              onTap: () => context.go('/login'),
                              child: Text('Sign in', style: GoogleFonts.inter(fontSize: 14, color: _primaryPurple, fontWeight: FontWeight.bold)),
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
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: _primaryPurple.withOpacity(0.1))),
                            child: Icon(Icons.person_add_alt_1_outlined, color: _primaryPurple, size: 32),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text('Why we ask for this information', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 8),
                        Text('We use this information to personalize your experience and keep your account secure.', style: GoogleFonts.inter(fontSize: 13, color: Colors.black54)),
                        const SizedBox(height: 24),
                        
                        _buildInfoItem(
                          icon: Icons.person_outline, 
                          title: 'Name', 
                          desc: 'Personalize your experience'
                        ),
                        const SizedBox(height: 24),
                        _buildInfoItem(
                          icon: Icons.phone_outlined, 
                          title: 'Mobile number', 
                          desc: 'For account recovery and important alerts'
                        ),
                        const SizedBox(height: 24),
                        _buildInfoItem(
                          icon: Icons.calendar_today_outlined, 
                          title: 'Date of birth', 
                          desc: 'Helps us provide age-appropriate experiences'
                        ),
                        const SizedBox(height: 32),
                        
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(color: _primaryPurple.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Icon(Icons.lock_outline, size: 16, color: _primaryPurple),
                              const SizedBox(width: 8),
                              Expanded(child: Text('Your data is encrypted and never shared.', style: GoogleFonts.inter(fontSize: 12, color: _primaryPurple, fontWeight: FontWeight.w500))),
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

  Widget _buildReqItem(String text, bool met) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check, size: 12, color: met ? Colors.green : Colors.grey.shade400),
        const SizedBox(width: 4),
        Text(text, style: GoogleFonts.inter(fontSize: 10, color: met ? Colors.green : Colors.grey.shade500, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildInfoItem({required IconData icon, required String title, required String desc}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _primaryPurple, size: 24),
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
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _primaryPurple, width: 1.5)),
    );
  }
}
