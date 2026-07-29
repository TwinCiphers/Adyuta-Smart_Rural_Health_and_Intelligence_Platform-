import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_module/core/theme/app_theme.dart';
import 'package:health_module/core/widgets/soft_background_layout.dart';
import '../providers/mch_provider.dart';
import 'pregnancy_week_detail_screen.dart';

class MchScreen extends ConsumerWidget {
  const MchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all three providers — Riverpod handles parallel loading safely
    final weeksAsync = ref.watch(pregnancyWeeksProvider);
    final vaccinesAsync = ref.watch(maternalVaccinesProvider);
    final dangerAsync = ref.watch(pregnancyDangerSignsProvider);

    // Show a unified loading indicator until ALL data is ready
    final isLoading = weeksAsync.isLoading || vaccinesAsync.isLoading || dangerAsync.isLoading;
    final hasError = weeksAsync.hasError || vaccinesAsync.hasError || dangerAsync.hasError;

    return SoftBackgroundLayout(
      hasScrollBody: true,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
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
                Text(
                  'Maternal Health',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pregnancy guide, vaccines & danger signs.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 32),

                if (isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (hasError)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Error loading data. Please try again.',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                  )
                else ...[
                  // ── Danger Signs ─────────────────────────────────────
                  _sectionTitle(context, 'Danger Signs — Seek Help Immediately', color: Colors.red[800]!),
                  const SizedBox(height: 12),
                  Builder(builder: (_) {
                    final signs = dangerAsync.value ?? [];
                    if (signs.isEmpty) return const SizedBox.shrink();
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: signs.map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.warning_amber_rounded, color: Colors.red[700], size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  s.signText,
                                  style: TextStyle(color: Colors.red[900], fontSize: 13, height: 1.4),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: s.referralLevel == 'Emergency' ? Colors.red : Colors.orange,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  s.referralLevel ?? '',
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    );
                  }),
                  const SizedBox(height: 32),

                  // ── Maternal Vaccines ─────────────────────────────────
                  _sectionTitle(context, 'Maternal Immunization Schedule'),
                  const SizedBox(height: 12),
                  Builder(builder: (_) {
                    final vaccines = vaccinesAsync.value ?? [];
                    if (vaccines.isEmpty) return const SizedBox.shrink();
                    return Column(
                      children: vaccines.map((v) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildVaccineCard(context, v.title, v.recommendedTime, v.code),
                      )).toList(),
                    );
                  }),
                  const SizedBox(height: 32),

                  // ── Pregnancy Weeks ───────────────────────────────────
                  _sectionTitle(context, 'Pregnancy Journey — Week by Week'),
                  const SizedBox(height: 12),
                  Builder(builder: (_) {
                    final weeks = weeksAsync.value ?? [];
                    if (weeks.isEmpty) return const SizedBox.shrink();
                    return Column(
                      children: weeks.map((w) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PregnancyWeekDetailScreen(week: w)),
                          ),
                          child: _buildWeekCard(context, w.weekNo, w.babyGrowth),
                        ),
                      )).toList(),
                    );
                  }),
                  const SizedBox(height: 100),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title, {Color? color}) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: 18,
        color: color,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildVaccineCard(BuildContext context, String title, String? time, String? code) {
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                code ?? '💉',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                if (time != null) ...[
                  const SizedBox(height: 4),
                  Text(time, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12, color: Colors.grey[600])),
                ],
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 22),
        ],
      ),
    );
  }

  Widget _buildWeekCard(BuildContext context, int weekNo, String babyGrowth) {
    final trimester = weekNo <= 12 ? '1st' : weekNo <= 26 ? '2nd' : '3rd';
    final color = weekNo <= 12 ? Colors.green : weekNo <= 26 ? Colors.blue : Colors.purple;
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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$weekNo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  'wk',
                  style: TextStyle(fontSize: 10, color: color),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Week $weekNo — $trimester Trimester',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  babyGrowth,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: color),
        ],
      ),
    );
  }
}
