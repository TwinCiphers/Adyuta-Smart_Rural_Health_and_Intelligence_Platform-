import 'package:bhashini_core/bhashini_core.dart';
import 'package:flutter/material.dart';
import 'package:health_module/core/theme/app_theme.dart';
import 'package:health_module/core/widgets/soft_background_layout.dart';
import 'package:health_module/core/widgets/custom_search_bar.dart';
import 'package:health_module/core/services/who_service.dart';
import 'package:health_module/core/models/health_data_point.dart';
import 'package:health_module/core/widgets/who_indicator_card.dart';

class HealthHubScreen extends StatefulWidget {
  const HealthHubScreen({super.key});

  @override
  State<HealthHubScreen> createState() => _HealthHubScreenState();
}

class _HealthHubScreenState extends State<HealthHubScreen> {
  List<HealthDataPoint> _indicators = [];
  bool _isLoadingIndicators = true;

  @override
  void initState() {
    super.initState();
    _loadIndicators();
  }

  Future<void> _loadIndicators() async {
    final data = await WhoService.getIndiaIndicators();
    if (mounted) {
      setState(() {
        _indicators = data;
        _isLoadingIndicators = false;
      });
    }
  }

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlobalBhashiniText(
                        'Hello 👋',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                      GlobalBhashiniText(
                        'How are you feeling?',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            CustomSearchBar(
              hintText: 'Search health services, doctors...',
              onFilterTap: () {},
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GlobalBhashiniText(
                    'Health Services',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/all_services'),
                  child: Row(
                    children: [
                      GlobalBhashiniText(
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
            
            // Live WHO Indicators (Replaces static tip)
            WhoIndicatorCard(
              indicators: _indicators,
              isLoading: _isLoadingIndicators,
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
            GlobalBhashiniText(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            GlobalBhashiniText(
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
