import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/nutrition_repo.dart';
import '../models/food.dart';

final nutritionRepositoryProvider = Provider<NutritionRepository>((ref) {
  return NutritionRepository();
});

final nutritionSearchQueryProvider = StateProvider<String>((ref) => '');

final searchFoodsProvider = FutureProvider<List<Food>>((ref) async {
  final query = ref.watch(nutritionSearchQueryProvider);
  if (query.isEmpty) return [];
  final repo = ref.watch(nutritionRepositoryProvider);
  return repo.searchFoods(query);
});

final foodsProvider = FutureProvider<List<Food>>((ref) async {
  final repo = ref.watch(nutritionRepositoryProvider);
  return repo.getRecommendedFoods();
});

final recipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final repo = ref.watch(nutritionRepositoryProvider);
  return repo.getRecipes();
});
