import 'package:health_module/core/db/database_helper.dart';

class PhrRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Profiles
  Future<List<Map<String, dynamic>>> getProfiles() async {
    try {
      final db = await _dbHelper.getDatabase('phr.db');
      return await db.query('profiles', orderBy: 'id ASC');
    } catch (_) { return []; }
  }

  Future<void> addProfile(Map<String, dynamic> profileData) async {
    final db = await _dbHelper.getDatabase('phr.db');
    await db.insert('profiles', profileData);
  }

  // Conditions
  Future<List<Map<String, dynamic>>> getConditions(int profileId) async {
    try {
      final db = await _dbHelper.getDatabase('phr.db');
      return await db.query('conditions', where: 'profile_id = ?', whereArgs: [profileId]);
    } catch (_) { return []; }
  }

  Future<void> addCondition(Map<String, dynamic> data) async {
    final db = await _dbHelper.getDatabase('phr.db');
    await db.insert('conditions', data);
  }

  // Vitals
  Future<List<Map<String, dynamic>>> getVitals(int profileId) async {
    try {
      final db = await _dbHelper.getDatabase('phr.db');
      return await db.query('vitals', where: 'profile_id = ?', whereArgs: [profileId], orderBy: 'timestamp DESC');
    } catch (_) { return []; }
  }

  Future<void> addVitals(Map<String, dynamic> data) async {
    final db = await _dbHelper.getDatabase('phr.db');
    await db.insert('vitals', data);
  }

  // Medicines
  Future<List<Map<String, dynamic>>> getMedicines(int profileId) async {
    try {
      final db = await _dbHelper.getDatabase('phr.db');
      return await db.query('medicines', where: 'profile_id = ?', whereArgs: [profileId]);
    } catch (_) { return []; }
  }

  Future<void> addMedicine(Map<String, dynamic> data) async {
    final db = await _dbHelper.getDatabase('phr.db');
    await db.insert('medicines', data);
  }

  // Visits
  Future<List<Map<String, dynamic>>> getVisits(int profileId) async {
    try {
      final db = await _dbHelper.getDatabase('phr.db');
      return await db.query('visits', where: 'profile_id = ?', whereArgs: [profileId], orderBy: 'visit_date DESC');
    } catch (_) { return []; }
  }

  Future<void> addVisit(Map<String, dynamic> data) async {
    final db = await _dbHelper.getDatabase('phr.db');
    await db.insert('visits', data);
  }
}
