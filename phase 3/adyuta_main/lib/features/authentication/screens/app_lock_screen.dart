import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adyuta_main/features/authentication/providers/local_security_provider.dart';
import 'package:adyuta_main/features/authentication/providers/auth_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerBiometrics();
    });
  }

  Future<void> _triggerBiometrics() async {
    final notifier = ref.read(localSecurityProvider.notifier);
    final success = await notifier.authenticateWithBiometrics();
    if (success) {
      // GoRouter will automatically redirect us because isLocked became false
    }
  }

  Future<void> _verifyPin(String pin) async {
    final notifier = ref.read(localSecurityProvider.notifier);
    final success = await notifier.verifyMpin(pin);
    if (!success) {
      setState(() {
        _hasError = true;
        _pinController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final securityState = ref.watch(localSecurityProvider);
    
    return Scaffold(
      backgroundColor: const Color(0xFF19326A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              const Text(
                'App Locked',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your 4-digit MPIN to unlock',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 48),
              
              PinCodeTextField(
                appContext: context,
                length: 4,
                controller: _pinController,
                obscureText: true,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 60,
                  fieldWidth: 50,
                  activeFillColor: Colors.white.withOpacity(0.1),
                  inactiveFillColor: Colors.white.withOpacity(0.1),
                  selectedFillColor: Colors.white.withOpacity(0.2),
                  activeColor: _hasError ? Colors.red : Colors.white,
                  inactiveColor: Colors.white54,
                  selectedColor: Colors.white,
                ),
                enableActiveFill: true,
                textStyle: const TextStyle(color: Colors.white, fontSize: 24),
                onChanged: (value) {
                  if (_hasError) setState(() => _hasError = false);
                },
                onCompleted: _verifyPin,
              ),

              if (_hasError) ...[
                const SizedBox(height: 16),
                const Text('Incorrect PIN. Please try again.', style: TextStyle(color: Colors.redAccent)),
              ],

              const SizedBox(height: 48),

              if (securityState.biometricsEnabled)
                IconButton(
                  icon: const Icon(Icons.fingerprint, size: 64, color: Colors.white),
                  onPressed: _triggerBiometrics,
                ),

              const Spacer(),
              TextButton.icon(
                onPressed: () async {
                  await ref.read(authRepositoryProvider).signOut();
                },
                icon: const Icon(Icons.logout, color: Colors.white54),
                label: const Text('Sign Out', style: TextStyle(color: Colors.white54)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
