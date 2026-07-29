import 'package:flutter/material.dart';
import 'package:health_module/core/theme/app_theme.dart';
import 'package:health_module/core/widgets/soft_background_layout.dart';
import '../models/pregnancy_week.dart';

class PregnancyWeekDetailScreen extends StatelessWidget {
  final PregnancyWeek week;

  const PregnancyWeekDetailScreen({super.key, required this.week});

  @override
  Widget build(BuildContext context) {
    return SoftBackgroundLayout(
      child: SingleChildScrollView(
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
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.pregnant_woman_rounded, color: Colors.purple, size: 50),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Week ${week.weekNo}',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 32),
                ),
              ),
              const SizedBox(height: 32),
              
              _buildSection(context, 'Baby Growth', week.babyGrowth, Icons.child_care_rounded),
              if (week.motherChanges != null) 
                _buildSection(context, 'Changes in Mother', week.motherChanges!, Icons.face_retouching_natural_rounded),
              if (week.dietTip != null) 
                _buildSection(context, 'Diet Tip', week.dietTip!, Icons.restaurant_rounded),
              if (week.activityTip != null) 
                _buildSection(context, 'Activity Tip', week.activityTip!, Icons.directions_walk_rounded),
              if (week.warningSigns != null) 
                _buildSection(context, 'Warning Signs (Seek Help)', week.warningSigns!, Icons.warning_amber_rounded, color: Colors.red),
                
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content, IconData icon, {Color color = AppTheme.primaryColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, color: color)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }
}
