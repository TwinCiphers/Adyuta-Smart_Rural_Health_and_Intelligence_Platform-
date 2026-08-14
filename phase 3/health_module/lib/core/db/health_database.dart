import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'health_database.g.dart';

// Sync Status Enum for all synced records
enum SyncStatus { pending, synced, error }

// Table: Profiles (PHR)
class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get relation => text().nullable()();
  TextColumn get bloodGroup => text().nullable()();
  
  // Sync metadata
  TextColumn get syncStatus => text().map(const SyncStatusConverter()).withDefault(const Constant('pending'))();
  DateTimeColumn get lastUpdatedAt => dateTime().withDefault(currentDateAndTime)();
}

// Table: Vitals (PHR)
class Vitals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get date => text()();
  IntColumn get systolic => integer().nullable()();
  IntColumn get diastolic => integer().nullable()();
  IntColumn get sugarLevel => integer().nullable()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();

  // Sync metadata
  TextColumn get syncStatus => text().map(const SyncStatusConverter()).withDefault(const Constant('pending'))();
  DateTimeColumn get lastUpdatedAt => dateTime().withDefault(currentDateAndTime)();
}

// Converter for SyncStatus
class SyncStatusConverter extends TypeConverter<SyncStatus, String> {
  const SyncStatusConverter();

  @override
  SyncStatus fromSql(String fromDb) {
    return SyncStatus.values.firstWhere((e) => e.name == fromDb, orElse: () => SyncStatus.pending);
  }

  @override
  String toSql(SyncStatus value) {
    return value.name;
  }
}

@DriftDatabase(tables: [Profiles, Vitals])
class HealthDatabase extends _$HealthDatabase {
  HealthDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Insert a profile
  Future<int> insertProfile(ProfilesCompanion profile) => into(profiles).insert(profile);
  
  // Get all profiles
  Future<List<Profile>> getAllProfiles() => select(profiles).get();

  // Get unsynced profiles
  Future<List<Profile>> getUnsyncedProfiles() => 
      (select(profiles)..where((t) => t.syncStatus.equals(SyncStatus.pending.name))).get();

  // Update sync status
  Future<void> updateProfileSyncStatus(int id, SyncStatus status) {
    return (update(profiles)..where((t) => t.id.equals(id))).write(
      ProfilesCompanion(
        syncStatus: Value(status),
        lastUpdatedAt: Value(DateTime.now()),
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'health_phr.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
