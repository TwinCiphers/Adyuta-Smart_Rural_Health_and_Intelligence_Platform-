import 'package:bhashini_core/bhashini_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_module/core/theme/app_theme.dart';
import 'package:health_module/core/widgets/soft_background_layout.dart';
import '../providers/nutrition_provider.dart';
import 'food_detail_screen.dart';
import 'food_atlas_research_screen.dart';

class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(nutritionSearchQueryProvider);

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
              GlobalBhashiniText(
                'Diet & Nutrition',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 8),
              GlobalBhashiniText(
                'Modern facts and Ayurvedic traditions.',
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
                    ref.read(nutritionSearchQueryProvider.notifier).state = val;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search foods (e.g. Ragi, Dal)...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodAtlasResearchScreen())),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.biotech, color: Colors.white, size: 28),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GlobalBhashiniText('Clinical Research', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                            GlobalBhashiniText('Powered by FoodAtlas AI', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              
              if (searchQuery.isNotEmpty) ...[
                GlobalBhashiniText('Search Results', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                const SizedBox(height: 16),
                ref.watch(searchFoodsProvider).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => GlobalBhashiniText('Error: $err'),
                  data: (results) {
                    if (results.isEmpty) return const GlobalBhashiniText('No foods found.');
                    return Column(
                      children: results.map((food) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FoodDetailScreen(food: food))),
                          child: _buildNeedCard(
                            context, 
                            food.name, 
                            Icons.fastfood_rounded, 
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
                GlobalBhashiniText('Foods in Database', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                const SizedBox(height: 16),
                
                ref.watch(foodsProvider).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => GlobalBhashiniText('Error loading foods: $err'),
                  data: (foods) {
                    if (foods.isEmpty) return const GlobalBhashiniText('No foods found.');
                    return Column(
                      children: foods.map((food) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FoodDetailScreen(food: food))),
                          child: _buildNeedCard(
                            context, 
                            food.name, 
                            Icons.fastfood_rounded, 
                            Colors.orange[50]!
                          ),
                        ),
                      )).toList(),
                    );
                  }
                ),
              ],
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeedCard(BuildContext context, String title, IconData icon, Color bg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: AppTheme.primaryColor, size: 28),
          ),
          const SizedBox(height: 12),
          GlobalBhashiniText(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}
