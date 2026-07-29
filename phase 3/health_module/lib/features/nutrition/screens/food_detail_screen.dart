import 'package:flutter/material.dart';
import 'package:health_module/core/theme/app_theme.dart';
import 'package:health_module/core/widgets/soft_background_layout.dart';
import '../models/food.dart';

class FoodDetailScreen extends StatelessWidget {
  final Food food;

  const FoodDetailScreen({super.key, required this.food});

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
                    color: Colors.orange[50],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.fastfood_rounded, color: Colors.orange, size: 60),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  food.name,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 32),
                  textAlign: TextAlign.center,
                ),
              ),
              if (food.localName.isNotEmpty && food.localName != food.name)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '(${food.localName})',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  food.category.isNotEmpty ? food.category : 'General Food',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16, color: Colors.orange[800]),
                ),
              ),
              const SizedBox(height: 24),
              
              if (food.dietTags.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: food.dietTags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(tag, style: TextStyle(color: Colors.green[800], fontSize: 12, fontWeight: FontWeight.bold)),
                  )).toList(),
                ),
                const SizedBox(height: 24),
              ],
              
              Text('Nutrition Facts (per ${food.servingSizeG}g)', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
              const SizedBox(height: 12),
              
              _buildNutritionFact(context, 'Calories', '${food.calories} kcal'),
              _buildNutritionFact(context, 'Protein', '${food.proteinG} g'),
              _buildNutritionFact(context, 'Carbs', '${food.carbsG} g'),
              _buildNutritionFact(context, 'Fat', '${food.fatG} g'),
              _buildNutritionFact(context, 'Fibre', '${food.fibreG} g'),
              _buildNutritionFact(context, 'Iron', '${food.ironMg} mg'),
              _buildNutritionFact(context, 'Calcium', '${food.calciumMg} mg'),
              _buildNutritionFact(context, 'Sugar', '${food.sugarG} g'),
              _buildNutritionFact(context, 'Sodium', '${food.sodiumMg} mg'),
              
              const SizedBox(height: 24),
              if (food.ayurvedaMeta != null) ...[
                Text('Ayurvedic Properties', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.brown[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.brown.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAyurRow('Rasa (Taste)', food.ayurvedaMeta!.rasa),
                      const SizedBox(height: 8),
                      _buildAyurRow('Guna (Qualities)', food.ayurvedaMeta!.guna),
                      const SizedBox(height: 8),
                      _buildAyurRow('Virya (Potency)', food.ayurvedaMeta!.virya),
                      const SizedBox(height: 8),
                      _buildAyurRow('Notes', food.ayurvedaMeta!.notes),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionFact(BuildContext context, String label, String value) {
    if (value == '0.0 g' || value == '0.0 mg' || value == '0.0 kcal') return const SizedBox();
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryColor)),
        ],
      ),
    );
  }
  
  Widget _buildAyurRow(String label, String value) {
    if (value.isEmpty) return const SizedBox();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
        Expanded(child: Text(value, style: TextStyle(color: Colors.brown[900]))),
      ],
    );
  }
}
