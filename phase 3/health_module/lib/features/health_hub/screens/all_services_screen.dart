import 'package:flutter/material.dart';
import 'package:health_module/core/theme/app_theme.dart';
import 'package:health_module/core/widgets/soft_background_layout.dart';

class AllServicesScreen extends StatelessWidget {
  const AllServicesScreen({super.key});

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
              Text(
                'All Health Services',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                'Explore all available modules in Adyuta Health.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 32),
              
              _buildServiceListTile(context, 'Pharmacy', 'Find medicines & health products', Icons.medication_rounded, Colors.teal[50]!, '/pharmacy'),
              _buildServiceListTile(context, 'First Aid & Emergency', 'Get help in critical situations', Icons.medical_services_rounded, Colors.red[50]!, '/firstaid'),
              _buildServiceListTile(context, 'Maternal & Child Health', 'Care for mother and child', Icons.pregnant_woman_rounded, Colors.purple[50]!, '/mch'),
              _buildServiceListTile(context, 'Local Health Directory', 'Find nearby clinics, hospitals', Icons.local_hospital_rounded, Colors.blue[50]!, '/directory'),
              _buildServiceListTile(context, 'Personal Health Record', 'Store & manage your info', Icons.folder_shared_rounded, Colors.teal[100]!, '/phr'),
              _buildServiceListTile(context, 'Diet & Nutrition', 'Eat healthy, live better', Icons.restaurant_rounded, Colors.orange[50]!, '/nutrition'),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceListTile(BuildContext context, String title, String subtitle, IconData icon, Color iconBg, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.softShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }
}
