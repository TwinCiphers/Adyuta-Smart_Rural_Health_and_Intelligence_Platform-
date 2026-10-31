import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:health_module/core/db/database_helper.dart';
import '../models/medicine.dart';

class PharmacyRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Helper to fetch live data from OpenFDA
  Future<List<Medicine>> _fetchLiveFdaData(String query) async {
    try {
      final url = Uri.parse('https://api.fda.gov/drug/label.json?search=openfda.generic_name:"$query"+openfda.brand_name:"$query"&limit=10');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        
        return results.map((r) {
          final openfda = r['openfda'] ?? {};
          final brandName = (openfda['brand_name'] as List?)?.first ?? 'Unknown Brand';
          final genericName = (openfda['generic_name'] as List?)?.first ?? 'Unknown Generic';
          final manufacturer = (openfda['manufacturer_name'] as List?)?.first ?? 'Unknown Mfr';
          
          final indications = (r['indications_and_usage'] as List?)?.first ?? 'General Use';
          final warnings = (r['warnings'] as List?)?.first ?? 'See packaging.';
          final dosage = (r['dosage_and_administration'] as List?)?.first ?? 'Consult physician.';
          
          return Medicine(
            id: DateTime.now().millisecondsSinceEpoch,
            system: 'Allopathic (FDA)',
            brandName: brandName,
            genericName: genericName,
            uses: indications,
            dosageAndForm: dosage,
            warningsAndContraindications: warnings,
            manufacturerApproval: manufacturer,
            sourceRef: 'US FDA Database',
            purchaseLinks: [
               PurchaseLink(id: 0, platform: '1mg (External)', url: 'https://www.1mg.com/search/all?name=$brandName'),
               PurchaseLink(id: 0, platform: 'PharmEasy', url: 'https://pharmeasy.in/search/all?name=$brandName')
            ]
          );
        }).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<Medicine>> searchMedicines(String query) async {
    if (query.isEmpty) return [];
    
    // First try live real-time API
    final liveData = await _fetchLiveFdaData(query);
    if (liveData.isNotEmpty) return liveData;

    // Fallback to local DB
    final db = await _dbHelper.getDatabase('medicines.db');
    final maps = await db.rawQuery('''
      SELECT m.*
      FROM medicines m
      WHERE m.brand_name LIKE ? OR m.generic_name LIKE ? OR m.uses LIKE ?
      LIMIT 20
    ''', ['%$query%', '%$query%', '%$query%']);
    
    return _parseMedicinesWithLinks(maps);
  }

  Future<List<Medicine>> getTopMedicines({int limit = 10}) async {
    final db = await _dbHelper.getDatabase('medicines.db');
    final maps = await db.rawQuery('SELECT m.* FROM medicines m LIMIT ?', [limit]);
    return _parseMedicinesWithLinks(maps);
  }

  Future<List<Medicine>> getAllMedicines() async {
    final db = await _dbHelper.getDatabase('medicines.db');
    final maps = await db.rawQuery('SELECT * FROM medicines');
    return _parseMedicinesWithLinks(maps);
  }
  
  Future<List<Medicine>> _parseMedicinesWithLinks(List<Map<String, dynamic>> maps) async {
    final db = await _dbHelper.getDatabase('medicines.db');
    List<Medicine> medicines = [];
    
    for (var map in maps) {
      int id = map['id'];
      List<PurchaseLink> links = [];
      try {
        final linkMaps = await db.query('purchase_links', where: 'medicine_id = ?', whereArgs: [id]);
        links = linkMaps.map((m) => PurchaseLink.fromMap(m)).toList();
      } catch (_) {}
      medicines.add(Medicine.fromMap(map, links: links));
    }
    return medicines;
  }
}
