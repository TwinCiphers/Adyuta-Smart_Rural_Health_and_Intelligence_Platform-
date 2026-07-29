import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

/// SeedData: Embeds real, original health data from WHO, ICMR, API, IAP, and GoI sources.
/// This runs once when the database is first created, ensuring all services have data
/// even in fully offline/zero-connectivity environments.
class SeedData {
  static Future<void> seedDatabase(Database db, String dbName) async {
    debugPrint('SeedData: Seeding $dbName...');
    try {
      if (dbName == 'medicines.db') await _seedMedicines(db);
      if (dbName == 'firstaid.db') await _seedFirstAid(db);
      if (dbName == 'mch.db') await _seedMch(db);
      if (dbName == 'directory.db') await _seedDirectory(db);
      if (dbName == 'nutrition.db') await _seedNutrition(db);
      debugPrint('SeedData: Finished seeding $dbName');
    } catch (e) {
      debugPrint('SeedData: Error seeding $dbName: $e');
    }
  }

  // ─────────────────────────────────────────────────────
  // PHARMACY — WHO Essential Medicines + Ayurvedic Pharmacopoeia of India
  // ─────────────────────────────────────────────────────
  static Future<void> _seedMedicines(Database db) async {
    const medicines = [
      // ── ALLOPATHIC ─ WHO Essential Medicines List ──
      {'system': 'Allopathic', 'brand_name': 'Paracetamol (Crocin)', 'generic_name': 'Paracetamol / Acetaminophen', 'uses': 'Fever, mild to moderate pain, headache', 'dosage_and_form': 'Tablet 500mg, 650mg; Syrup 120mg/5ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Ibuprofen (Brufen)', 'generic_name': 'Ibuprofen', 'uses': 'Pain, fever, inflammation, arthritis', 'dosage_and_form': 'Tablet 200mg, 400mg, 600mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Aspirin (Disprin)', 'generic_name': 'Acetylsalicylic Acid', 'uses': 'Pain, fever, heart attack prevention, blood thinning', 'dosage_and_form': 'Tablet 75mg, 150mg, 325mg, 650mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Amoxicillin (Amoxil)', 'generic_name': 'Amoxicillin', 'uses': 'Bacterial infections: throat, ear, lung, urinary tract', 'dosage_and_form': 'Capsule 250mg, 500mg; Syrup 125mg/5ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Azithromycin (Zithromax)', 'generic_name': 'Azithromycin', 'uses': 'Respiratory infections, typhoid, STI, skin infections', 'dosage_and_form': 'Tablet 250mg, 500mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Ciprofloxacin (Ciplox)', 'generic_name': 'Ciprofloxacin', 'uses': 'UTI, diarrhea, enteric fever, respiratory infections', 'dosage_and_form': 'Tablet 250mg, 500mg, 750mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Metronidazole (Flagyl)', 'generic_name': 'Metronidazole', 'uses': 'Amoebiasis, giardiasis, anaerobic bacterial infections, dental infections', 'dosage_and_form': 'Tablet 200mg, 400mg; IV 500mg/100ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Doxycycline', 'generic_name': 'Doxycycline Hyclate', 'uses': 'Malaria prophylaxis, leptospirosis, rickettsial infections, acne', 'dosage_and_form': 'Capsule 100mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Co-trimoxazole (Bactrim)', 'generic_name': 'Trimethoprim + Sulfamethoxazole', 'uses': 'UTI, pneumonia (PCP), shigellosis', 'dosage_and_form': 'Tablet 480mg (80+400)', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Omeprazole (Prilosec)', 'generic_name': 'Omeprazole', 'uses': 'Acid reflux, peptic ulcer, GERD, H. pylori eradication', 'dosage_and_form': 'Capsule 20mg, 40mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Ranitidine (Zantac)', 'generic_name': 'Ranitidine', 'uses': 'Gastric ulcer, duodenal ulcer, GERD, heartburn', 'dosage_and_form': 'Tablet 150mg, 300mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Metformin (Glucophage)', 'generic_name': 'Metformin HCl', 'uses': 'Type 2 diabetes, PCOS, insulin resistance', 'dosage_and_form': 'Tablet 500mg, 850mg, 1000mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Glibenclamide', 'generic_name': 'Glibenclamide (Glyburide)', 'uses': 'Type 2 diabetes — stimulates insulin secretion', 'dosage_and_form': 'Tablet 2.5mg, 5mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Insulin Regular (Actrapid)', 'generic_name': 'Human Insulin Regular', 'uses': 'Diabetes mellitus Type 1 & 2, diabetic ketoacidosis', 'dosage_and_form': 'Injection 40 IU/ml, 100 IU/ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Amlodipine (Norvasc)', 'generic_name': 'Amlodipine Besylate', 'uses': 'High blood pressure, angina, coronary artery disease', 'dosage_and_form': 'Tablet 2.5mg, 5mg, 10mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Enalapril (Vasotec)', 'generic_name': 'Enalapril Maleate', 'uses': 'Hypertension, heart failure, post-MI cardioprotection', 'dosage_and_form': 'Tablet 2.5mg, 5mg, 10mg, 20mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Losartan (Cozaar)', 'generic_name': 'Losartan Potassium', 'uses': 'Hypertension, diabetic nephropathy, heart failure', 'dosage_and_form': 'Tablet 25mg, 50mg, 100mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Atenolol (Tenormin)', 'generic_name': 'Atenolol', 'uses': 'High blood pressure, angina, cardiac arrhythmia', 'dosage_and_form': 'Tablet 25mg, 50mg, 100mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Atorvastatin (Lipitor)', 'generic_name': 'Atorvastatin Calcium', 'uses': 'High cholesterol, cardiovascular risk reduction', 'dosage_and_form': 'Tablet 10mg, 20mg, 40mg, 80mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Furosemide (Lasix)', 'generic_name': 'Furosemide', 'uses': 'Edema, heart failure, hypertension, renal failure', 'dosage_and_form': 'Tablet 20mg, 40mg; Injection 20mg/2ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Cetirizine (Zyrtec)', 'generic_name': 'Cetirizine HCl', 'uses': 'Allergic rhinitis, urticaria, hay fever, itching', 'dosage_and_form': 'Tablet 5mg, 10mg; Syrup 5mg/5ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Salbutamol (Ventolin)', 'generic_name': 'Salbutamol Sulfate', 'uses': 'Asthma, COPD, bronchospasm, wheezing', 'dosage_and_form': 'Inhaler 100mcg/dose; Tablet 2mg, 4mg; Syrup', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Prednisolone', 'generic_name': 'Prednisolone', 'uses': 'Severe asthma, allergy, autoimmune disorders, inflammation', 'dosage_and_form': 'Tablet 5mg, 10mg, 20mg, 40mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Dexamethasone', 'generic_name': 'Dexamethasone', 'uses': 'Cerebral edema, severe allergy, croup, COVID-19 (severe)', 'dosage_and_form': 'Tablet 0.5mg; Injection 4mg/ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Diazepam (Valium)', 'generic_name': 'Diazepam', 'uses': 'Anxiety, seizure (status epilepticus), muscle spasm, alcohol withdrawal', 'dosage_and_form': 'Tablet 2mg, 5mg, 10mg; Injection 5mg/ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Phenobarbitone', 'generic_name': 'Phenobarbitone', 'uses': 'Epilepsy, febrile seizures, neonatal seizures', 'dosage_and_form': 'Tablet 30mg, 60mg; Injection 200mg/ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Carbamazepine (Tegretol)', 'generic_name': 'Carbamazepine', 'uses': 'Epilepsy, trigeminal neuralgia, bipolar disorder', 'dosage_and_form': 'Tablet 100mg, 200mg, 400mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Haloperidol (Haldol)', 'generic_name': 'Haloperidol', 'uses': 'Schizophrenia, psychosis, agitation, Tourette syndrome', 'dosage_and_form': 'Tablet 1.5mg, 5mg, 10mg; Injection 5mg/ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Amitriptyline (Elavil)', 'generic_name': 'Amitriptyline HCl', 'uses': 'Depression, neuropathic pain, migraine prophylaxis, fibromyalgia', 'dosage_and_form': 'Tablet 10mg, 25mg, 50mg, 75mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Folic Acid (Folate)', 'generic_name': 'Folic Acid', 'uses': 'Pregnancy (prevents neural tube defects), anemia, folate deficiency', 'dosage_and_form': 'Tablet 0.4mg, 1mg, 5mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Ferrous Sulphate (Iron)', 'generic_name': 'Ferrous Sulphate', 'uses': 'Iron deficiency anemia, pregnancy supplementation', 'dosage_and_form': 'Tablet 200mg (65mg elemental iron); Syrup 50mg/5ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Vitamin B12 (Cobalamin)', 'generic_name': 'Cyanocobalamin / Methylcobalamin', 'uses': 'B12 deficiency, pernicious anemia, neuropathy', 'dosage_and_form': 'Tablet 500mcg; Injection 1000mcg/ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Vitamin D3 (Calcirol)', 'generic_name': 'Cholecalciferol (Vitamin D3)', 'uses': 'Vitamin D deficiency, rickets, osteoporosis, immune support', 'dosage_and_form': 'Tablet 1000 IU, 60000 IU; Oral drops', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'ORS (Electral)', 'generic_name': 'Oral Rehydration Salts', 'uses': 'Diarrhea, dehydration, cholera, gastroenteritis', 'dosage_and_form': 'Powder sachet (WHO formulation: NaCl + KCl + Citrate + Glucose)', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Zinc Sulphate', 'generic_name': 'Zinc Sulphate', 'uses': 'Childhood diarrhea (adjunct), zinc deficiency, wound healing', 'dosage_and_form': 'Tablet 20mg; Syrup 20mg/5ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Albendazole (Zentel)', 'generic_name': 'Albendazole', 'uses': 'Intestinal worms (roundworm, hookworm, threadworm), giardia', 'dosage_and_form': 'Tablet 400mg; Suspension 200mg/5ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Artesunate', 'generic_name': 'Artesunate', 'uses': 'Severe falciparum malaria (first-line treatment)', 'dosage_and_form': 'Injection 60mg; Tablet 50mg, 100mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Chloroquine (Lariago)', 'generic_name': 'Chloroquine Phosphate', 'uses': 'Vivax malaria, uncomplicated falciparum malaria (sensitive)', 'dosage_and_form': 'Tablet 150mg, 250mg; Syrup 50mg/5ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Rifampicin (Rifampin)', 'generic_name': 'Rifampicin', 'uses': 'Tuberculosis (TB), leprosy (MDT), meningococcal prophylaxis', 'dosage_and_form': 'Capsule 150mg, 300mg, 450mg, 600mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Isoniazid (INH)', 'generic_name': 'Isoniazid', 'uses': 'Tuberculosis (active and latent), TB prophylaxis', 'dosage_and_form': 'Tablet 100mg, 300mg; Syrup 50mg/5ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Pyrazinamide', 'generic_name': 'Pyrazinamide', 'uses': 'Pulmonary tuberculosis (intensive phase)', 'dosage_and_form': 'Tablet 500mg, 750mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Ethambutol (Myambutol)', 'generic_name': 'Ethambutol HCl', 'uses': 'Tuberculosis — part of DOTS regimen', 'dosage_and_form': 'Tablet 400mg, 800mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Fluconazole (Diflucan)', 'generic_name': 'Fluconazole', 'uses': 'Fungal infections: candidiasis, cryptococcal meningitis', 'dosage_and_form': 'Capsule 50mg, 150mg; Syrup 50mg/5ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Acyclovir (Zovirax)', 'generic_name': 'Acyclovir (Aciclovir)', 'uses': 'Herpes simplex (cold sores), herpes zoster (shingles), chickenpox', 'dosage_and_form': 'Tablet 200mg, 400mg, 800mg; Cream 5%; IV 250mg vial', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Levothyroxine (Eltroxin)', 'generic_name': 'Levothyroxine Sodium', 'uses': 'Hypothyroidism, goiter, thyroid cancer (hormone replacement)', 'dosage_and_form': 'Tablet 25mcg, 50mcg, 100mcg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Digoxin (Lanoxin)', 'generic_name': 'Digoxin', 'uses': 'Heart failure, atrial fibrillation, flutter', 'dosage_and_form': 'Tablet 0.0625mg, 0.25mg; Injection 0.5mg/2ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Magnesium Sulphate (MgSO4)', 'generic_name': 'Magnesium Sulphate', 'uses': 'Eclampsia/pre-eclampsia (seizure prevention), severe asthma, torsades', 'dosage_and_form': 'Injection 500mg/ml (50% solution)', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Oxytocin (Pitocin)', 'generic_name': 'Oxytocin', 'uses': 'Labour induction, postpartum hemorrhage prevention', 'dosage_and_form': 'Injection 5 IU/ml, 10 IU/ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Tramadol (Ultram)', 'generic_name': 'Tramadol HCl', 'uses': 'Moderate to severe pain, post-operative pain', 'dosage_and_form': 'Tablet 50mg, 100mg; Injection 50mg/ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Ondansetron (Zofran)', 'generic_name': 'Ondansetron HCl', 'uses': 'Nausea, vomiting (chemotherapy, surgery, pregnancy)', 'dosage_and_form': 'Tablet 4mg, 8mg; Injection 2mg/ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Loperamide (Imodium)', 'generic_name': 'Loperamide HCl', 'uses': 'Acute diarrhea, travellers diarrhea (NOT in dysentery)', 'dosage_and_form': 'Capsule 2mg; Syrup 1mg/5ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Adrenaline (Epinephrine)', 'generic_name': 'Epinephrine / Adrenaline', 'uses': 'Anaphylaxis (first-line emergency), cardiac arrest, severe asthma', 'dosage_and_form': 'Injection 1mg/ml (1:1000); Auto-injector (EpiPen)', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Ringer Lactate Solution', 'generic_name': 'Compound Sodium Lactate (Hartmann)', 'uses': 'IV fluid resuscitation, dehydration, burns, surgery', 'dosage_and_form': 'IV Infusion 500ml, 1000ml bag', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Normal Saline (0.9% NaCl)', 'generic_name': 'Sodium Chloride 0.9%', 'uses': 'IV fluid replacement, sodium depletion, drug diluent', 'dosage_and_form': 'IV Infusion 100ml, 500ml, 1000ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Promethazine (Phenergan)', 'generic_name': 'Promethazine HCl', 'uses': 'Allergy, nausea, vomiting, motion sickness, sedation', 'dosage_and_form': 'Tablet 10mg, 25mg; Injection 25mg/ml', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Calcium Gluconate', 'generic_name': 'Calcium Gluconate', 'uses': 'Hypocalcemia, hyperkalemia (cardiac protection), magnesium toxicity', 'dosage_and_form': 'Injection 100mg/ml; Tablet 500mg', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Gentamicin', 'generic_name': 'Gentamicin Sulphate', 'uses': 'Serious gram-negative infections, neonatal sepsis, UTI', 'dosage_and_form': 'Injection 10mg/ml, 40mg/ml; Eye drops 0.3%', 'source_ref': 'WHO EML'},
      {'system': 'Allopathic', 'brand_name': 'Sodium Bicarbonate', 'generic_name': 'Sodium Bicarbonate', 'uses': 'Metabolic acidosis, cardiac arrest (adjunct), antacid', 'dosage_and_form': 'Injection 8.4% (1mEq/ml); Tablet 600mg', 'source_ref': 'WHO EML'},
      // ── AYURVEDIC ─ Ayurvedic Pharmacopoeia of India (API) ──
      {'system': 'Ayurvedic', 'brand_name': 'Ashwagandha (Withania)', 'generic_name': 'Withania somnifera (Ashwagandha)', 'uses': 'Stress, anxiety, weakness, low immunity, sexual debility, insomnia, cognitive function', 'dosage_and_form': 'Churna (powder) 3-6g with milk; Capsule 300-500mg; Tablet 1-2 tablets BD', 'source_ref': 'Ayurvedic Pharmacopoeia of India (API)'},
      {'system': 'Ayurvedic', 'brand_name': 'Triphala Churna', 'generic_name': 'Amalaki + Bibhitaki + Haritaki', 'uses': 'Constipation, digestive disorders, eye health, detox, anti-aging, weight management', 'dosage_and_form': 'Churna 3-6g at bedtime with warm water; Tablet 1-2 BD', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Brahmi (Bacopa)', 'generic_name': 'Bacopa monnieri', 'uses': 'Memory enhancement, anxiety, epilepsy, ADHD, dementia support, learning', 'dosage_and_form': 'Churna 3-6g; Capsule 300mg; Ghrita (medicated ghee)', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Neem (Nimba)', 'generic_name': 'Azadirachta indica', 'uses': 'Skin diseases, diabetes, malaria, wound healing, antibacterial, blood purification', 'dosage_and_form': 'Leaf churna 2-4g; Capsule 250-500mg; Twigs (teeth cleaning)', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Haridra (Turmeric)', 'generic_name': 'Curcuma longa (Curcumin)', 'uses': 'Anti-inflammatory, arthritis, wound healing, diabetes, liver protection, cancer prevention', 'dosage_and_form': 'Churna 1-3g with milk; Capsule 500mg; Paste (topical)', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Tulsi (Holy Basil)', 'generic_name': 'Ocimum sanctum', 'uses': 'Respiratory infections, fever, cough, cold, stress adaptogen, immunity', 'dosage_and_form': 'Fresh leaves 5-10g; Kashayam (decoction); Capsule 300mg', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Shatavari', 'generic_name': 'Asparagus racemosus', 'uses': 'Female reproductive health, galactagogue (increases milk), menopause, infertility, immunity', 'dosage_and_form': 'Churna 3-6g with milk; Capsule 500mg; Granules', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Guduchi (Giloy)', 'generic_name': 'Tinospora cordifolia', 'uses': 'Fever (chronic), dengue, immunity, diabetes, liver disease, gout, anti-aging', 'dosage_and_form': 'Stem kwath (decoction) 20-30ml; Churna 2-4g; Tablet 500mg', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Arjuna (Terminalia)', 'generic_name': 'Terminalia arjuna', 'uses': 'Heart disease, hypertension, angina, heart failure, cholesterol reduction', 'dosage_and_form': 'Bark churna 3-6g; Tablet 500mg; Arjunarishta 15-30ml', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Punarnava', 'generic_name': 'Boerhavia diffusa', 'uses': 'Kidney disease, urinary disorders, edema, liver disease, diuretic', 'dosage_and_form': 'Churna 3-6g; Tablet 500mg; Punarnavasava 15-30ml', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Shankhapushpi', 'generic_name': 'Convolvulus pluricaulis', 'uses': 'Memory, intelligence, anxiety, sleep disorders, hypertension, epilepsy', 'dosage_and_form': 'Churna 3-6g; Syrup 10ml; Capsule 250mg', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Amla (Indian Gooseberry)', 'generic_name': 'Emblica officinalis (Phyllanthus emblica)', 'uses': 'Vitamin C source, immunity, hair loss, diabetes, liver disease, eye health', 'dosage_and_form': 'Fresh fruit; Churna 3-6g; Juice 10-20ml; Capsule 500mg', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Trikatu Churna', 'generic_name': 'Pippali + Maricha + Shunthi', 'uses': 'Digestive disorders, respiratory conditions, obesity, metabolism booster, cold & flu', 'dosage_and_form': 'Churna 1-3g before meals with honey; Tablet 500mg', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Dashamoolarishtam', 'generic_name': 'Dashamoola (Ten roots formulation)', 'uses': 'Postpartum care, vata disorders, pain, inflammation, respiratory diseases', 'dosage_and_form': 'Arishtam 15-30ml after meals BD', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Chyawanprash', 'generic_name': 'Polyherbal Rasayana (Amla-based)', 'uses': 'Immunity, anti-aging, respiratory health, strength, vitality, children\'s health', 'dosage_and_form': '1-2 teaspoons (5-10g) with warm milk daily', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Sitopaladi Churna', 'generic_name': 'Sitopala + Pippali + Tamala Patra + Ela + Tvak', 'uses': 'Cough, cold, bronchitis, chronic fever, loss of appetite, TB (adjunct)', 'dosage_and_form': 'Churna 1-3g with honey 3-4 times daily', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Arogyavardhini Vati', 'generic_name': 'Herbo-mineral compound', 'uses': 'Liver disorders, skin diseases, obesity, diabetes, constipation, detoxification', 'dosage_and_form': 'Tablet 125-500mg BD with warm water after meals', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Kanchnar Guggulu', 'generic_name': 'Kanchnar + Guggulu + Triphala', 'uses': 'Thyroid (goitre), lymph node swelling, lipoma, skin diseases, PCOD', 'dosage_and_form': 'Tablet 250-500mg BD-TDS after meals', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Triphala Guggulu', 'generic_name': 'Triphala + Pippali + Guggulu', 'uses': 'Hemorrhoids (piles), fistula, constipation, obesity, skin diseases', 'dosage_and_form': 'Tablet 500mg BD after meals', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Chandraprabha Vati', 'generic_name': 'Polyherbo-mineral compound', 'uses': 'Urinary disorders, diabetes, kidney stones, sexual debility, skin diseases', 'dosage_and_form': 'Tablet 500-1000mg BD after meals', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Gokshuradi Guggulu', 'generic_name': 'Gokshura + Guggulu + Triphala', 'uses': 'Kidney stones, UTI, prostate enlargement, urinary tract diseases', 'dosage_and_form': 'Tablet 250-500mg TDS after meals with warm water', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Saraswatarishta', 'generic_name': 'Polyherbal fermented preparation', 'uses': 'Memory, intelligence, epilepsy, psychiatric disorders, voice disorders', 'dosage_and_form': 'Arishtam 15-30ml after meals with equal water BD', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Vrikshamla (Garcinia)', 'generic_name': 'Garcinia cambogia (Malabar tamarind)', 'uses': 'Obesity, weight loss, cholesterol reduction, constipation', 'dosage_and_form': 'Churna 3-6g before meals; Capsule 500mg; Tablet', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Mahasudarshana Churna', 'generic_name': 'Polyherbal compound (Sudarshana + 50 herbs)', 'uses': 'Chronic fever, malaria, liver diseases, inflammation, spleen enlargement', 'dosage_and_form': 'Churna 3-6g with honey or warm water TDS', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Lakshmi Vilas Ras', 'generic_name': 'Herbo-mineral (Kajjali + Tamra + Maricha...)', 'uses': 'Respiratory diseases, cough, bronchitis, asthma, chronic fever', 'dosage_and_form': 'Tablet 125mg BD-TDS with ginger juice/honey', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Moringa (Drumstick)', 'generic_name': 'Moringa oleifera', 'uses': 'Malnutrition, anemia, galactagogue, anti-inflammatory, diabetes, hypertension', 'dosage_and_form': 'Leaf powder 5-10g; Capsule 400mg; Fresh leaves cooked', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Kalmegh (Green Chiretta)', 'generic_name': 'Andrographis paniculata', 'uses': 'Liver disease, viral fever, dengue, hepatitis, anti-inflammatory, antibacterial', 'dosage_and_form': 'Churna 2-4g; Tablet 500mg; Capsule 300mg', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Sarpagandha (Rauwolfia)', 'generic_name': 'Rauwolfia serpentina', 'uses': 'Hypertension (High blood pressure), anxiety, insomnia, tachycardia', 'dosage_and_form': 'Churna 250-500mg BD; Tablet 50-100mg; under medical supervision', 'source_ref': 'API'},
      {'system': 'Ayurvedic', 'brand_name': 'Haritaki (Chebulic Myrobalan)', 'generic_name': 'Terminalia chebula', 'uses': 'Constipation, piles, respiratory disease, voice disorders, wound healing, digestive tonic', 'dosage_and_form': 'Churna 3-6g at bedtime; Tablet 500mg', 'source_ref': 'API'},
      {'system': 'Unani', 'brand_name': 'Sharbat Bazoori Motadil', 'generic_name': 'Compound Unani syrup', 'uses': 'Urinary disorders, kidney stones, UTI, burning micturition', 'dosage_and_form': 'Syrup 15-30ml twice daily', 'source_ref': 'Unani Pharmacopoeia of India'},
      {'system': 'Unani', 'brand_name': 'Majun Ushba', 'generic_name': 'Herbal compound (Smilax glabra)', 'uses': 'Skin diseases, syphilis, leprosy, blood purification, detoxification', 'dosage_and_form': 'Majun (paste) 5-10g BD', 'source_ref': 'Unani Pharmacopoeia of India'},
      {'system': 'Siddha', 'brand_name': 'Nilavembu Kudineer', 'generic_name': 'Andrographis paniculata compound', 'uses': 'Dengue, viral fever, chikungunya, malaria, body pain', 'dosage_and_form': 'Decoction 60ml twice daily', 'source_ref': 'Siddha Pharmacopoeia'},
      {'system': 'Siddha', 'brand_name': 'Kabasura Kudineer', 'generic_name': 'Compound siddha decoction (15 herbs)', 'uses': 'Respiratory infections, COVID-19 (mild), fever, cold, cough, immunomodulator', 'dosage_and_form': 'Decoction 60ml BD for 7-14 days', 'source_ref': 'AYUSH Ministry Protocol'},
      {'system': 'Homeopathic', 'brand_name': 'Arnica Montana', 'generic_name': 'Arnica montana (Leopards bane)', 'uses': 'Bruises, trauma, muscle soreness, shock, surgical recovery', 'dosage_and_form': 'Pills 30C or 200C; Cream/gel (topical)', 'source_ref': 'Homeopathic Pharmacopoeia of India'},
      {'system': 'Homeopathic', 'brand_name': 'Belladonna', 'generic_name': 'Atropa belladonna', 'uses': 'High fever with red face, throbbing headache, sore throat with sudden onset', 'dosage_and_form': 'Pills 30C; Dilution 30C, 200C', 'source_ref': 'Homeopathic Pharmacopoeia of India'},
    ];
    final batch = db.batch();
    for (final m in medicines) {
      batch.insert('medicines', m, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }

  // ─────────────────────────────────────────────────────
  // FIRST AID — Indian Red Cross / WHO First Aid Protocols
  // ─────────────────────────────────────────────────────
  static Future<void> _seedFirstAid(Database db) async {
    final topics = [
      {'id': 1, 'slug': 'snake_bite', 'title': 'Snake Bite', 'category': 'Poisoning & Envenomation', 'urgency_level': 'Life-Threatening', 'audio_key': null},
      {'id': 2, 'slug': 'burns', 'title': 'Burn Injury', 'category': 'Trauma', 'urgency_level': 'Severe', 'audio_key': null},
      {'id': 3, 'slug': 'drowning', 'title': 'Drowning / Near-Drowning', 'category': 'Airway Emergency', 'urgency_level': 'Life-Threatening', 'audio_key': null},
      {'id': 4, 'slug': 'heart_attack', 'title': 'Heart Attack (Myocardial Infarction)', 'category': 'Cardiac Emergency', 'urgency_level': 'Life-Threatening', 'audio_key': null},
      {'id': 5, 'slug': 'stroke', 'title': 'Stroke (Brain Attack)', 'category': 'Neurological Emergency', 'urgency_level': 'Life-Threatening', 'audio_key': null},
      {'id': 6, 'slug': 'fracture', 'title': 'Fracture / Broken Bone', 'category': 'Trauma', 'urgency_level': 'Serious', 'audio_key': null},
      {'id': 7, 'slug': 'severe_bleeding', 'title': 'Severe Bleeding / Open Wound', 'category': 'Trauma', 'urgency_level': 'Life-Threatening', 'audio_key': null},
      {'id': 8, 'slug': 'choking', 'title': 'Choking (Airway Obstruction)', 'category': 'Airway Emergency', 'urgency_level': 'Life-Threatening', 'audio_key': null},
      {'id': 9, 'slug': 'anaphylaxis', 'title': 'Anaphylaxis / Severe Allergic Reaction', 'category': 'Allergy Emergency', 'urgency_level': 'Life-Threatening', 'audio_key': null},
      {'id': 10, 'slug': 'heat_stroke', 'title': 'Heat Stroke / Sunstroke', 'category': 'Environmental Emergency', 'urgency_level': 'Life-Threatening', 'audio_key': null},
      {'id': 11, 'slug': 'seizure', 'title': 'Seizure / Epileptic Fit', 'category': 'Neurological Emergency', 'urgency_level': 'Serious', 'audio_key': null},
      {'id': 12, 'slug': 'diabetic_emergency', 'title': 'Diabetic Emergency (Hypo/Hyperglycemia)', 'category': 'Metabolic Emergency', 'urgency_level': 'Serious', 'audio_key': null},
      {'id': 13, 'slug': 'electrocution', 'title': 'Electric Shock / Electrocution', 'category': 'Environmental Emergency', 'urgency_level': 'Life-Threatening', 'audio_key': null},
      {'id': 14, 'slug': 'dog_bite', 'title': 'Dog Bite / Animal Bite', 'category': 'Poisoning & Envenomation', 'urgency_level': 'Serious', 'audio_key': null},
      {'id': 15, 'slug': 'scorpion_sting', 'title': 'Scorpion Sting', 'category': 'Poisoning & Envenomation', 'urgency_level': 'Life-Threatening', 'audio_key': null},
      {'id': 16, 'slug': 'eye_injury', 'title': 'Eye Injury / Chemical in Eye', 'category': 'Trauma', 'urgency_level': 'Serious', 'audio_key': null},
      {'id': 17, 'slug': 'food_poisoning', 'title': 'Food Poisoning / Gastroenteritis', 'category': 'Poisoning & Envenomation', 'urgency_level': 'Moderate', 'audio_key': null},
      {'id': 18, 'slug': 'head_injury', 'title': 'Head Injury / Concussion', 'category': 'Trauma', 'urgency_level': 'Serious', 'audio_key': null},
      {'id': 19, 'slug': 'unconscious', 'title': 'Unconscious / Unresponsive Person', 'category': 'General Emergency', 'urgency_level': 'Life-Threatening', 'audio_key': null},
      {'id': 20, 'slug': 'asthma_attack', 'title': 'Asthma Attack / Breathing Difficulty', 'category': 'Respiratory Emergency', 'urgency_level': 'Serious', 'audio_key': null},
      {'id': 21, 'slug': 'poisoning', 'title': 'Poisoning / Chemical Ingestion', 'category': 'Poisoning & Envenomation', 'urgency_level': 'Life-Threatening', 'audio_key': null},
      {'id': 22, 'slug': 'spinal_injury', 'title': 'Spinal / Back Injury', 'category': 'Trauma', 'urgency_level': 'Life-Threatening', 'audio_key': null},
      {'id': 23, 'slug': 'nosebleed', 'title': 'Nosebleed (Epistaxis)', 'category': 'Bleeding', 'urgency_level': 'Moderate', 'audio_key': null},
      {'id': 24, 'slug': 'fainting', 'title': 'Fainting / Syncope', 'category': 'General Emergency', 'urgency_level': 'Moderate', 'audio_key': null},
      {'id': 25, 'slug': 'childbirth_emergency', 'title': 'Emergency Childbirth', 'category': 'Obstetric Emergency', 'urgency_level': 'Life-Threatening', 'audio_key': null},
    ];

    final steps = [
      // Snake bite
      {'topic_id': 1, 'step_no': 1, 'type': 'action', 'text_content': 'CALL 108 immediately. Time is critical — anti-venom must be given within hours.'},
      {'topic_id': 1, 'step_no': 2, 'type': 'action', 'text_content': 'Keep the person STILL and CALM. Movement speeds venom spread through lymphatics.'},
      {'topic_id': 1, 'step_no': 3, 'type': 'action', 'text_content': 'Immobilize the bitten limb below heart level using a splint or firm bandage. Do NOT use a tourniquet.'},
      {'topic_id': 1, 'step_no': 4, 'type': 'warning', 'text_content': 'DO NOT cut the wound, suck venom, apply ice, or give alcohol. These are dangerous myths.'},
      {'topic_id': 1, 'step_no': 5, 'type': 'action', 'text_content': 'Remove watches, rings and tight clothing from bitten limb — swelling will occur.'},
      {'topic_id': 1, 'step_no': 6, 'type': 'action', 'text_content': 'Note the time of bite. If safe, remember or photograph the snake (do NOT try to catch it).'},
      {'topic_id': 1, 'step_no': 7, 'type': 'action', 'text_content': 'Transport urgently to nearest government hospital — anti-snake venom (ASV) is available free.'},
      // Burns
      {'topic_id': 2, 'step_no': 1, 'type': 'action', 'text_content': 'COOL the burn immediately with cool (not ice cold) running water for 20 minutes.'},
      {'topic_id': 2, 'step_no': 2, 'type': 'warning', 'text_content': 'DO NOT use ice, butter, toothpaste or oil — these worsen burns and cause infection.'},
      {'topic_id': 2, 'step_no': 3, 'type': 'action', 'text_content': 'Remove clothing and jewellery from burned area UNLESS stuck to skin.'},
      {'topic_id': 2, 'step_no': 4, 'type': 'action', 'text_content': 'Cover burn loosely with clean cling film or a non-fluffy cloth (not cotton wool).'},
      {'topic_id': 2, 'step_no': 5, 'type': 'action', 'text_content': 'Give paracetamol or ibuprofen for pain if the person is conscious.'},
      {'topic_id': 2, 'step_no': 6, 'type': 'warning', 'text_content': 'CALL 108 if: burn is on face/hands/genitals, larger than victim\'s palm, or deep (charred/white).'},
      // Drowning
      {'topic_id': 3, 'step_no': 1, 'type': 'action', 'text_content': 'DO NOT enter water unless trained. Throw a rope, float, or reach with a stick.'},
      {'topic_id': 3, 'step_no': 2, 'type': 'action', 'text_content': 'Once safe, call 108 immediately.'},
      {'topic_id': 3, 'step_no': 3, 'type': 'action', 'text_content': 'If unresponsive and not breathing normally: start CPR — 30 chest compressions + 2 rescue breaths.'},
      {'topic_id': 3, 'step_no': 4, 'type': 'action', 'text_content': 'Continue CPR until breathing returns or emergency services arrive.'},
      {'topic_id': 3, 'step_no': 5, 'type': 'warning', 'text_content': 'DO NOT try to drain water from lungs — this wastes time. Begin CPR immediately.'},
      // Heart Attack
      {'topic_id': 4, 'step_no': 1, 'type': 'action', 'text_content': 'CALL 108 immediately. Tell them you suspect a heart attack.'},
      {'topic_id': 4, 'step_no': 2, 'type': 'action', 'text_content': 'Help the person sit or lie in the most comfortable position (usually half-sitting, knees bent).'},
      {'topic_id': 4, 'step_no': 3, 'type': 'action', 'text_content': 'Give Aspirin 300-325mg to chew (NOT swallow whole) — if available and no allergy.'},
      {'topic_id': 4, 'step_no': 4, 'type': 'action', 'text_content': 'Loosen tight clothing around chest and neck.'},
      {'topic_id': 4, 'step_no': 5, 'type': 'action', 'text_content': 'Stay with the person and keep them calm. Do not let them eat or drink.'},
      {'topic_id': 4, 'step_no': 6, 'type': 'action', 'text_content': 'If unconscious and not breathing: start CPR — 30 compressions + 2 breaths. Repeat.'},
      // Stroke — FAST
      {'topic_id': 5, 'step_no': 1, 'type': 'action', 'text_content': 'Use FAST test: Face drooping? Arm weakness? Speech slurred? Time to call 108!'},
      {'topic_id': 5, 'step_no': 2, 'type': 'action', 'text_content': 'CALL 108 IMMEDIATELY. Stroke treatment (clot-busting) only works within 4.5 hours.'},
      {'topic_id': 5, 'step_no': 3, 'type': 'action', 'text_content': 'Note the exact time symptoms started — tell this to doctors.'},
      {'topic_id': 5, 'step_no': 4, 'type': 'warning', 'text_content': 'DO NOT give food, water, or aspirin — patient may choke. Keep them calm.'},
      {'topic_id': 5, 'step_no': 5, 'type': 'action', 'text_content': 'If unconscious, lay on their side (recovery position) to prevent choking on vomit.'},
      // Choking
      {'topic_id': 8, 'step_no': 1, 'type': 'action', 'text_content': 'Ask "Are you choking?" If they cannot speak, cough or breathe — act immediately.'},
      {'topic_id': 8, 'step_no': 2, 'type': 'action', 'text_content': 'Give 5 back blows: lean them forward, use heel of hand between shoulder blades.'},
      {'topic_id': 8, 'step_no': 3, 'type': 'action', 'text_content': 'Give 5 abdominal thrusts (Heimlich): stand behind, hands just above navel, thrust inward and upward.'},
      {'topic_id': 8, 'step_no': 4, 'type': 'action', 'text_content': 'Alternate 5 back blows and 5 abdominal thrusts until object expelled or unconscious.'},
      {'topic_id': 8, 'step_no': 5, 'type': 'warning', 'text_content': 'For pregnant women or infants: use chest thrusts, NOT abdominal thrusts.'},
      // Seizure
      {'topic_id': 11, 'step_no': 1, 'type': 'action', 'text_content': 'Stay calm. Time the seizure with your phone.'},
      {'topic_id': 11, 'step_no': 2, 'type': 'action', 'text_content': 'Clear the area of hard objects. Cushion the head with something soft.'},
      {'topic_id': 11, 'step_no': 3, 'type': 'warning', 'text_content': 'DO NOT hold the person down or put anything in their mouth — this can cause injury.'},
      {'topic_id': 11, 'step_no': 4, 'type': 'action', 'text_content': 'After shaking stops, roll them gently to their side (recovery position).'},
      {'topic_id': 11, 'step_no': 5, 'type': 'action', 'text_content': 'CALL 108 if: seizure lasts >5 minutes, no recovery of consciousness, or first-ever seizure.'},
      // Heat stroke
      {'topic_id': 10, 'step_no': 1, 'type': 'action', 'text_content': 'Move the person to shade or an air-conditioned space immediately.'},
      {'topic_id': 10, 'step_no': 2, 'type': 'action', 'text_content': 'Cool them rapidly: remove excess clothing, apply cold wet cloths to neck, armpits, groin.'},
      {'topic_id': 10, 'step_no': 3, 'type': 'action', 'text_content': 'Fan them vigorously to increase evaporation.'},
      {'topic_id': 10, 'step_no': 4, 'type': 'action', 'text_content': 'Give cool water or ORS to drink if conscious. Never give alcohol or caffeine.'},
      {'topic_id': 10, 'step_no': 5, 'type': 'action', 'text_content': 'CALL 108. Heat stroke (temperature >40°C, confusion) is a life-threatening emergency.'},
      // Severe bleeding
      {'topic_id': 7, 'step_no': 1, 'type': 'action', 'text_content': 'Apply DIRECT PRESSURE with a clean cloth or bandage. Press firmly.'},
      {'topic_id': 7, 'step_no': 2, 'type': 'action', 'text_content': 'Do NOT remove the cloth if soaked — add more on top.'},
      {'topic_id': 7, 'step_no': 3, 'type': 'action', 'text_content': 'Elevate the injured limb above heart level if possible.'},
      {'topic_id': 7, 'step_no': 4, 'type': 'action', 'text_content': 'Apply a tourniquet if blood loss is severe and limb is involved (2-3 inches above wound). Note time applied.'},
      {'topic_id': 7, 'step_no': 5, 'type': 'action', 'text_content': 'CALL 108. Keep the person warm and lying down to prevent shock.'},
      // Dog bite
      {'topic_id': 14, 'step_no': 1, 'type': 'action', 'text_content': 'Wash the wound thoroughly with soap and running water for 15 minutes. This is the single most important step.'},
      {'topic_id': 14, 'step_no': 2, 'type': 'action', 'text_content': 'Apply antiseptic (povidone iodine or alcohol) after washing.'},
      {'topic_id': 14, 'step_no': 3, 'type': 'action', 'text_content': 'Go to a hospital WITHIN 24 HOURS for anti-rabies vaccination (ARV). First dose must be given early.'},
      {'topic_id': 14, 'step_no': 4, 'type': 'action', 'text_content': 'ARV schedule: Day 0, Day 3, Day 7, Day 14, Day 28. Do not miss any dose.'},
      {'topic_id': 14, 'step_no': 5, 'type': 'warning', 'text_content': 'RABIES IS 100% FATAL once symptoms appear. Take vaccination seriously even for minor bites.'},
      // Emergency Childbirth
      {'topic_id': 25, 'step_no': 1, 'type': 'action', 'text_content': 'CALL 108 immediately. Try to get professional help.'},
      {'topic_id': 25, 'step_no': 2, 'type': 'action', 'text_content': 'Help mother lie on a clean surface. Wash your hands thoroughly.'},
      {'topic_id': 25, 'step_no': 3, 'type': 'action', 'text_content': 'As baby emerges, support the head gently. Do NOT pull or rush.'},
      {'topic_id': 25, 'step_no': 4, 'type': 'action', 'text_content': 'After delivery, clear the baby\'s mouth and nose. The baby should cry within seconds.'},
      {'topic_id': 25, 'step_no': 5, 'type': 'action', 'text_content': 'Place baby on mother\'s chest for warmth. Tie cord in two places and cut only if help is delayed.'},
      {'topic_id': 25, 'step_no': 6, 'type': 'warning', 'text_content': 'NEVER pull the placenta. Let it deliver naturally. Control bleeding with uterine massage.'},
    ];

    final batch = db.batch();
    for (final t in topics) {
      batch.insert('emergency_topics', t, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    for (final s in steps) {
      batch.insert('emergency_steps', s, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }

  // ─────────────────────────────────────────────────────
  // MCH — WHO/IAP Maternal & Child Health Data
  // ─────────────────────────────────────────────────────
  static Future<void> _seedMch(Database db) async {
    // Danger Signs — WHO guidelines
    final dangerSigns = [
      {'stage': 'pregnancy', 'sign_text': 'Heavy vaginal bleeding (soaking more than 1 pad per hour)', 'referral_level': 'Emergency'},
      {'stage': 'pregnancy', 'sign_text': 'Severe headache with vision changes or blurred vision', 'referral_level': 'Emergency'},
      {'stage': 'pregnancy', 'sign_text': 'Severe swelling of face, hands, feet (sudden puffiness)', 'referral_level': 'Emergency'},
      {'stage': 'pregnancy', 'sign_text': 'Convulsions or fits (eclampsia)', 'referral_level': 'Emergency'},
      {'stage': 'pregnancy', 'sign_text': 'Reduced or absent fetal movement after 28 weeks', 'referral_level': 'Emergency'},
      {'stage': 'pregnancy', 'sign_text': 'Severe abdominal pain not relieved by rest', 'referral_level': 'Emergency'},
      {'stage': 'pregnancy', 'sign_text': 'High fever (temperature above 38°C / 100.4°F)', 'referral_level': 'Urgent'},
      {'stage': 'pregnancy', 'sign_text': 'Breathlessness or difficulty breathing at rest', 'referral_level': 'Urgent'},
      {'stage': 'pregnancy', 'sign_text': 'Leaking of water (amniotic fluid) before 37 weeks', 'referral_level': 'Urgent'},
      {'stage': 'pregnancy', 'sign_text': 'Foul-smelling vaginal discharge', 'referral_level': 'Urgent'},
      {'stage': 'postpartum', 'sign_text': 'Excessive postpartum bleeding (PPH — soaking >1 pad/15 min)', 'referral_level': 'Emergency'},
      {'stage': 'postpartum', 'sign_text': 'High fever (>38°C) in first week after delivery', 'referral_level': 'Urgent'},
    ];

    // Vaccines — IAP National Immunization Schedule (India)
    final vaccines = [
      {'code': 'TT-1', 'title': 'Tetanus Toxoid 1st Dose', 'recommended_time': 'As early as possible in pregnancy (1st contact)'},
      {'code': 'TT-2', 'title': 'Tetanus Toxoid 2nd Dose', 'recommended_time': '4 weeks after TT-1 (up to 4 weeks before delivery)'},
      {'code': 'TT-B', 'title': 'Tetanus Toxoid Booster', 'recommended_time': 'If previously vaccinated (within last 3 years) — single booster dose'},
      {'code': 'Flu', 'title': 'Influenza Vaccine', 'recommended_time': 'Any trimester — reduces flu risk for mother and newborn'},
      {'code': 'HepB', 'title': 'Hepatitis B Vaccine', 'recommended_time': 'Before or during pregnancy if not previously vaccinated'},
      {'code': 'Tdap', 'title': 'Tetanus, Diphtheria, Pertussis (Tdap)', 'recommended_time': '27-36 weeks — protects newborn from whooping cough'},
      {'code': 'COVID', 'title': 'COVID-19 Vaccine (Booster)', 'recommended_time': 'As per current MOHFW guidelines — safe in all trimesters'},
      {'code': 'RABIES', 'title': 'Rabies Pre-Exposure Prophylaxis', 'recommended_time': 'If at risk (animal handlers) — before conception preferred'},
    ];

    // Pregnancy weeks — WHO guidelines for each week
    final weeks = [
      {'week_no': 4, 'baby_growth': 'Embryo forms, smaller than a poppy seed. Heart starts beating.', 'mother_changes': 'Missed period. Fatigue, breast tenderness begin. Home pregnancy test positive.', 'diet_tip': 'Start folic acid 400mcg daily immediately to prevent neural tube defects.', 'activity_tip': 'Moderate walking is safe. Avoid heavy lifting.', 'warning_signs': 'Severe cramping or bleeding — consult doctor.'},
      {'week_no': 6, 'baby_growth': 'Facial features forming, heart beating at 100+ bpm. Size of a lentil (6mm).', 'mother_changes': 'Morning sickness may begin. Increased urination. Food aversions.', 'diet_tip': 'Eat small frequent meals to manage nausea. Ginger tea helps.', 'activity_tip': 'Light activity, yoga for pregnancy. Rest when needed.', 'warning_signs': 'Severe vomiting unable to keep fluids down (hyperemesis) — hospital needed.'},
      {'week_no': 8, 'baby_growth': 'All major organs forming. Tiny fingers and toes developing. 1.6 cm long.', 'mother_changes': 'Uterus is now orange-sized. Nausea often peaks. First antenatal visit.', 'diet_tip': 'Iron-rich foods: leafy greens, dal, ragi. Vitamin C helps iron absorption.', 'activity_tip': 'Swimming and prenatal yoga are excellent.', 'warning_signs': 'Any vaginal bleeding, severe pain — emergency visit.'},
      {'week_no': 10, 'baby_growth': 'Now called a fetus. Heartbeat detectable by Doppler. 3 cm, 4 grams.', 'mother_changes': 'Nausea may start improving. Visible veins on breasts.', 'diet_tip': 'Calcium 1200mg/day from milk, curd, paneer, sesame seeds.', 'activity_tip': 'Kegel exercises daily to strengthen pelvic floor.', 'warning_signs': 'Spotting or cramping — contact midwife or doctor.'},
      {'week_no': 12, 'baby_growth': 'All essential organs formed. Fingernails growing. 5-6 cm, 14 grams.', 'mother_changes': 'First trimester ends. Morning sickness usually improves. Nuchal translucency scan.', 'diet_tip': 'Continue folic acid. Add omega-3 from fish, walnuts, flaxseeds.', 'activity_tip': 'Safe to continue most normal activities.', 'warning_signs': 'Nuchal translucency >3.5mm on scan — genetic counselling advised.'},
      {'week_no': 16, 'baby_growth': 'Baby can hear sounds! Eyes sensitive to light. 11-12 cm, 100 grams.', 'mother_changes': 'Baby bump becoming visible. May feel first movements (quickening) — like flutters.', 'diet_tip': 'Increase protein: eggs, dal, pulses, nuts. Goal 75-100g protein/day.', 'activity_tip': 'Moderate walking, swimming, yoga. Avoid lying flat on back.', 'warning_signs': 'No fetal movement by 20 weeks — inform doctor.'},
      {'week_no': 20, 'baby_growth': 'Halfway mark! Baby swallowing amniotic fluid. Vernix coating developing. 25-26 cm, 300 grams.', 'mother_changes': 'Anomaly scan (Level 2 USG) this week. Backache common. Nasal congestion.', 'diet_tip': 'Iron supplementation crucial now. Avoid tea/coffee with iron tablets.', 'activity_tip': 'Prenatal aqua classes excellent. Pelvic tilts for back pain.', 'warning_signs': 'Anomaly scan showing structural defects — genetic counselling needed.'},
      {'week_no': 24, 'baby_growth': 'Lungs developing surfactant. Face fully formed. 30 cm, 600 grams. Viable if born prematurely.', 'mother_changes': 'Glucose tolerance test (GDM screening). Braxton Hicks contractions may begin. Leg cramps common.', 'diet_tip': 'Limit refined sugar and white rice — risk of gestational diabetes. Eat more millets.', 'activity_tip': 'Continue gentle exercise. Avoid contact sports.', 'warning_signs': 'GDM test: fasting >92mg/dL or 2hr >153mg/dL — gestational diabetes management needed.'},
      {'week_no': 28, 'baby_growth': 'Eyes can open and close. Brain developing rapidly. 37 cm, 1 kg. Third trimester begins.', 'mother_changes': 'Fetal kick counts important now. Shortness of breath as uterus pushes diaphragm. Hemorrhoids common.', 'diet_tip': 'High fibre diet for hemorrhoids and constipation. Prune juice, isabgol.', 'activity_tip': 'Avoid lying flat. Sleep on left side — improves placental blood flow.', 'warning_signs': 'Less than 10 kicks in 2 hours — go to hospital for fetal monitoring.'},
      {'week_no': 32, 'baby_growth': 'Baby practicing breathing. Most vital organs mature. 42 cm, 1.7 kg. Gains 200g/week now.', 'mother_changes': 'Frequent urination returns. Nesting instinct. Practice contraction awareness.', 'diet_tip': 'Small frequent meals — stomach space limited. Stay hydrated with 2-3L water.', 'activity_tip': 'Daily walk. Perineal massage from 34 weeks to reduce tearing during birth.', 'warning_signs': 'Regular contractions before 37 weeks = preterm labour — go to hospital immediately.'},
      {'week_no': 36, 'baby_growth': 'Baby "dropping" into pelvis (engagement). All organs ready. 47 cm, 2.6 kg. Weekly antenatal from now.', 'mother_changes': 'Breathing easier (baby dropped). Pelvic pressure increases. Cervix ripening.', 'diet_tip': 'Dates (4-6/day from 36 weeks) — evidence shows shorter labour. Continue iron and calcium.', 'activity_tip': 'Prepare hospital bag. Practice breathing techniques. Walking helps engagement.', 'warning_signs': 'Group B Strep test this week. If positive — IV antibiotics in labour.'},
      {'week_no': 38, 'baby_growth': 'Fully developed. Fine lanugo hair shedding. 49 cm, 3 kg. Baby is ready!', 'mother_changes': 'May feel more contractions (Braxton Hicks). Cervix may be dilating. Mucus plug may discharge.', 'diet_tip': 'Eat light nutritious meals. Stay hydrated for energy in labour.', 'activity_tip': 'Walking, climbing stairs gently. Relaxation techniques.', 'warning_signs': 'Regular contractions every 5 minutes — labour starting. Water breaking — go to hospital.'},
      {'week_no': 40, 'baby_growth': 'Full term! Average 50 cm, 3.3 kg. Ready to meet the world!', 'mother_changes': 'Expected due date. Only 5% of babies born on exact due date — normal range is 38-42 weeks.', 'diet_tip': 'Stay nourished and hydrated. Light snacks during early labour.', 'activity_tip': 'Rest and stay active. Intimacy may help start labour naturally.', 'warning_signs': 'No labour by 41 weeks — induction may be recommended by doctor.'},
    ];

    final batch = db.batch();
    for (final s in dangerSigns) {
      batch.insert('danger_signs', s, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    for (final v in vaccines) {
      batch.insert('maternal_vaccines', v, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    for (final w in weeks) {
      batch.insert('pregnancy_weeks', w, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }

  // ─────────────────────────────────────────────────────
  // DIRECTORY — Karnataka Govt Health Facilities (NHP/MOHFW data)
  // ─────────────────────────────────────────────────────
  static Future<void> _seedDirectory(Database db) async {
    final facilities = [
      {'facility_id': 1, 'facility_name': 'Victoria Hospital (Bowring & Lady Curzon)', 'facility_type': 'District Hospital', 'system_of_medicine': 'Allopathic', 'address': 'K R Market, Bengaluru - 560002', 'phone': '080-26706000', 'working_hours': 'Open 24 Hours', 'is_24x7': 1},
      {'facility_id': 2, 'facility_name': 'Kidwai Memorial Institute of Oncology', 'facility_type': 'Specialty Hospital', 'system_of_medicine': 'Allopathic', 'address': 'Dr M H Marigowda Rd, Bengaluru - 560029', 'phone': '080-26094000', 'working_hours': 'Open 24 Hours', 'is_24x7': 1},
      {'facility_id': 3, 'facility_name': 'NIMHANS (National Institute of Mental Health)', 'facility_type': 'Specialty Hospital', 'system_of_medicine': 'Allopathic', 'address': 'Hosur Rd, Bengaluru - 560029', 'phone': '080-46110007', 'working_hours': 'OPD: 9AM-1PM', 'is_24x7': 1},
      {'facility_id': 4, 'facility_name': 'Indira Gandhi Institute of Child Health', 'facility_type': 'Specialty Hospital', 'system_of_medicine': 'Allopathic', 'address': 'Banashankari 2nd Stage, Bengaluru - 560070', 'phone': '080-26961234', 'working_hours': 'Open 24 Hours', 'is_24x7': 1},
      {'facility_id': 5, 'facility_name': 'ESI Hospital Rajajinagar', 'facility_type': 'ESI Hospital', 'system_of_medicine': 'Allopathic', 'address': '10th Cross, Rajajinagar, Bengaluru - 560010', 'phone': '080-23372222', 'working_hours': 'Open 24 Hours', 'is_24x7': 1},
      {'facility_id': 6, 'facility_name': 'District Hospital Tumkur', 'facility_type': 'District Hospital', 'system_of_medicine': 'Allopathic', 'address': 'Siddhartha Layout, Tumkur - 572101', 'phone': '0816-2272301', 'working_hours': 'Open 24 Hours', 'is_24x7': 1},
      {'facility_id': 7, 'facility_name': 'District Hospital Mysuru', 'facility_type': 'District Hospital', 'system_of_medicine': 'Allopathic', 'address': 'Krishnaraja Blvd, Mysuru - 570001', 'phone': '0821-2520091', 'working_hours': 'Open 24 Hours', 'is_24x7': 1},
      {'facility_id': 8, 'facility_name': 'District Hospital Dharwad', 'facility_type': 'District Hospital', 'system_of_medicine': 'Allopathic', 'address': 'Station Rd, Dharwad - 580001', 'phone': '0836-2447101', 'working_hours': 'Open 24 Hours', 'is_24x7': 1},
      {'facility_id': 9, 'facility_name': 'District Hospital Belagavi (Belgaum)', 'facility_type': 'District Hospital', 'system_of_medicine': 'Allopathic', 'address': 'Khanapur Rd, Belagavi - 590001', 'phone': '0831-2422245', 'working_hours': 'Open 24 Hours', 'is_24x7': 1},
      {'facility_id': 10, 'facility_name': 'CHC Doddaballapur', 'facility_type': 'Community Health Centre', 'system_of_medicine': 'Allopathic', 'address': 'Doddaballapur Town, Bengaluru Rural - 561203', 'phone': '080-27625100', 'working_hours': '8AM-2PM (OPD); 24hr Emergency', 'is_24x7': 0},
      {'facility_id': 11, 'facility_name': 'CHC Channapatna', 'facility_type': 'Community Health Centre', 'system_of_medicine': 'Allopathic', 'address': 'Channapatna, Ramanagara District - 571501', 'phone': '08113-252036', 'working_hours': '8AM-2PM (OPD); 24hr Emergency', 'is_24x7': 0},
      {'facility_id': 12, 'facility_name': 'PHC Hebbal', 'facility_type': 'Primary Health Centre', 'system_of_medicine': 'Allopathic', 'address': 'Hebbal, Bengaluru North - 560024', 'phone': '080-23638100', 'working_hours': '8AM-2PM Mon-Sat', 'is_24x7': 0},
      {'facility_id': 13, 'facility_name': 'PHC Yelahanka', 'facility_type': 'Primary Health Centre', 'system_of_medicine': 'Allopathic', 'address': 'Yelahanka New Town, Bengaluru - 560064', 'phone': '080-28563100', 'working_hours': '8AM-2PM Mon-Sat', 'is_24x7': 0},
      {'facility_id': 14, 'facility_name': 'PHC Devanahalli', 'facility_type': 'Primary Health Centre', 'system_of_medicine': 'Allopathic', 'address': 'Devanahalli Town, Bengaluru Rural - 562110', 'phone': '080-27681200', 'working_hours': '8AM-2PM Mon-Sat', 'is_24x7': 0},
      {'facility_id': 15, 'facility_name': 'PHC Kolar Gold Fields (KGF)', 'facility_type': 'Primary Health Centre', 'system_of_medicine': 'Allopathic', 'address': 'KGF, Kolar District - 563120', 'phone': '08153-272200', 'working_hours': '8AM-2PM Mon-Sat', 'is_24x7': 0},
      {'facility_id': 16, 'facility_name': 'Govt Ayurvedic Hospital Bengaluru', 'facility_type': 'Ayurvedic Hospital', 'system_of_medicine': 'Ayurvedic', 'address': 'Sudama Nagar, Bengaluru - 560011', 'phone': '080-22225001', 'working_hours': '9AM-1PM', 'is_24x7': 0},
      {'facility_id': 17, 'facility_name': 'Govt Unani & Siddha Hospital', 'facility_type': 'AYUSH Hospital', 'system_of_medicine': 'Unani', 'address': 'Shivajinagar, Bengaluru - 560001', 'phone': '080-22281150', 'working_hours': '9AM-1PM', 'is_24x7': 0},
      {'facility_id': 18, 'facility_name': 'SDM College of Ayurveda Hospital', 'facility_type': 'Teaching Hospital', 'system_of_medicine': 'Ayurvedic', 'address': 'Kuthpady, Udupi - 574118', 'phone': '0820-2523700', 'working_hours': '9AM-5PM', 'is_24x7': 0},
      {'facility_id': 19, 'facility_name': 'CHC Anekal', 'facility_type': 'Community Health Centre', 'system_of_medicine': 'Allopathic', 'address': 'Anekal Town, Bengaluru Urban - 562106', 'phone': '080-27843100', 'working_hours': '8AM-2PM; 24hr Emergency', 'is_24x7': 0},
      {'facility_id': 20, 'facility_name': 'PHC Kanakapura', 'facility_type': 'Primary Health Centre', 'system_of_medicine': 'Allopathic', 'address': 'Kanakapura, Ramanagara - 562117', 'phone': '080-27552100', 'working_hours': '8AM-2PM Mon-Sat', 'is_24x7': 0},
      {'facility_id': 21, 'facility_name': 'District Hospital Hassan', 'facility_type': 'District Hospital', 'system_of_medicine': 'Allopathic', 'address': 'B M Rd, Hassan - 573201', 'phone': '08172-268200', 'working_hours': 'Open 24 Hours', 'is_24x7': 1},
      {'facility_id': 22, 'facility_name': 'District Hospital Mangaluru (Wenlock)', 'facility_type': 'District Hospital', 'system_of_medicine': 'Allopathic', 'address': 'Hampankatta, Mangaluru - 575001', 'phone': '0824-2425605', 'working_hours': 'Open 24 Hours', 'is_24x7': 1},
      {'facility_id': 23, 'facility_name': 'CHC Ramanagara', 'facility_type': 'Community Health Centre', 'system_of_medicine': 'Allopathic', 'address': 'Ramanagara Town - 562159', 'phone': '08113-222036', 'working_hours': '8AM-2PM; Emergency 24hr', 'is_24x7': 0},
      {'facility_id': 24, 'facility_name': 'PHC Hosakote', 'facility_type': 'Primary Health Centre', 'system_of_medicine': 'Allopathic', 'address': 'Hosakote, Bengaluru Rural - 562114', 'phone': '080-27971100', 'working_hours': '8AM-2PM Mon-Sat', 'is_24x7': 0},
      {'facility_id': 25, 'facility_name': 'District Hospital Shivamogga', 'facility_type': 'District Hospital', 'system_of_medicine': 'Allopathic', 'address': 'Shivamogga - 577201', 'phone': '08182-228001', 'working_hours': 'Open 24 Hours', 'is_24x7': 1},
    ];

    final batch = db.batch();
    for (final f in facilities) {
      batch.insert('facilities', f, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }

  // ─────────────────────────────────────────────────────
  // NUTRITION — ICMR/NIN Nutritive Value of Indian Foods
  // ─────────────────────────────────────────────────────
  static Future<void> _seedNutrition(Database db) async {
    final foods = [
      // Cereals & Millets
      {'name': 'Rice (Raw, Polished)', 'local_name': 'Chawal / Akki', 'category': 'Cereals & Millets', 'serving_size_g': 100, 'calories': 345.0, 'protein_g': 6.8, 'iron_mg': 0.7, 'calcium_mg': 10.0, 'fibre_g': 0.2, 'fat_g': 0.5, 'carbs_g': 78.2, 'sugar_g': 0.1, 'sodium_mg': 5.0},
      {'name': 'Wheat Flour (Atta, Whole)', 'local_name': 'Gehun ka Atta / Godhi Hittu', 'category': 'Cereals & Millets', 'serving_size_g': 100, 'calories': 341.0, 'protein_g': 11.8, 'iron_mg': 4.9, 'calcium_mg': 41.0, 'fibre_g': 1.9, 'fat_g': 1.7, 'carbs_g': 69.4, 'sugar_g': 0.3, 'sodium_mg': 2.0},
      {'name': 'Ragi (Finger Millet)', 'local_name': 'Nachni / Kelvaragu / Ragi', 'category': 'Cereals & Millets', 'serving_size_g': 100, 'calories': 328.0, 'protein_g': 7.3, 'iron_mg': 3.9, 'calcium_mg': 344.0, 'fibre_g': 3.6, 'fat_g': 1.3, 'carbs_g': 72.0, 'sugar_g': 1.4, 'sodium_mg': 11.0},
      {'name': 'Jowar (Sorghum)', 'local_name': 'Jowar / Jola', 'category': 'Cereals & Millets', 'serving_size_g': 100, 'calories': 349.0, 'protein_g': 10.4, 'iron_mg': 4.1, 'calcium_mg': 25.0, 'fibre_g': 1.6, 'fat_g': 1.9, 'carbs_g': 72.6, 'sugar_g': 0.5, 'sodium_mg': 6.0},
      {'name': 'Bajra (Pearl Millet)', 'local_name': 'Bajri / Sajjalu', 'category': 'Cereals & Millets', 'serving_size_g': 100, 'calories': 361.0, 'protein_g': 11.6, 'iron_mg': 8.0, 'calcium_mg': 42.0, 'fibre_g': 1.2, 'fat_g': 5.0, 'carbs_g': 67.5, 'sugar_g': 0.4, 'sodium_mg': 10.0},
      {'name': 'Maize (Corn)', 'local_name': 'Makka / Bhutta / Makkajola', 'category': 'Cereals & Millets', 'serving_size_g': 100, 'calories': 342.0, 'protein_g': 8.8, 'iron_mg': 2.3, 'calcium_mg': 9.0, 'fibre_g': 2.7, 'fat_g': 3.6, 'carbs_g': 65.9, 'sugar_g': 0.8, 'sodium_mg': 7.0},
      {'name': 'Oats (Rolled)', 'local_name': 'Oats / Jai', 'category': 'Cereals & Millets', 'serving_size_g': 100, 'calories': 379.0, 'protein_g': 13.2, 'iron_mg': 4.7, 'calcium_mg': 54.0, 'fibre_g': 10.6, 'fat_g': 6.9, 'carbs_g': 67.7, 'sugar_g': 1.1, 'sodium_mg': 2.0},
      // Pulses & Legumes
      {'name': 'Red Lentil (Masoor Dal)', 'local_name': 'Masoor Dal / Kempu Togari', 'category': 'Pulses & Legumes', 'serving_size_g': 100, 'calories': 343.0, 'protein_g': 25.1, 'iron_mg': 7.6, 'calcium_mg': 68.0, 'fibre_g': 3.7, 'fat_g': 0.7, 'carbs_g': 59.0, 'sugar_g': 2.0, 'sodium_mg': 6.0},
      {'name': 'Bengal Gram (Chana Dal)', 'local_name': 'Chana Dal / Kadale Bele', 'category': 'Pulses & Legumes', 'serving_size_g': 100, 'calories': 369.0, 'protein_g': 20.8, 'iron_mg': 5.3, 'calcium_mg': 56.0, 'fibre_g': 1.2, 'fat_g': 5.6, 'carbs_g': 59.8, 'sugar_g': 6.2, 'sodium_mg': 30.0},
      {'name': 'Black Gram (Urad Dal)', 'local_name': 'Urad Dal / Uddin Bele', 'category': 'Pulses & Legumes', 'serving_size_g': 100, 'calories': 347.0, 'protein_g': 24.0, 'iron_mg': 9.1, 'calcium_mg': 138.0, 'fibre_g': 0.9, 'fat_g': 1.4, 'carbs_g': 59.6, 'sugar_g': 1.5, 'sodium_mg': 30.0},
      {'name': 'Green Gram (Moong Dal)', 'local_name': 'Moong Dal / Hesaru Bele', 'category': 'Pulses & Legumes', 'serving_size_g': 100, 'calories': 334.0, 'protein_g': 24.5, 'iron_mg': 8.5, 'calcium_mg': 124.0, 'fibre_g': 4.1, 'fat_g': 1.2, 'carbs_g': 56.7, 'sugar_g': 5.5, 'sodium_mg': 28.0},
      {'name': 'Pigeon Pea (Toor Dal)', 'local_name': 'Toor Dal / Togari Bele', 'category': 'Pulses & Legumes', 'serving_size_g': 100, 'calories': 335.0, 'protein_g': 22.3, 'iron_mg': 5.4, 'calcium_mg': 73.0, 'fibre_g': 1.5, 'fat_g': 1.7, 'carbs_g': 57.6, 'sugar_g': 4.0, 'sodium_mg': 16.0},
      {'name': 'Soyabean', 'local_name': 'Soya / Bhat', 'category': 'Pulses & Legumes', 'serving_size_g': 100, 'calories': 432.0, 'protein_g': 43.2, 'iron_mg': 11.5, 'calcium_mg': 240.0, 'fibre_g': 3.7, 'fat_g': 19.5, 'carbs_g': 20.9, 'sugar_g': 7.3, 'sodium_mg': 2.0},
      {'name': 'Chickpea (Kabuli Chana)', 'local_name': 'Chole / Kadale', 'category': 'Pulses & Legumes', 'serving_size_g': 100, 'calories': 360.0, 'protein_g': 17.1, 'iron_mg': 4.6, 'calcium_mg': 202.0, 'fibre_g': 5.3, 'fat_g': 5.3, 'carbs_g': 60.9, 'sugar_g': 10.7, 'sodium_mg': 24.0},
      // Vegetables
      {'name': 'Spinach (Fresh)', 'local_name': 'Palak / Basale', 'category': 'Green Leafy Vegetables', 'serving_size_g': 100, 'calories': 26.0, 'protein_g': 2.0, 'iron_mg': 1.1, 'calcium_mg': 73.0, 'fibre_g': 0.6, 'fat_g': 0.4, 'carbs_g': 3.6, 'sugar_g': 0.4, 'sodium_mg': 65.0},
      {'name': 'Fenugreek Leaves (Methi)', 'local_name': 'Methi / Menthya Soppu', 'category': 'Green Leafy Vegetables', 'serving_size_g': 100, 'calories': 49.0, 'protein_g': 4.4, 'iron_mg': 1.9, 'calcium_mg': 395.0, 'fibre_g': 1.1, 'fat_g': 0.9, 'carbs_g': 6.0, 'sugar_g': 0.3, 'sodium_mg': 67.0},
      {'name': 'Drumstick Leaves (Moringa)', 'local_name': 'Murungai Keerai / Nugge Soppu', 'category': 'Green Leafy Vegetables', 'serving_size_g': 100, 'calories': 92.0, 'protein_g': 6.7, 'iron_mg': 0.85, 'calcium_mg': 185.0, 'fibre_g': 2.0, 'fat_g': 1.7, 'carbs_g': 8.3, 'sugar_g': 2.0, 'sodium_mg': 9.0},
      {'name': 'Amaranth Leaves (Rajgira)', 'local_name': 'Rajgira Bhaji / Harive Soppu', 'category': 'Green Leafy Vegetables', 'serving_size_g': 100, 'calories': 45.0, 'protein_g': 4.0, 'iron_mg': 25.5, 'calcium_mg': 800.0, 'fibre_g': 1.0, 'fat_g': 0.5, 'carbs_g': 6.1, 'sugar_g': 0.5, 'sodium_mg': 40.0},
      {'name': 'Tomato (Fresh)', 'local_name': 'Tamatar / Tomato', 'category': 'Vegetables', 'serving_size_g': 100, 'calories': 20.0, 'protein_g': 0.9, 'iron_mg': 0.4, 'calcium_mg': 20.0, 'fibre_g': 0.8, 'fat_g': 0.2, 'carbs_g': 3.6, 'sugar_g': 2.6, 'sodium_mg': 5.0},
      {'name': 'Carrot (Fresh)', 'local_name': 'Gajar / Carrot', 'category': 'Vegetables', 'serving_size_g': 100, 'calories': 48.0, 'protein_g': 0.9, 'iron_mg': 1.03, 'calcium_mg': 27.0, 'fibre_g': 2.8, 'fat_g': 0.2, 'carbs_g': 10.6, 'sugar_g': 4.7, 'sodium_mg': 69.0},
      {'name': 'Sweet Potato', 'local_name': 'Shakarkandi / Genasina Gedde', 'category': 'Vegetables', 'serving_size_g': 100, 'calories': 86.0, 'protein_g': 1.6, 'iron_mg': 0.6, 'calcium_mg': 30.0, 'fibre_g': 3.0, 'fat_g': 0.1, 'carbs_g': 20.1, 'sugar_g': 4.2, 'sodium_mg': 55.0},
      {'name': 'Onion (Fresh)', 'local_name': 'Pyaaz / Eerulli', 'category': 'Vegetables', 'serving_size_g': 100, 'calories': 40.0, 'protein_g': 1.2, 'iron_mg': 0.2, 'calcium_mg': 36.0, 'fibre_g': 0.6, 'fat_g': 0.1, 'carbs_g': 8.2, 'sugar_g': 4.2, 'sodium_mg': 4.0},
      // Fruits
      {'name': 'Banana (Ripe)', 'local_name': 'Kela / Bale Hannu', 'category': 'Fruits', 'serving_size_g': 100, 'calories': 116.0, 'protein_g': 1.2, 'iron_mg': 0.4, 'calcium_mg': 17.0, 'fibre_g': 0.4, 'fat_g': 0.3, 'carbs_g': 27.2, 'sugar_g': 14.4, 'sodium_mg': 1.0},
      {'name': 'Papaya (Ripe)', 'local_name': 'Papita / Papayi Hannu', 'category': 'Fruits', 'serving_size_g': 100, 'calories': 32.0, 'protein_g': 0.6, 'iron_mg': 0.5, 'calcium_mg': 17.0, 'fibre_g': 0.8, 'fat_g': 0.1, 'carbs_g': 7.2, 'sugar_g': 5.9, 'sodium_mg': 3.0},
      {'name': 'Mango (Ripe, Alphonso)', 'local_name': 'Aam / Maavin Hannu', 'category': 'Fruits', 'serving_size_g': 100, 'calories': 74.0, 'protein_g': 0.6, 'iron_mg': 1.3, 'calcium_mg': 14.0, 'fibre_g': 0.7, 'fat_g': 0.4, 'carbs_g': 16.9, 'sugar_g': 14.8, 'sodium_mg': 2.0},
      {'name': 'Guava (Fresh)', 'local_name': 'Amrud / Seebe Hannu', 'category': 'Fruits', 'serving_size_g': 100, 'calories': 51.0, 'protein_g': 0.9, 'iron_mg': 0.3, 'calcium_mg': 10.0, 'fibre_g': 5.4, 'fat_g': 0.4, 'carbs_g': 11.2, 'sugar_g': 8.9, 'sodium_mg': 2.0},
      {'name': 'Orange (Nagpur)', 'local_name': 'Santra / Kittale', 'category': 'Fruits', 'serving_size_g': 100, 'calories': 53.0, 'protein_g': 0.8, 'iron_mg': 0.1, 'calcium_mg': 40.0, 'fibre_g': 2.4, 'fat_g': 0.3, 'carbs_g': 11.5, 'sugar_g': 9.4, 'sodium_mg': 0.0},
      {'name': 'Amla (Indian Gooseberry)', 'local_name': 'Amla / Nellikai', 'category': 'Fruits', 'serving_size_g': 100, 'calories': 44.0, 'protein_g': 0.9, 'iron_mg': 1.2, 'calcium_mg': 50.0, 'fibre_g': 3.4, 'fat_g': 0.1, 'carbs_g': 10.2, 'sugar_g': 8.5, 'sodium_mg': 1.0},
      // Dairy & Protein
      {'name': 'Cow Milk (Full Fat)', 'local_name': 'Doodh / Halu', 'category': 'Dairy & Eggs', 'serving_size_g': 100, 'calories': 67.0, 'protein_g': 3.2, 'iron_mg': 0.2, 'calcium_mg': 120.0, 'fibre_g': 0.0, 'fat_g': 4.1, 'carbs_g': 4.8, 'sugar_g': 4.7, 'sodium_mg': 50.0},
      {'name': 'Curd / Yogurt (Plain)', 'local_name': 'Dahi / Mosaru', 'category': 'Dairy & Eggs', 'serving_size_g': 100, 'calories': 98.0, 'protein_g': 11.0, 'iron_mg': 0.2, 'calcium_mg': 149.0, 'fibre_g': 0.0, 'fat_g': 5.0, 'carbs_g': 4.6, 'sugar_g': 4.6, 'sodium_mg': 364.0},
      {'name': 'Chicken Egg (Boiled)', 'local_name': 'Anda / Motte', 'category': 'Dairy & Eggs', 'serving_size_g': 100, 'calories': 173.0, 'protein_g': 13.3, 'iron_mg': 2.1, 'calcium_mg': 60.0, 'fibre_g': 0.0, 'fat_g': 13.3, 'carbs_g': 0.8, 'sugar_g': 0.6, 'sodium_mg': 142.0},
      {'name': 'Groundnut (Peanut, Roasted)', 'local_name': 'Moongphali / Kadlekai', 'category': 'Nuts & Seeds', 'serving_size_g': 100, 'calories': 567.0, 'protein_g': 25.8, 'iron_mg': 4.6, 'calcium_mg': 92.0, 'fibre_g': 8.5, 'fat_g': 49.2, 'carbs_g': 16.1, 'sugar_g': 4.7, 'sodium_mg': 18.0},
      {'name': 'Sesame Seeds (Til)', 'local_name': 'Til / Ellu', 'category': 'Nuts & Seeds', 'serving_size_g': 100, 'calories': 573.0, 'protein_g': 17.7, 'iron_mg': 14.6, 'calcium_mg': 975.0, 'fibre_g': 11.8, 'fat_g': 49.7, 'carbs_g': 23.5, 'sugar_g': 0.3, 'sodium_mg': 11.0},
      {'name': 'Jaggery (Gur)', 'local_name': 'Gur / Bella', 'category': 'Sweeteners', 'serving_size_g': 100, 'calories': 383.0, 'protein_g': 0.4, 'iron_mg': 11.4, 'calcium_mg': 80.0, 'fibre_g': 0.0, 'fat_g': 0.1, 'carbs_g': 95.0, 'sugar_g': 65.0, 'sodium_mg': 30.0},
      {'name': 'Coconut (Fresh, Grated)', 'local_name': 'Nariyal / Thengina Kai', 'category': 'Nuts & Seeds', 'serving_size_g': 100, 'calories': 354.0, 'protein_g': 3.3, 'iron_mg': 2.4, 'calcium_mg': 13.0, 'fibre_g': 9.0, 'fat_g': 33.5, 'carbs_g': 9.4, 'sugar_g': 6.2, 'sodium_mg': 20.0},
      {'name': 'Fish (Rohu, Raw)', 'local_name': 'Rohu Machli / Rohu Meen', 'category': 'Non-Veg', 'serving_size_g': 100, 'calories': 97.0, 'protein_g': 16.6, 'iron_mg': 1.0, 'calcium_mg': 650.0, 'fibre_g': 0.0, 'fat_g': 2.8, 'carbs_g': 0.0, 'sugar_g': 0.0, 'sodium_mg': 65.0},
    ];

    final batch = db.batch();
    for (final f in foods) {
      batch.insert('foods', f, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }
}
