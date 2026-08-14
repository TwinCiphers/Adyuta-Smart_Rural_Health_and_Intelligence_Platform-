import 'package:flutter/foundation.dart';
import '../../features/directory/models/facility.dart';
import '../../features/pharmacy/models/medicine.dart';
import '../db/database_helper.dart';
import '../network/network_service.dart';
import '../network/api_service.dart';
import 'package:sqflite/sqflite.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final NetworkService _networkService = NetworkService();
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> performSync() async {
    await _initAllLocalDatabases();
    bool isOnline = await _networkService.isOnline();
    if (!isOnline) {
      debugPrint('SyncService: Device is offline — using local seeded data.');
      return;
    }

    debugPrint('SyncService: Online — starting background sync...');
    try {
      await _syncFacilities();
      await _syncMedicines();
      debugPrint('SyncService: Background sync completed successfully.');
    } catch (e) {
      debugPrint('SyncService: Sync failed (local data still available): $e');
    }
  }

  Future<void> _syncFacilities() async {
    final facilities = await _apiService.fetchFacilities();
    if (facilities.isEmpty) {
      debugPrint('SyncService: No facilities from API — keeping local seeded data.');
      return;
    }
    final db = await _dbHelper.getDatabase('directory.db');
    await db.transaction((txn) async {
      for (var facility in facilities) {
        // INSERT OR REPLACE — never deletes seeded data; just updates/adds API records
        await txn.insert(
          'facilities',
          facility.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
    debugPrint('SyncService: Synced ${facilities.length} facilities from live API.');
  }

  Future<void> _syncMedicines() async {
    final medicines = await _apiService.fetchMedicines();
    if (medicines.isEmpty) {
      debugPrint('SyncService: No medicines from API — keeping local seeded data.');
      return;
    }
    final db = await _dbHelper.getDatabase('medicines.db');
    await db.transaction((txn) async {
      for (var medicine in medicines) {
        await txn.insert(
          'medicines',
          medicine.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
    debugPrint('SyncService: Synced ${medicines.length} medicines from live API.');
  }

  Future<void> _initAllLocalDatabases() async {
    debugPrint('SyncService: Pre-initializing all 6 health module databases...');
    try {
      await _dbHelper.getDatabase('medicines.db');
      await _dbHelper.getDatabase('firstaid.db');
      await _dbHelper.getDatabase('mch.db');
      await _dbHelper.getDatabase('directory.db');
      await _dbHelper.getDatabase('nutrition.db');
      await _dbHelper.getDatabase('phr.db');
      debugPrint('SyncService: All 6 databases pre-initialized and verified.');
    } catch (e) {
      debugPrint('SyncService: Error pre-initializing databases: $e');
    }
  }
}
