import 'package:health_module/core/db/database_helper.dart';
import '../models/facility.dart';

class DirectoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Facility>> searchFacilities(String query) async {
    try {
      final db = await _dbHelper.getDatabase('directory.db');
      final maps = await db.query(
        'facilities',
        where: 'facility_name LIKE ? OR address LIKE ? OR facility_type LIKE ?',
        whereArgs: ['%$query%', '%$query%', '%$query%'],
        limit: 20,
      );
      return maps.map((map) => Facility.fromMap(map)).toList();
    } catch (_) { return []; }
  }

  Future<List<Facility>> getNearbyFacilities() async {
    final db = await _dbHelper.getDatabase('directory.db');
    final maps = await db.query('facilities', limit: 15);
    return maps.map((map) => Facility.fromMap(map)).toList();
  }

  Future<List<LocalHelper>> getLocalHelpers() async {
    try {
      final db = await _dbHelper.getDatabase('directory.db');
      final maps = await db.query('local_helpers', limit: 15);
      return maps.map((map) => LocalHelper.fromMap(map)).toList();
    } catch (_) { return []; }
  }
}
