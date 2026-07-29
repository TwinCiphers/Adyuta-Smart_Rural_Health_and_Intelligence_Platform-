import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_module/core/theme/app_theme.dart';
import 'package:health_module/core/widgets/soft_background_layout.dart';
import '../providers/pharmacy_provider.dart';
import '../models/medicine.dart';
import 'medicine_detail_screen.dart';

class PharmacyScreen extends ConsumerWidget {
  const PharmacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(pharmacySearchQueryProvider);
    
    return SoftBackgroundLayout(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              // Custom App Bar
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: const Icon(Icons.favorite_border_rounded, color: AppTheme.primaryColor, size: 20),
                  )
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Hero section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pharmacy',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Find medicines, wellness products and more, delivered to your door.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 100,
                      child: const Icon(Icons.medical_information, size: 80, color: AppTheme.primaryColor),
                    ),
                  )
                ],
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
                    ref.read(pharmacySearchQueryProvider.notifier).state = val;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search medicines...',
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
                ref.watch(searchMedicinesProvider).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error: $err'),
                  data: (results) {
                    if (results.isEmpty) return const Text('No medicines found.');
                    return Column(
                      children: results.map((med) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MedicineDetailScreen(medicine: med))),
                          child: _buildMedicineCard(
                            context, 
                            med.brandName ?? med.genericName ?? 'Unknown', 
                            med.dosageAndForm ?? 'Pills', 
                            '₹ 120', '₹ 150', '20% OFF'
                          ),
                        ),
                      )).toList(),
                    );
                  }
                ),
                const SizedBox(height: 32),
              ],
              
              if (searchQuery.isEmpty) ...[
                // Top Picks
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Top Picks for You', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/all_medicines'),
                      child: Row(
                        children: [
                          Text('View All', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.primaryColor, fontSize: 14)),
                          const Icon(Icons.arrow_forward_rounded, color: AppTheme.primaryColor, size: 16),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                
                // Consume Provider
                ref.watch(topMedicinesProvider).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error loading medicines: $err'),
                  data: (medicines) {
                    if (medicines.isEmpty) return const Text('No medicines found.');
                    return Column(
                      children: medicines.map((med) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MedicineDetailScreen(medicine: med))),
                          child: _buildMedicineCard(
                            context, 
                            med.brandName ?? med.genericName ?? 'Unknown Medicine', 
                            med.dosageAndForm ?? 'Pills', 
                            '₹ 120', 
                            '₹ 150', 
                            '20% OFF'
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

  Widget _buildMedicineCard(BuildContext context, String name, String subtitle, String price, String oldPrice, String discount) {
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
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medication, color: Colors.grey, size: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(discount, style: TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(price, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(
                      oldPrice, 
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primaryColor),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: AppTheme.primaryColor, size: 20),
          )
        ],
      ),
    );
  }
}
