import 'package:health_module/core/db/database_helper.dart';
import '../models/pregnancy_week.dart';

class MchRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<PregnancyWeek>> getPregnancyWeeks() async {
    try {
      final db = await _dbHelper.getDatabase('mch.db');
      final maps = await db.query('pregnancy_weeks', orderBy: 'week_no ASC');
      return maps.map((m) => PregnancyWeek.fromMap(m)).toList();
    } catch (_) { return []; }
  }
  
  Future<List<MaternalVaccine>> getMaternalVaccines() async {
    try {
      final db = await _dbHelper.getDatabase('mch.db');
      final maps = await db.query('maternal_vaccines');
      return maps.map((m) => MaternalVaccine.fromMap(m)).toList();
    } catch (_) { return []; }
  }

  Future<List<DangerSign>> getDangerSigns() async {
    try {
      final db = await _dbHelper.getDatabase('mch.db');
      final maps = await db.query('danger_signs', where: 'stage = ?', whereArgs: ['pregnancy']);
      return maps.map((m) => DangerSign.fromMap(m)).toList();
    } catch (_) { return []; }
  }
}
