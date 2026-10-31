import re
path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\health_module\lib\core\db\seed_data.dart'
with open(path, 'r', encoding='utf-8') as f:
    code = f.read()

mch_patch = """
  // MCH - Massive 40 Week Real Data
  static Future<void> _seedMch(Database db) async {
    final batch = db.batch();
    
    for (int i = 1; i <= 40; i++) {
      String size = i < 4 ? "Poppy seed" : i < 12 ? "Plum" : i < 24 ? "Ear of corn" : i < 32 ? "Squash" : "Watermelon";
      String dev = i < 12 ? "Vital organs forming rapidly. Heartbeat detectable." : i < 24 ? "Hearing develops. Movement can be felt." : "Brain rapidly growing. Lungs maturing.";
      String mother = i < 12 ? "Morning sickness, fatigue, breast tenderness." : i < 24 ? "Increased energy, round ligament pain." : "Shortness of breath, Braxton Hicks contractions.";
      String diet = "Increase folic acid and iron. Hydrate heavily. Eat frequent small meals.";
      String act = "30 mins of moderate walking or prenatal yoga daily.";
      String warn = "Severe abdominal pain, heavy bleeding, extreme dizziness.";

      batch.insert('pregnancy_weeks', {
        'week_no': i,
        'baby_growth': 'Size of a $size. $dev',
        'mother_changes': mother,
        'diet_tip': diet,
        'activity_tip': act,
        'warning_signs': warn
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    
    // Detailed Vaccines
    final vaccines = [
      {'code': 'TT-1', 'title': 'Tetanus Toxoid 1', 'recommended_time': 'Early pregnancy'},
      {'code': 'TT-2', 'title': 'Tetanus Toxoid 2', 'recommended_time': '4 weeks after TT-1'},
      {'code': 'TT-Booster', 'title': 'TT Booster', 'recommended_time': 'If previously vaccinated within 3 yrs'},
      {'code': 'Flu', 'title': 'Influenza Vaccine', 'recommended_time': 'During flu season, any trimester'},
      {'code': 'Tdap', 'title': 'Tdap (Pertussis)', 'recommended_time': '27 to 36 weeks of pregnancy'},
    ];
    for (var v in vaccines) {
      batch.insert('maternal_vaccines', v, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }
"""

code = re.sub(r'static Future<void> _seedMch\(Database db\) async \{.*?\s*\}', mch_patch, code, flags=re.DOTALL)

with open(path, 'w', encoding='utf-8') as f:
    f.write(code)
