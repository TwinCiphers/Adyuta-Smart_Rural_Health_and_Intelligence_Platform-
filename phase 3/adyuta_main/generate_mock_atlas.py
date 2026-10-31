import re

path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\health_module\lib\features\nutrition\repositories\food_atlas_service.dart'

with open(path, 'r', encoding='utf-8') as f:
    code = f.read()

new_mocks = """
  // --- Enhanced Mocks for Demonstration ---
  static List<dynamic> _mockSearch(String query) {
    final q = query.toLowerCase();
    final db = [
      {'id': 'FA:0001', 'name': 'Garlic', 'type': 'food'},
      {'id': 'FA:0002', 'name': 'Turmeric', 'type': 'food'},
      {'id': 'FA:0003', 'name': 'Ginger', 'type': 'food'},
      {'id': 'FA:0004', 'name': 'Green Tea', 'type': 'food'},
      {'id': 'FA:0005', 'name': 'Tomato', 'type': 'food'},
      {'id': 'FA:0006', 'name': 'Spinach', 'type': 'food'},
      {'id': 'FA:0007', 'name': 'Broccoli', 'type': 'food'},
      {'id': 'FA:0008', 'name': 'Blueberry', 'type': 'food'},
      {'id': 'FA:0009', 'name': 'Walnut', 'type': 'food'},
      {'id': 'FA:0010', 'name': 'Salmon', 'type': 'food'},
      {'id': 'FA:0011', 'name': 'Oats', 'type': 'food'},
      {'id': 'FA:0012', 'name': 'Cinnamon', 'type': 'food'},
      {'id': 'FA:0013', 'name': 'Avocado', 'type': 'food'},
      {'id': 'FA:0014', 'name': 'Almond', 'type': 'food'},
      {'id': 'FA:0015', 'name': 'Olive Oil', 'type': 'food'},
      {'id': 'FA:0016', 'name': 'Dark Chocolate', 'type': 'food'},
      {'id': 'FA:0017', 'name': 'Flaxseed', 'type': 'food'},
      {'id': 'FA:0018', 'name': 'Kale', 'type': 'food'},
      {'id': 'FA:0019', 'name': 'Lemon', 'type': 'food'},
      {'id': 'FA:0020', 'name': 'Pomegranate', 'type': 'food'},
    ];
    if (q.isEmpty) return db;
    return db.where((e) => (e['name'] as String).toLowerCase().contains(q)).toList();
  }

  static List<dynamic> _mockChemicals(String foodId) {
    final Map<String, List<Map<String, String>>> chemMap = {
      'FA:0001': [
        {'chemical_id': 'CH:101', 'chemical_name': 'Allicin', 'relationship': 'contains'},
        {'chemical_id': 'CH:102', 'chemical_name': 'Quercetin', 'relationship': 'contains'}
      ],
      'FA:0002': [
        {'chemical_id': 'CH:201', 'chemical_name': 'Curcumin', 'relationship': 'contains'},
        {'chemical_id': 'CH:202', 'chemical_name': 'Demethoxycurcumin', 'relationship': 'contains'}
      ],
      'FA:0003': [
        {'chemical_id': 'CH:301', 'chemical_name': 'Gingerol', 'relationship': 'contains'},
        {'chemical_id': 'CH:302', 'chemical_name': 'Shogaol', 'relationship': 'contains'}
      ],
      'FA:0004': [
        {'chemical_id': 'CH:401', 'chemical_name': 'Epigallocatechin Gallate (EGCG)', 'relationship': 'contains'},
        {'chemical_id': 'CH:402', 'chemical_name': 'L-theanine', 'relationship': 'contains'}
      ],
      'FA:0005': [
        {'chemical_id': 'CH:501', 'chemical_name': 'Lycopene', 'relationship': 'contains'},
        {'chemical_id': 'CH:502', 'chemical_name': 'Beta-carotene', 'relationship': 'contains'}
      ],
      'FA:0006': [
        {'chemical_id': 'CH:601', 'chemical_name': 'Lutein', 'relationship': 'contains'},
        {'chemical_id': 'CH:602', 'chemical_name': 'Zeaxanthin', 'relationship': 'contains'},
        {'chemical_id': 'CH:603', 'chemical_name': 'Kaempferol', 'relationship': 'contains'}
      ],
      'FA:0007': [
        {'chemical_id': 'CH:701', 'chemical_name': 'Sulforaphane', 'relationship': 'contains'},
        {'chemical_id': 'CH:702', 'chemical_name': 'Glucoraphanin', 'relationship': 'contains'}
      ],
      'FA:0008': [
        {'chemical_id': 'CH:801', 'chemical_name': 'Anthocyanins', 'relationship': 'contains'},
        {'chemical_id': 'CH:102', 'chemical_name': 'Quercetin', 'relationship': 'contains'}
      ],
      'FA:0009': [
        {'chemical_id': 'CH:901', 'chemical_name': 'Alpha-linolenic acid (ALA)', 'relationship': 'contains'},
        {'chemical_id': 'CH:902', 'chemical_name': 'Ellagic acid', 'relationship': 'contains'}
      ],
      'FA:0010': [
        {'chemical_id': 'CH:1001', 'chemical_name': 'Eicosapentaenoic acid (EPA)', 'relationship': 'contains'},
        {'chemical_id': 'CH:1002', 'chemical_name': 'Docosahexaenoic acid (DHA)', 'relationship': 'contains'},
        {'chemical_id': 'CH:1003', 'chemical_name': 'Astaxanthin', 'relationship': 'contains'}
      ],
      'FA:0011': [
        {'chemical_id': 'CH:1101', 'chemical_name': 'Beta-glucan', 'relationship': 'contains'},
        {'chemical_id': 'CH:1102', 'chemical_name': 'Avenanthramides', 'relationship': 'contains'}
      ],
      'FA:0012': [
        {'chemical_id': 'CH:1201', 'chemical_name': 'Cinnamaldehyde', 'relationship': 'contains'},
        {'chemical_id': 'CH:1202', 'chemical_name': 'Coumarin', 'relationship': 'contains'}
      ],
      'FA:0013': [
        {'chemical_id': 'CH:1301', 'chemical_name': 'Oleic acid', 'relationship': 'contains'},
        {'chemical_id': 'CH:601', 'chemical_name': 'Lutein', 'relationship': 'contains'}
      ],
      'FA:0014': [
        {'chemical_id': 'CH:1401', 'chemical_name': 'Vitamin E (Alpha-tocopherol)', 'relationship': 'contains'},
        {'chemical_id': 'CH:1402', 'chemical_name': 'Phytic acid', 'relationship': 'contains'}
      ],
      'FA:0015': [
        {'chemical_id': 'CH:1301', 'chemical_name': 'Oleic acid', 'relationship': 'contains'},
        {'chemical_id': 'CH:1501', 'chemical_name': 'Oleocanthal', 'relationship': 'contains'}
      ],
      'FA:0016': [
        {'chemical_id': 'CH:1601', 'chemical_name': 'Theobromine', 'relationship': 'contains'},
        {'chemical_id': 'CH:1602', 'chemical_name': 'Epicatechin', 'relationship': 'contains'}
      ],
      'FA:0017': [
        {'chemical_id': 'CH:901', 'chemical_name': 'Alpha-linolenic acid (ALA)', 'relationship': 'contains'},
        {'chemical_id': 'CH:1701', 'chemical_name': 'Lignans (SDG)', 'relationship': 'contains'}
      ],
      'FA:0018': [
        {'chemical_id': 'CH:601', 'chemical_name': 'Lutein', 'relationship': 'contains'},
        {'chemical_id': 'CH:701', 'chemical_name': 'Sulforaphane', 'relationship': 'contains'}
      ],
      'FA:0019': [
        {'chemical_id': 'CH:1901', 'chemical_name': 'Citric acid', 'relationship': 'contains'},
        {'chemical_id': 'CH:1902', 'chemical_name': 'D-Limonene', 'relationship': 'contains'}
      ],
      'FA:0020': [
        {'chemical_id': 'CH:2001', 'chemical_name': 'Punicalagins', 'relationship': 'contains'},
        {'chemical_id': 'CH:2002', 'chemical_name': 'Punicic acid', 'relationship': 'contains'}
      ],
    };
    return chemMap[foodId] ?? [];
  }

  static List<dynamic> _mockDiseases(String chemicalId) {
    final Map<String, List<Map<String, String>>> disMap = {
      'CH:101': [
        {'disease_id': 'D:001', 'disease_name': 'Hypertension', 'relationship': 'reduces'},
        {'disease_id': 'D:002', 'disease_name': 'Hyperlipidemia', 'relationship': 'reduces'},
        {'disease_id': 'D:003', 'disease_name': 'Atherosclerosis', 'relationship': 'reduces'}
      ],
      'CH:102': [
        {'disease_id': 'D:004', 'disease_name': 'Allergic Rhinitis', 'relationship': 'reduces'},
        {'disease_id': 'D:005', 'disease_name': 'Systemic Inflammation', 'relationship': 'reduces'}
      ],
      'CH:201': [
        {'disease_id': 'D:006', 'disease_name': 'Osteoarthritis', 'relationship': 'reduces'},
        {'disease_id': 'D:007', 'disease_name': 'Rheumatoid Arthritis', 'relationship': 'reduces'},
        {'disease_id': 'D:008', 'disease_name': 'Depression', 'relationship': 'reduces'}
      ],
      'CH:202': [
        {'disease_id': 'D:009', 'disease_name': 'Oxidative Stress', 'relationship': 'reduces'},
      ],
      'CH:301': [
        {'disease_id': 'D:010', 'disease_name': 'Nausea / Morning Sickness', 'relationship': 'reduces'},
        {'disease_id': 'D:011', 'disease_name': 'Dysmenorrhea', 'relationship': 'reduces'}
      ],
      'CH:302': [
        {'disease_id': 'D:012', 'disease_name': 'Neurodegeneration', 'relationship': 'reduces'},
      ],
      'CH:401': [
        {'disease_id': 'D:013', 'disease_name': 'Obesity', 'relationship': 'reduces'},
        {'disease_id': 'D:014', 'disease_name': 'Type 2 Diabetes', 'relationship': 'reduces'}
      ],
      'CH:402': [
        {'disease_id': 'D:015', 'disease_name': 'Anxiety', 'relationship': 'reduces'},
        {'disease_id': 'D:016', 'disease_name': 'Insomnia', 'relationship': 'reduces'}
      ],
      'CH:501': [
        {'disease_id': 'D:017', 'disease_name': 'Prostate Cancer Risk', 'relationship': 'reduces'},
        {'disease_id': 'D:018', 'disease_name': 'UV Skin Damage', 'relationship': 'reduces'}
      ],
      'CH:502': [
        {'disease_id': 'D:019', 'disease_name': 'Macular Degeneration', 'relationship': 'reduces'},
      ],
      'CH:601': [
        {'disease_id': 'D:019', 'disease_name': 'Macular Degeneration', 'relationship': 'reduces'},
        {'disease_id': 'D:020', 'disease_name': 'Cataracts', 'relationship': 'reduces'}
      ],
      'CH:602': [
        {'disease_id': 'D:019', 'disease_name': 'Macular Degeneration', 'relationship': 'reduces'},
      ],
      'CH:603': [
        {'disease_id': 'D:021', 'disease_name': 'Chronic Inflammation', 'relationship': 'reduces'},
      ],
      'CH:701': [
        {'disease_id': 'D:022', 'disease_name': 'Gastric Ulcers (H. pylori)', 'relationship': 'reduces'},
        {'disease_id': 'D:023', 'disease_name': 'Oxidative DNA Damage', 'relationship': 'reduces'}
      ],
      'CH:702': [
        {'disease_id': 'D:024', 'disease_name': 'Systemic Toxicity', 'relationship': 'reduces'},
      ],
      'CH:801': [
        {'disease_id': 'D:025', 'disease_name': 'Cognitive Decline', 'relationship': 'reduces'},
        {'disease_id': 'D:026', 'disease_name': 'Cardiometabolic Syndrome', 'relationship': 'reduces'}
      ],
      'CH:901': [
        {'disease_id': 'D:027', 'disease_name': 'Arrhythmia', 'relationship': 'reduces'},
        {'disease_id': 'D:028', 'disease_name': 'Coronary Artery Disease', 'relationship': 'reduces'}
      ],
      'CH:902': [
        {'disease_id': 'D:029', 'disease_name': 'Hyperpigmentation', 'relationship': 'reduces'},
      ],
      'CH:1001': [
        {'disease_id': 'D:030', 'disease_name': 'Hypertriglyceridemia', 'relationship': 'reduces'},
        {'disease_id': 'D:007', 'disease_name': 'Rheumatoid Arthritis', 'relationship': 'reduces'}
      ],
      'CH:1002': [
        {'disease_id': 'D:031', 'disease_name': 'Alzheimer\\'s Disease', 'relationship': 'reduces'},
        {'disease_id': 'D:032', 'disease_name': 'ADHD', 'relationship': 'reduces'}
      ],
      'CH:1003': [
        {'disease_id': 'D:033', 'disease_name': 'Skin Aging', 'relationship': 'reduces'},
      ],
      'CH:1101': [
        {'disease_id': 'D:002', 'disease_name': 'Hyperlipidemia (High LDL)', 'relationship': 'reduces'},
        {'disease_id': 'D:034', 'disease_name': 'Hyperglycemia', 'relationship': 'reduces'}
      ],
      'CH:1102': [
        {'disease_id': 'D:035', 'disease_name': 'Arterial Stiffness', 'relationship': 'reduces'},
      ],
      'CH:1201': [
        {'disease_id': 'D:014', 'disease_name': 'Type 2 Diabetes', 'relationship': 'reduces'},
        {'disease_id': 'D:036', 'disease_name': 'Insulin Resistance', 'relationship': 'reduces'}
      ],
      'CH:1202': [
        {'disease_id': 'D:037', 'disease_name': 'Hepatotoxicity (at high doses)', 'relationship': 'worsens'},
      ],
      'CH:1301': [
        {'disease_id': 'D:038', 'disease_name': 'Metabolic Syndrome', 'relationship': 'reduces'},
        {'disease_id': 'D:028', 'disease_name': 'Coronary Artery Disease', 'relationship': 'reduces'}
      ],
      'CH:1401': [
        {'disease_id': 'D:039', 'disease_name': 'Non-alcoholic Fatty Liver Disease (NAFLD)', 'relationship': 'reduces'},
      ],
      'CH:1402': [
        {'disease_id': 'D:040', 'disease_name': 'Iron Deficiency Anemia (inhibits absorption)', 'relationship': 'worsens'},
      ],
      'CH:1501': [
        {'disease_id': 'D:007', 'disease_name': 'Rheumatoid Arthritis', 'relationship': 'reduces'},
        {'disease_id': 'D:031', 'disease_name': 'Alzheimer\\'s Disease', 'relationship': 'reduces'}
      ],
      'CH:1601': [
        {'disease_id': 'D:001', 'disease_name': 'Hypertension', 'relationship': 'reduces'},
        {'disease_id': 'D:041', 'disease_name': 'Asthma (bronchodilator effect)', 'relationship': 'reduces'}
      ],
      'CH:1602': [
        {'disease_id': 'D:042', 'disease_name': 'Endothelial Dysfunction', 'relationship': 'reduces'},
      ],
      'CH:1701': [
        {'disease_id': 'D:043', 'disease_name': 'Breast Cancer Risk', 'relationship': 'reduces'},
        {'disease_id': 'D:044', 'disease_name': 'Menopausal Symptoms', 'relationship': 'reduces'}
      ],
      'CH:1901': [
        {'disease_id': 'D:045', 'disease_name': 'Kidney Stones (Calcium Oxalate)', 'relationship': 'reduces'},
      ],
      'CH:1902': [
        {'disease_id': 'D:046', 'disease_name': 'GERD / Heartburn', 'relationship': 'worsens'},
      ],
      'CH:2001': [
        {'disease_id': 'D:017', 'disease_name': 'Prostate Cancer Risk', 'relationship': 'reduces'},
        {'disease_id': 'D:047', 'disease_name': 'Dental Plaque', 'relationship': 'reduces'}
      ],
      'CH:2002': [
        {'disease_id': 'D:048', 'disease_name': 'Skin Inflammation', 'relationship': 'reduces'},
      ]
    };
    return disMap[chemicalId] ?? [];
  }
}
"""

code = re.sub(r'// --- Mocks to ensure app functions beautifully even before API key is approved ---.*', new_mocks, code, flags=re.DOTALL)

with open(path, 'w', encoding='utf-8') as f:
    f.write(code)
