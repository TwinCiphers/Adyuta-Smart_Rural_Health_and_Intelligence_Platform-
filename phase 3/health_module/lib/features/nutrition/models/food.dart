class AyurvedaFoodMeta {
  final String rasa;
  final String guna;
  final String virya;
  final String notes;

  AyurvedaFoodMeta({
    required this.rasa,
    required this.guna,
    required this.virya,
    required this.notes,
  });

  factory AyurvedaFoodMeta.fromMap(Map<String, dynamic> map) {
    return AyurvedaFoodMeta(
      rasa: map['rasa'] ?? '',
      guna: map['guna'] ?? '',
      virya: map['virya'] ?? '',
      notes: map['notes'] ?? '',
    );
  }
}

class Recipe {
  final int id;
  final String name;
  final String localName;
  final int servingSizeG;
  final double calories;
  final double proteinG;
  final double ironMg;
  final String notes;

  Recipe({
    required this.id,
    required this.name,
    required this.localName,
    required this.servingSizeG,
    required this.calories,
    required this.proteinG,
    required this.ironMg,
    required this.notes,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      localName: map['local_name'],
      servingSizeG: map['serving_size_g'],
      calories: (map['calories'] ?? 0).toDouble(),
      proteinG: (map['protein_g'] ?? 0).toDouble(),
      ironMg: (map['iron_mg'] ?? 0).toDouble(),
      notes: map['notes'] ?? '',
    );
  }
}

class Food {
  final int id;
  final String name;
  final String localName;
  final String category;
  final int servingSizeG;
  final double calories;
  final double proteinG;
  final double ironMg;
  final double calciumMg;
  final double fibreG;
  final double fatG;
  final double carbsG;
  final double sugarG;
  final double sodiumMg;
  
  final AyurvedaFoodMeta? ayurvedaMeta;
  final List<String> dietTags;

  Food({
    required this.id,
    required this.name,
    required this.localName,
    required this.category,
    required this.servingSizeG,
    required this.calories,
    required this.proteinG,
    required this.ironMg,
    required this.calciumMg,
    required this.fibreG,
    required this.fatG,
    required this.carbsG,
    required this.sugarG,
    required this.sodiumMg,
    this.ayurvedaMeta,
    this.dietTags = const [],
  });

  factory Food.fromMap(
    Map<String, dynamic> map, {
    AyurvedaFoodMeta? ayurvedaMeta,
    List<String> dietTags = const [],
  }) {
    return Food(
      id: map['id'],
      name: map['name'] ?? '',
      localName: map['local_name'] ?? '',
      category: map['category'] ?? '',
      servingSizeG: map['serving_size_g'] ?? 100,
      calories: (map['calories'] ?? 0).toDouble(),
      proteinG: (map['protein_g'] ?? 0).toDouble(),
      ironMg: (map['iron_mg'] ?? 0).toDouble(),
      calciumMg: (map['calcium_mg'] ?? 0).toDouble(),
      fibreG: (map['fibre_g'] ?? 0).toDouble(),
      fatG: (map['fat_g'] ?? 0).toDouble(),
      carbsG: (map['carbs_g'] ?? 0).toDouble(),
      sugarG: (map['sugar_g'] ?? 0).toDouble(),
      sodiumMg: (map['sodium_mg'] ?? 0).toDouble(),
      ayurvedaMeta: ayurvedaMeta,
      dietTags: dietTags,
    );
  }
}
