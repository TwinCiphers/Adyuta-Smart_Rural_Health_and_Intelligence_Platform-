import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:adyuta_main/features/authentication/providers/auth_provider.dart';
import 'package:adyuta_main/features/settings/presentation/mpin_setup_screen.dart';

import 'package:adyuta_main/features/authentication/providers/local_security_provider.dart';

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  ConsumerState<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends ConsumerState<SecuritySettingsScreen> {

  @override
  Widget build(BuildContext context) {
    final securityState = ref.watch(localSecurityProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Security & Privacy'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Authentication',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Biometric Unlock', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Use Fingerprint or FaceID to quickly open the app.'),
            secondary: const Icon(Icons.fingerprint, size: 32, color: Color(0xFF3366FF)),
            value: securityState.biometricsEnabled,
            onChanged: (val) async {
              final success = await ref.read(localSecurityProvider.notifier).toggleBiometricsWithChallenge(val);
              if (!success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Biometric authentication failed or canceled.')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.pin, size: 32, color: Color(0xFF3366FF)),
            title: const Text('MPIN Setup'),
            subtitle: const Text('Create a 4-digit code to quickly unlock the app.'),
            trailing: OutlinedButton(
              onPressed: () {
                context.push('/setup_mpin');
              },
              child: const Text('Set MPIN'),
            ),
          ),
          const Divider(height: 16),
          ListTile(
            leading: const Icon(Icons.security_update_good, size: 32, color: Color(0xFF3366FF)),
            title: const Text('Two-Factor Authentication (MFA)'),
            subtitle: const Text('Add an extra layer of security to your account via an Authenticator App.'),
            trailing: OutlinedButton(
              onPressed: () {
                context.push('/mfa_setup');
              },
              child: const Text('Setup'),
            ),
          ),
          const Divider(height: 32),
          const Text(
            'Privacy',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.data_usage, color: Colors.black54),
            title: const Text('Local Data Storage'),
            subtitle: const Text('Manage data stored on this device.'),
            onTap: () {
              // TODO: Open local data manager
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud_off, color: Colors.black54),
            title: const Text('Cloud Sync Settings'),
            subtitle: const Text('Configure what data syncs to the central ADYUTA network.'),
            onTap: () {
              // TODO: Open sync settings
            },
          ),
        ],
      ),
    );
  }
}
