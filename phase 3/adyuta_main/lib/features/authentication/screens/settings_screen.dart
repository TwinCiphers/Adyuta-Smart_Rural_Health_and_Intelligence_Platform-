import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:adyuta_main/features/authentication/providers/auth_provider.dart';
import 'package:adyuta_main/features/authentication/providers/profile_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final user = ref.watch(userProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Security & Settings')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (profile) {
          if (profile == null) return const Center(child: Text('Profile not found'));
          
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(profile['display_name'] ?? 'User'),
                subtitle: Text(user?.email ?? ''),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.fingerprint),
                title: const Text('Biometric Login'),
                trailing: Switch(
                  value: false, // Update with settingsProvider later
                  onChanged: (val) {
                    // Update biometric logic
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Log Out', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  await ref.read(authRepositoryProvider).signOut();
                  // GoRouter will redirect
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
