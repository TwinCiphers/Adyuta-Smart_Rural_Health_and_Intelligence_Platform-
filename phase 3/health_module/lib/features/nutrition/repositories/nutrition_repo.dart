import 'package:health_module/core/db/database_helper.dart';
import '../models/food.dart';

class NutritionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Food>> getRecommendedFoods() async {
    final db = await _dbHelper.getDatabase('nutrition.db');
    final maps = await db.query('foods', limit: 15);
    return await _parseFoods(maps);
  }

  Future<List<Food>> searchFoods(String query) async {
    final db = await _dbHelper.getDatabase('nutrition.db');
    final maps = await db.query(
      'foods',
      where: 'name LIKE ? OR local_name LIKE ? OR category LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      limit: 20,
    );
    return await _parseFoods(maps);
  }
  
  Future<List<Recipe>> getRecipes() async {
    final db = await _dbHelper.getDatabase('nutrition.db');
    final maps = await db.query('recipes', limit: 10);
    return maps.map((m) => Recipe.fromMap(m)).toList();
  }

  Future<List<Food>> _parseFoods(List<Map<String, dynamic>> maps) async {
    final db = await _dbHelper.getDatabase('nutrition.db');
    List<Food> foods = [];
    
    for (var map in maps) {
      int id = map['id'];
      
      // Fetch Ayurveda meta
      AyurvedaFoodMeta? meta;
      try {
        final ayurMaps = await db.query('ayurveda_food_meta', where: 'food_id = ?', whereArgs: [id]);
        if (ayurMaps.isNotEmpty) {
          meta = AyurvedaFoodMeta.fromMap(ayurMaps.first);
        }
      } catch (_) {}
      
      // Fetch diet tags
      List<String> tags = [];
      try {
        final tagMaps = await db.query('diet_tags', where: 'food_id = ?', whereArgs: [id]);
        tags = tagMaps.map((m) => m['tag'] as String).toList();
      } catch (_) {}
      
      foods.add(Food.fromMap(map, ayurvedaMeta: meta, dietTags: tags));
    }
    
    return foods;
  }
}
