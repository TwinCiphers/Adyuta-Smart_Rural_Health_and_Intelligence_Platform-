import 'package:flutter/material.dart';
import 'package:health_module/core/theme/app_theme.dart';
import 'package:health_module/core/widgets/soft_background_layout.dart';
import '../models/facility.dart';

class FacilityDetailScreen extends StatelessWidget {
  final Facility facility;

  const FacilityDetailScreen({super.key, required this.facility});

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
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_hospital_rounded, color: Colors.blue, size: 60),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  facility.name,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    facility.type,
                    style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              _buildInfoCard(context, Icons.location_on_rounded, 'Address', facility.address, Colors.teal),
              if (facility.phone != null)
                _buildInfoCard(context, Icons.phone_rounded, 'Contact Phone', facility.phone!, Colors.green),
              if (facility.workingHours != null)
                _buildInfoCard(context, Icons.access_time_rounded, 'Operating Hours', facility.workingHours!, Colors.orange),
              _buildInfoCard(context, Icons.info_outline_rounded, '24x7 Available', facility.is24x7 == 1 ? 'Yes' : 'No', facility.is24x7 == 1 ? Colors.green : Colors.grey),
                
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String title, String content, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 4),
                Text(content, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
