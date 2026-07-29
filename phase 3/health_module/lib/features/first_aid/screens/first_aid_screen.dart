import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_module/core/theme/app_theme.dart';
import 'package:health_module/core/widgets/soft_background_layout.dart';
import '../providers/first_aid_provider.dart';
import 'first_aid_detail_screen.dart';

class FirstAidScreen extends ConsumerWidget {
  const FirstAidScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(firstAidSearchQueryProvider);

    return SoftBackgroundLayout(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.call, color: Colors.red, size: 16),
                        const SizedBox(width: 6),
                        Text('Call 108', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'First Aid & Emergency',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                'Fast offline guidance for critical situations.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 24),
              
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppTheme.softShadow,
                ),
                child: TextField(
                  onChanged: (val) {
                    ref.read(firstAidSearchQueryProvider.notifier).state = val;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search emergencies (e.g. snake bite)...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              if (searchQuery.isNotEmpty) ...[
                Text('Search Results', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                const SizedBox(height: 16),
                ref.watch(searchTopicsProvider).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error: $err'),
                  data: (scenarios) {
                    if (scenarios.isEmpty) return const Text('No emergencies found.');
                    return Column(
                      children: scenarios.map((scenario) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FirstAidDetailScreen(scenario: scenario))),
                          child: _buildEmergencyCard(
                            context, 
                            scenario.title, 
                            '${scenario.category} • ${scenario.urgencyLevel}', 
                            Icons.warning_rounded,
                            Colors.orange[50]!
                          ),
                        ),
                      )).toList(),
                    );
                  }
                ),
                const SizedBox(height: 32),
              ],
              
              if (searchQuery.isEmpty) ...[
                Text('All Emergency Topics', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                const SizedBox(height: 16),
                
                ref.watch(emergencyTopicsProvider).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error loading emergencies: $err'),
                  data: (scenarios) {
                    if (scenarios.isEmpty) return const Text('No emergencies found.');
                    return Column(
                      children: scenarios.map((scenario) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FirstAidDetailScreen(scenario: scenario))),
                          child: _buildEmergencyCard(
                            context, 
                            scenario.title, 
                            '${scenario.category} • ${scenario.urgencyLevel}', 
                            Icons.warning_rounded, 
                            Colors.orange[50]!
                          ),
                        ),
                      )).toList(),
                    );
                  },
                ),
              ],
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(BuildContext context, String title, String desc, IconData icon, Color bg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.black87, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text(desc, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppTheme.primaryColor),
        ],
      ),
    );
  }
}
