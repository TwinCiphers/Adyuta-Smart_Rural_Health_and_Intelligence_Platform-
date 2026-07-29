import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_module/core/theme/app_theme.dart';
import 'package:health_module/core/widgets/soft_background_layout.dart';
import '../providers/first_aid_provider.dart';
import '../models/emergency_scenario.dart';

class FirstAidDetailScreen extends ConsumerWidget {
  final EmergencyScenario scenario;

  const FirstAidDetailScreen({super.key, required this.scenario});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SoftBackgroundLayout(
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
              scenario.title,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              '${scenario.category} • ${scenario.urgencyLevel}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16, color: Colors.orange[800]),
            ),
            const SizedBox(height: 24),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (scenario.dangerSigns.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded, color: Colors.red),
                                const SizedBox(width: 8),
                                Text('Danger Signs', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red[800], fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...scenario.dangerSigns.map((sign) => Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                  Expanded(child: Text(sign, style: TextStyle(color: Colors.red[900]))),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (scenario.avoidActions.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.orange.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.do_not_disturb_alt_rounded, color: Colors.orange),
                                const SizedBox(width: 8),
                                Text('DO NOT DO THIS', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.orange[900], fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...scenario.avoidActions.map((avoid) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('❌ ${avoid['action']}', style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.bold)),
                                  Text(avoid['reason'] ?? '', style: TextStyle(color: Colors.orange[800], fontSize: 12)),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    
                    Text('Steps to take', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                    const SizedBox(height: 16),
                    
                    ref.watch(firstAidStepsProvider(scenario.id)).when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Text('Error loading steps: $err'),
                      data: (steps) {
                        if (steps.isEmpty) return const Text('No steps found for this emergency.');
                        return Column(
                          children: steps.map((step) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text('${step.stepNo}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        step.type,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        step.textContent,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14, height: 1.5),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
