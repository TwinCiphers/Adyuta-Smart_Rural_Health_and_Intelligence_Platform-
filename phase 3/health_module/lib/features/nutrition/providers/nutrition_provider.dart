import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/nutrition_repo.dart';
import '../repositories/food_atlas_service.dart';
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


final foodAtlasSearchProvider = FutureProvider.family<List<dynamic>, String>((ref, query) async {
  if (query.isEmpty) return [];
  return FoodAtlasService.searchFoods(query);
});

final foodChemicalsProvider = FutureProvider.family<List<dynamic>, String>((ref, foodId) async {
  return FoodAtlasService.getFoodChemicals(foodId);
});

final chemicalDiseasesProvider = FutureProvider.family<List<dynamic>, String>((ref, chemicalId) async {
  return FoodAtlasService.getChemicalDiseases(chemicalId);
});
