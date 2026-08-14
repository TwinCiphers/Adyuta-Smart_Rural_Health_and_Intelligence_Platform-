import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_module/core/theme/app_theme.dart';
import 'package:health_module/core/widgets/soft_background_layout.dart';
import '../repositories/phr_repo.dart';
import 'phr_detail_screen.dart';

final phrRepoProvider = Provider<PhrRepository>((ref) => PhrRepository());

final profilesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.read(phrRepoProvider).getProfiles();
});

class PhrScreen extends ConsumerWidget {
  const PhrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(profilesProvider);

    return SoftBackgroundLayout(
      hasScrollBody: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.softShadow,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Health Record',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 32),
                ),
                IconButton(
                  icon: const Icon(Icons.person_add_alt_1_rounded, color: AppTheme.primaryColor),
                  onPressed: () => _showAddProfileDialog(context, ref),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Your private, offline health vault.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 32),

            Expanded(
              child: profilesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Text('Error: $e'),
                data: (profiles) {
                  if (profiles.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.family_restroom, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text('No profiles found.', style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _showAddProfileDialog(context, ref),
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                            child: const Text('Add Family Member', style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final p = profiles[index];
                      return _buildProfileCard(context, p);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, Map<String, dynamic> profile) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PhrDetailScreen(profile: profile))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.softShadow,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              child: Text(
                profile['name'][0].toUpperCase(),
                style: const TextStyle(color: AppTheme.primaryColor, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile['name'], style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text('${profile['relation']} • ${profile['blood_group'] ?? 'No BG'}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }

  void _showAddProfileDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final relationCtrl = TextEditingController();
    final bgCtrl = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: relationCtrl, decoration: const InputDecoration(labelText: 'Relation (e.g. Self, Son)')),
            TextField(controller: bgCtrl, decoration: const InputDecoration(labelText: 'Blood Group')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty) {
                await ref.read(phrRepoProvider).addProfile({
                  'name': nameCtrl.text,
                  'relation': relationCtrl.text,
                  'blood_group': bgCtrl.text,
                });
                // ignore: unused_result
                ref.refresh(profilesProvider);
                if(context.mounted) {
                   Navigator.pop(context);
                }
              }
            },
            child: const Text('Save'),
          )
        ],
      )
    );
  }
}
