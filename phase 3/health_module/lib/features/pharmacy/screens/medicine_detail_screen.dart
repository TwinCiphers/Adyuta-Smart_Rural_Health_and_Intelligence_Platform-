import 'package:flutter/material.dart';
import 'package:health_module/core/theme/app_theme.dart';
import 'package:health_module/core/widgets/soft_background_layout.dart';
import '../models/medicine.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicineDetailScreen extends StatelessWidget {
  final Medicine medicine;

  const MedicineDetailScreen({super.key, required this.medicine});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      debugPrint('Could not launch $url');
    }
  }

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
                    color: medicine.system.toLowerCase() == 'ayurveda' ? Colors.green[50] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    medicine.system.toLowerCase() == 'ayurveda' ? Icons.eco : Icons.medication, 
                    color: medicine.system.toLowerCase() == 'ayurveda' ? Colors.green : Colors.grey, 
                    size: 60
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                medicine.brandName ?? medicine.genericName ?? 'Unknown',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: medicine.system.toLowerCase() == 'ayurveda' ? Colors.green[100] : Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      medicine.system.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12, 
                        fontWeight: FontWeight.bold,
                        color: medicine.system.toLowerCase() == 'ayurveda' ? Colors.green[800] : Colors.blue[800],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      medicine.dosageAndForm ?? 'Pills',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16, color: AppTheme.primaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              if (medicine.purchaseLinks.isNotEmpty) ...[
                Text('Available On', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: medicine.purchaseLinks.map((link) => GestureDetector(
                    onTap: () => _launchUrl(link.url),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppTheme.primaryColor),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.shopping_cart_checkout, color: AppTheme.primaryColor, size: 18),
                          const SizedBox(width: 8),
                          Text(link.platform, style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 24),
              ],
              
              if (medicine.genericName != null && medicine.brandName != null && medicine.brandName != medicine.genericName) 
                _buildSection(context, 'Generic Name', medicine.genericName!),
                
              if (medicine.system.toLowerCase() == 'ayurveda') ...[
                if (medicine.botanicalName != null) _buildSection(context, 'Botanical Name', medicine.botanicalName!),
                if (medicine.family != null) _buildSection(context, 'Family', medicine.family!),
                if (medicine.vernacularNames != null) _buildSection(context, 'Vernacular Names', medicine.vernacularNames!),
                if (medicine.partUsed != null) _buildSection(context, 'Part Used', medicine.partUsed!),
              ],
              
              if (medicine.uses != null) 
                _buildSection(context, 'Indications & Uses', medicine.uses!),
              if (medicine.mechanism != null) 
                _buildSection(context, 'Mechanism of Action', medicine.mechanism!),
              if (medicine.sideEffects != null) 
                _buildSection(context, 'Side Effects', medicine.sideEffects!),
              if (medicine.drugInteractions != null) 
                _buildSection(context, 'Drug Interactions', medicine.drugInteractions!),
              if (medicine.warningsAndContraindications != null) 
                _buildSection(context, 'Warnings', medicine.warningsAndContraindications!, isWarning: true),
              if (medicine.safetyPregnancyLactation != null) 
                _buildSection(context, 'Pregnancy & Lactation', medicine.safetyPregnancyLactation!),
              if (medicine.qualityStandardization != null) 
                _buildSection(context, 'Standardization', medicine.qualityStandardization!),
              
              const SizedBox(height: 100), // padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content, {bool isWarning = false}) {
    if (content.trim().isEmpty || content.trim() == 'N/A') return const SizedBox();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isWarning ? Colors.red[50] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isWarning ? Border.all(color: Colors.red.withOpacity(0.3)) : Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isWarning) const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                if (isWarning) const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16, color: isWarning ? Colors.red[800] : Colors.black87)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14, height: 1.5, color: isWarning ? Colors.red[900] : Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
