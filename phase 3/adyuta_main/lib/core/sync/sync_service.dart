import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class SyncableDatabase {
  Future<List<Map<String, dynamic>>> getUnsyncedRecords(String tableName);
  Future<void> markAsSynced(String tableName, int id);
}

class SupabaseSyncService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final SyncableDatabase _localDb;
  
  SupabaseSyncService(this._localDb);

  Future<void> syncTable(String tableName) async {
    // 1. Check Connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print('Offline: Skipping sync for $tableName');
      return;
    }

    // 2. Fetch Unsynced Records from Drift
    final unsyncedRecords = await _localDb.getUnsyncedRecords(tableName);
    if (unsyncedRecords.isEmpty) {
      print('No pending records to sync for $tableName');
      return;
    }

    // 3. Upload to Supabase
    for (final record in unsyncedRecords) {
      try {
        // Upsert record to Supabase
        await _supabase.from(tableName).upsert(record);
        
        // 4. Mark as synced locally
        await _localDb.markAsSynced(tableName, record['id']);
      } catch (e) {
        print('Error syncing record ${record['id']}: $e');
      }
    }
  }

  // Download new changes from server (Pull)
  Future<void> pullChanges(String tableName, DateTime lastSyncTime) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .gte('last_updated_at', lastSyncTime.toIso8601String());
          
      final List<dynamic> data = response as List<dynamic>;
      // TODO: Pass data to LocalDB to merge and update records
    } catch (e) {
      print('Error pulling changes for $tableName: $e');
    }
  }
}
