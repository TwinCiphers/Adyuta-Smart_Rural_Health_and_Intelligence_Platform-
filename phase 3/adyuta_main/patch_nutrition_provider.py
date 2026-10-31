import re
path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\health_module\lib\features\nutrition\providers\nutrition_provider.dart'
with open(path, 'r', encoding='utf-8') as f:
    code = f.read()

new_imports = """import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/nutrition_repo.dart';
import '../repositories/food_atlas_service.dart';
import '../models/food.dart';
"""

code = code.replace("import 'package:flutter_riverpod/flutter_riverpod.dart';\nimport '../repositories/nutrition_repo.dart';\nimport '../models/food.dart';", new_imports)

new_providers = """
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
"""

if "foodAtlasSearchProvider" not in code:
    code += "\n" + new_providers

with open(path, 'w', encoding='utf-8') as f:
    f.write(code)
