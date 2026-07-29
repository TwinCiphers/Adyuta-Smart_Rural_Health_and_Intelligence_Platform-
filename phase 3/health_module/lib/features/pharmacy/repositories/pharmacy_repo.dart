import 'package:health_module/core/db/database_helper.dart';
import '../models/medicine.dart';

class PharmacyRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Medicine>> getTopMedicines({int limit = 10}) async {
    final db = await _dbHelper.getDatabase('medicines.db');
    
    final maps = await db.rawQuery('''
      SELECT m.*
      FROM medicines m
      LIMIT ?
    ''', [limit]);
    
    return _parseMedicinesWithLinks(maps);
  }

  Future<List<Medicine>> getAllMedicines() async {
    final db = await _dbHelper.getDatabase('medicines.db');
    final maps = await db.rawQuery('SELECT * FROM medicines');
    return _parseMedicinesWithLinks(maps);
  }

  Future<List<Medicine>> searchMedicines(String query) async {
    final db = await _dbHelper.getDatabase('medicines.db');
    final maps = await db.rawQuery('''
      SELECT m.*
      FROM medicines m
      WHERE m.brand_name LIKE ? OR m.generic_name LIKE ? OR m.uses LIKE ?
      LIMIT 20
    ''', ['%$query%', '%$query%', '%$query%']);
    
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
