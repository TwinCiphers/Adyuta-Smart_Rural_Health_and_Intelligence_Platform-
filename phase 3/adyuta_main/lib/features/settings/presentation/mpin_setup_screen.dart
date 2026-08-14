import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adyuta_main/features/authentication/providers/local_security_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class MpinSetupScreen extends ConsumerStatefulWidget {
  const MpinSetupScreen({super.key});

  @override
  ConsumerState<MpinSetupScreen> createState() => _MpinSetupScreenState();
}

class _MpinSetupScreenState extends ConsumerState<MpinSetupScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  
  bool _isConfirming = false;
  String _firstPin = '';
  bool _hasError = false;

  void _onPinComplete(String pin) {
    if (!_isConfirming) {
      setState(() {
        _firstPin = pin;
        _isConfirming = true;
        _pinController.clear();
      });
    } else {
      if (pin == _firstPin) {
        // Success! Save the MPIN.
        ref.read(localSecurityProvider.notifier).setMpin(pin);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('MPIN successfully configured!')),
        );
        Navigator.pop(context);
      } else {
        // Mismatch
        setState(() {
          _hasError = true;
          _pinController.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final securityState = ref.watch(localSecurityProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup MPIN'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Icon(Icons.lock_person, size: 64, color: Colors.indigo.shade900),
            const SizedBox(height: 24),
            Text(
              _isConfirming ? 'Confirm your MPIN' : 'Create a 4-digit MPIN',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'This PIN will be used to quickly unlock the app.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: PinCodeTextField(
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
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.blue.shade50,
                  activeColor: _hasError ? Colors.red : Colors.grey.shade300,
                  inactiveColor: Colors.grey.shade300,
                  selectedColor: Colors.indigo.shade900,
                ),
                enableActiveFill: true,
                textStyle: const TextStyle(color: Colors.black87, fontSize: 24),
                onChanged: (value) {
                  if (_hasError) setState(() => _hasError = false);
                },
                onCompleted: _onPinComplete,
              ),
            ),

            if (_hasError) ...[
              const SizedBox(height: 16),
              const Text('PINs do not match. Please try again.', style: TextStyle(color: Colors.redAccent)),
            ],

            const Spacer(),
            
            // Biometrics Toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: SwitchListTile(
                title: const Text('Enable Fingerprint/FaceID', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Unlock the app even faster.', style: TextStyle(fontSize: 12)),
                secondary: const Icon(Icons.fingerprint, color: Color(0xFF3366FF), size: 32),
                value: securityState.biometricsEnabled,
                onChanged: (val) {
                  ref.read(localSecurityProvider.notifier).setBiometricsEnabled(val);
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
