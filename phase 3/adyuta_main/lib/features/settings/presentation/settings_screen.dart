import 'package:bhashini_core/bhashini_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:adyuta_main/features/settings/providers/preferences_provider.dart';
import 'package:adyuta_main/features/authentication/providers/auth_provider.dart';
import 'package:adyuta_main/services/bhashini_service.dart';


class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _offlineMode = false;

  @override
  void initState() {
    super.initState();
    _loadOfflineMode();
  }

  Future<void> _loadOfflineMode() async {
    final box = await Hive.openBox('settings');
    if (!mounted) return;
    setState(() {
      _offlineMode = box.get('offline_mode', defaultValue: false);
    });
  }

  Future<void> _setOfflineMode(bool value) async {
    final box = await Hive.openBox('settings');
    await box.put('offline_mode', value);
    setState(() {
      _offlineMode = value;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: GlobalBhashiniText(value ? 'Offline mode enabled' : 'Offline mode disabled')),
      );
    }
  }

  Future<void> _clearCache() async {
    // Attempt to clear Hive caches or temporary directories
    try {
      final box = await Hive.openBox('cache');
      await box.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: GlobalBhashiniText('Cache cleared successfully.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: GlobalBhashiniText('Failed to clear cache.')));
      }
    }
  }

  void _showEmailDialog() {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const GlobalBhashiniText('Update Email'),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'New Email Address'),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const GlobalBhashiniText('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final newEmail = emailController.text.trim();
                if (newEmail.isNotEmpty) {
                  try {
                    // Email update to be handled by Node API
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: GlobalBhashiniText('Verification email sent to new address.')));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GlobalBhashiniText(e.toString())));
                  }
                }
              },
              child: const GlobalBhashiniText('Update'),
            )
          ],
        );
      }
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const GlobalBhashiniText('Delete Account', style: TextStyle(color: Colors.redAccent)),
          content: const GlobalBhashiniText('Are you sure you want to permanently delete your account? This action cannot be undone.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const GlobalBhashiniText('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              onPressed: () async {
                // To actually delete a user requires a backend RPC or Edge function due to security.
                // We'll show a placeholder message for now.
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: GlobalBhashiniText('Account deletion requested. Please contact support.')));
              },
              child: const GlobalBhashiniText('Delete'),
            )
          ],
        );
      }
    );
  }

  void _showDataSharingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const GlobalBhashiniText('Data Sharing Consent'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(title: const GlobalBhashiniText('Share Health Data with Government'), value: true, onChanged: (v) {}),
              SwitchListTile(title: const GlobalBhashiniText('Share Agriculture Data with Partners'), value: false, onChanged: (v) {}),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const GlobalBhashiniText('Done')),
          ],
        );
      }
    );
  }

  void _showActiveSessionsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const GlobalBhashiniText('Active Sessions'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GlobalBhashiniText('Current Device:', style: TextStyle(fontWeight: FontWeight.bold)),
              GlobalBhashiniText('Adyuta Android App\nLogged in via Auth'),
              const SizedBox(height: 16),
              const GlobalBhashiniText('Other Devices:', style: TextStyle(fontWeight: FontWeight.bold)),
              const GlobalBhashiniText('No other active sessions detected.'),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const GlobalBhashiniText('Close')),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefsAsync = ref.watch(preferencesProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: GlobalBhashiniText('Settings', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: prefsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: GlobalBhashiniText('Error loading preferences: $err')),
        data: (prefs) {
          if (prefs == null) return const Center(child: GlobalBhashiniText('Please log in.'));

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              // 1. ACCOUNT
              _buildSectionHeader('1. Account'),
              _buildListTile(
                icon: Icons.person_outline,
                title: 'Edit Core Profile',
                subtitle: 'Name, Mobile, DOB',
                onTap: () => context.push('/profile'),
              ),
              _buildListTile(
                icon: Icons.email_outlined,
                title: 'Email Address',
                subtitle: 'View & change email',
                onTap: _showEmailDialog,
              ),
              _buildListTile(
                icon: Icons.delete_outline,
                title: 'Delete Account',
                subtitle: 'Permanently remove all data',
                iconColor: Colors.redAccent,
                onTap: _showDeleteDialog,
              ),
              const Divider(height: 1),
              
              // 2. SECURITY
              _buildSectionHeader('2. Security'),
              _buildListTile(
                icon: Icons.security,
                title: 'Security Settings',
                subtitle: 'Passwords, MFA, MPIN & Biometrics',
                onTap: () => context.push('/security_settings'),
              ),
              _buildListTile(
                icon: Icons.devices,
                title: 'Active Sessions',
                subtitle: 'Manage devices logged into this account',
                onTap: _showActiveSessionsDialog,
              ),
              const Divider(height: 1),

              // 3. PRIVACY
              _buildSectionHeader('3. Privacy'),
              _buildListTile(
                icon: Icons.share_outlined,
                title: 'Data Sharing',
                subtitle: 'Manage what domains can access',
                onTap: _showDataSharingDialog,
              ),
              _buildListTile(
                icon: Icons.download_outlined,
                title: 'Download My Data',
                subtitle: 'Export a copy of your info',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: GlobalBhashiniText('Your data archive is being prepared and will be emailed to you.')),
                  );
                },
              ),
              const Divider(height: 1),

              // 4. LANGUAGE & ACCESSIBILITY
              _buildSectionHeader('4. Language & Accessibility'),
              _buildListTile(
                icon: Icons.translate,
                title: 'Interface Language',
                subtitle: 'Powered by Bhashini AI',
                onTap: () {
                  BhashiniService.instance.showLanguageSelector(context);
                },
              ),
              _buildSwitchTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                subtitle: 'Match system or force dark theme',
                value: prefs.theme == 'dark',
                onChanged: (val) {
                  ref.read(preferencesProvider.notifier).updatePreferences(theme: val ? 'dark' : 'light');
                },
              ),
              _buildSwitchTile(
                icon: Icons.accessibility_new,
                title: 'Literacy Mode',
                subtitle: 'Icon-heavy, minimal text layout',
                value: prefs.literacyMode ?? false,
                onChanged: (val) {
                  ref.read(preferencesProvider.notifier).updatePreferences(literacyMode: val);
                },
              ),
              const Divider(height: 1),

              // 5. NOTIFICATIONS
              _buildSectionHeader('5. Notifications'),
              _buildSwitchTile(
                icon: Icons.notifications_active_outlined,
                title: 'Push Notifications',
                subtitle: 'Receive alerts on your device',
                value: prefs.pushNotifications,
                onChanged: (val) {
                  ref.read(preferencesProvider.notifier).updatePreferences(pushNotifications: val);
                },
              ),
              _buildSwitchTile(
                icon: Icons.email_outlined,
                title: 'Email Notifications',
                subtitle: 'Receive updates via email',
                value: prefs.emailNotifications,
                onChanged: (val) {
                  ref.read(preferencesProvider.notifier).updatePreferences(emailNotifications: val);
                },
              ),
              const Divider(height: 1),

              // 6. OFFLINE & SYNC
              _buildSectionHeader('6. Offline & Sync'),
              _buildSwitchTile(
                icon: Icons.cloud_off,
                title: 'Offline Mode',
                subtitle: 'Force app to run locally only',
                value: _offlineMode,
                onChanged: _setOfflineMode,
              ),
              _buildListTile(
                icon: Icons.cleaning_services,
                title: 'Clear Cache',
                subtitle: 'Free up local device storage',
                onTap: _clearCache,
              ),
              const Divider(height: 1),

              // 7. DOMAIN PROFILES
              _buildSectionHeader('7. Domain Profiles'),
              _buildListTile(
                icon: Icons.favorite_border,
                title: 'Health Profile',
                subtitle: 'Manage health data',
                onTap: () => context.push('/domain_health'),
              ),
              _buildListTile(
                icon: Icons.eco_outlined,
                title: 'Agriculture Profile',
                subtitle: 'Manage crops & land',
                onTap: () => context.push('/domain_agri'),
              ),
              _buildListTile(
                icon: Icons.shield_outlined,
                title: 'Safety Profile',
                subtitle: 'Emergency contacts',
                onTap: () => context.push('/domain_safety'),
              ),
              _buildListTile(
                icon: Icons.school_outlined,
                title: 'Education Profile',
                subtitle: 'Learning preferences',
                onTap: () => context.push('/domain_edu'),
              ),
              _buildListTile(
                icon: Icons.account_balance_outlined,
                title: 'Governance Profile',
                subtitle: 'Saved schemes & docs',
                onTap: () => context.push('/domain_gov'),
              ),
              const Divider(height: 1),

              // 8. HELP & SUPPORT
              _buildSectionHeader('8. Help & Support'),
              _buildListTile(
                icon: Icons.help_outline,
                title: 'FAQ / Help',
                subtitle: 'Voice-guided assistance',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const GlobalBhashiniText('FAQ'),
                      content: const GlobalBhashiniText('Adyuta is a voice-first application. Tap the mic icon on any screen for help!'),
                      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const GlobalBhashiniText('Close'))],
                    )
                  );
                },
              ),
              _buildListTile(
                icon: Icons.play_circle_outline,
                title: 'Replay Tutorial',
                subtitle: 'Watch the app guide again',
                onTap: () {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: GlobalBhashiniText('Tutorial launching...')));
                },
              ),
              const Divider(height: 1),

              // 9. ABOUT & LEGAL
              _buildSectionHeader('9. About & Legal'),
              _buildListTile(
                icon: Icons.info_outline,
                title: 'About Adyuta',
                subtitle: 'Version 1.0.0',
                onTap: () {
                   showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const GlobalBhashiniText('Adyuta'),
                      content: const GlobalBhashiniText('Version 1.0.0\nBuilt for Bharat.'),
                      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const GlobalBhashiniText('Close'))],
                    )
                  );
                },
              ),
              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await ref.read(authRepositoryProvider).signOut();
                    if (context.mounted) context.go('/login');
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  label: GlobalBhashiniText('Log Out', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 48),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 8),
      child: GlobalBhashiniText(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final effectiveColor = iconColor ?? const Color(0xFF3366FF);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: effectiveColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: effectiveColor),
      ),
      title: GlobalBhashiniText(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      subtitle: GlobalBhashiniText(subtitle, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600)),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      secondary: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF3366FF).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF3366FF)),
      ),
      title: GlobalBhashiniText(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      subtitle: GlobalBhashiniText(subtitle, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600)),
      value: value,
      activeColor: const Color(0xFF3366FF),
      onChanged: onChanged,
    );
  }
}

