import 'package:flutter/material.dart';
import 'package:health_module/core/theme/app_theme.dart';
import 'package:health_module/core/widgets/soft_background_layout.dart';
import 'package:health_module/core/widgets/custom_search_bar.dart';

class HealthHubScreen extends StatelessWidget {
  const HealthHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SoftBackgroundLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60), // Status bar padding
            
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 28),
                        children: [
                          const TextSpan(text: 'Hello, '),
                          TextSpan(
                            text: 'Sarah',
                            style: TextStyle(color: AppTheme.primaryColor),
                          ),
                          const TextSpan(text: ' 👋'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Take charge of your health 💚',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[200],
                  // Placeholder for user avatar
                  child: const Icon(Icons.person, color: Colors.grey, size: 30),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Search
            CustomSearchBar(
              hintText: 'Search health services, doctors...',
              onFilterTap: () {},
            ),
            
            const SizedBox(height: 32),
            
            // Services Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Health Services',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/all_services'),
                  child: Row(
                    children: [
                      Text(
                        'View All',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded, color: AppTheme.primaryColor, size: 16),
                    ],
                  ),
                )
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              padding: EdgeInsets.zero,
              children: [
                _buildServiceCard(context, 'Pharmacy', 'Find medicines & health products', Icons.medication_rounded, Colors.teal[50]!, '/pharmacy'),
                _buildServiceCard(context, 'First Aid &\nEmergency', 'Get help in critical situations', Icons.medical_services_rounded, Colors.red[50]!, '/firstaid'),
                _buildServiceCard(context, 'Maternal &\nChild Health', 'Care for mother and child', Icons.pregnant_woman_rounded, Colors.purple[50]!, '/mch'),
                _buildServiceCard(context, 'Local Health\nDirectory', 'Find nearby clinics, hospitals', Icons.local_hospital_rounded, Colors.blue[50]!, '/directory'),
                _buildServiceCard(context, 'Personal\nHealth Record', 'Store & manage your info', Icons.folder_shared_rounded, Colors.teal[100]!, '/phr'),
                _buildServiceCard(context, 'Diet &\nNutrition', 'Eat healthy, live better', Icons.restaurant_rounded, Colors.orange[50]!, '/nutrition'),
              ],
            ),

            const SizedBox(height: 24),

            // Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.lightbulb, color: AppTheme.primaryColor, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'Health Tip',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.primaryColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Small steps today,\nstronger you tomorrow.',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Drink more water, eat balanced meals and stay active.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Shield Icon representation
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shield_rounded, color: AppTheme.primaryColor, size: 40),
                  )
                ],
              ),
            ),
            const SizedBox(height: 100), // padding for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, String subtitle, IconData icon, Color iconBg, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            const Spacer(),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 11,
                height: 1.3,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chevron_right_rounded, color: AppTheme.primaryColor, size: 16),
            )
          ],
        ),
      ),
    );
  }
}
