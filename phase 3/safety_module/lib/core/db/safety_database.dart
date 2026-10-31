import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'safety_database.g.dart';

enum SyncStatus { pending, synced, error }

class SyncStatusConverter extends TypeConverter<SyncStatus, String> {
  const SyncStatusConverter();
  @override
  SyncStatus fromSql(String fromDb) => SyncStatus.values.firstWhere((e) => e.name == fromDb, orElse: () => SyncStatus.pending);
  @override
  String toSql(SyncStatus value) => value.name;
}

// Table: Incidents
class Incidents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()();
  TextColumn get description => text().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  
  TextColumn get syncStatus => text().map(const SyncStatusConverter()).withDefault(const Constant('pending'))();
  DateTimeColumn get lastUpdatedAt => dateTime().withDefault(currentDateAndTime)();
}

// Table: Broadcasts — stores alerts from USGS, NDMA SACHET, OpenAQ and any local admin alerts.
class Broadcasts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get message => text()();
  TextColumn get severity => text()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();

  /// The data source that produced this alert (e.g. 'USGS', 'NDMA SACHET', 'OpenAQ', 'local')
  TextColumn get source => text().withDefault(const Constant('local'))();

  /// The canonical URL for this alert on the originating source website.
  TextColumn get sourceUrl => text().withDefault(const Constant(''))();

  /// When the event was actually observed/reported by the originating source (Unix ms).
  /// Stored as INTEGER milliseconds so we can sort without timezone ambiguity.
  IntColumn get observedAt => integer().withDefault(const Constant(0))();

  /// Geographic coordinates of the event (0.0 if not applicable / unknown).
  RealColumn get latitude => real().withDefault(const Constant(0.0))();
  RealColumn get longitude => real().withDefault(const Constant(0.0))();

  TextColumn get syncStatus => text().map(const SyncStatusConverter()).withDefault(const Constant('pending'))();
  DateTimeColumn get lastUpdatedAt => dateTime().withDefault(currentDateAndTime)();
}

// Table: Emergency Contacts
class EmergencyContacts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phoneNumber => text()();
  TextColumn get relation => text().nullable()();

  TextColumn get syncStatus => text().map(const SyncStatusConverter()).withDefault(const Constant('pending'))();
  DateTimeColumn get lastUpdatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Helplines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get number => text()();
  TextColumn get description => text().nullable()();
  TextColumn get type => text()();
  IntColumn get updatedAt => integer()();
  TextColumn get source => text()();
}

class SafetyGuides extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get category => text()();
  IntColumn get updatedAt => integer()();
  TextColumn get source => text()();
}

@DriftDatabase(tables: [Incidents, Broadcasts, EmergencyContacts, Helplines, SafetyGuides])
class SafetyDatabase extends _$SafetyDatabase {
  static final SafetyDatabase instance = SafetyDatabase._internal();
  SafetyDatabase._internal() : super(_openConnection());
  SafetyDatabase() : super(_openConnection()); // Deprecated, use instance
  SafetyDatabase.forTesting(QueryExecutor e) : super(e);
  @override
  int get schemaVersion => 2;

  /// Migrate from v1 → v2: add new columns to Broadcasts table.
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(broadcasts, broadcasts.source);
        await migrator.addColumn(broadcasts, broadcasts.sourceUrl);
        await migrator.addColumn(broadcasts, broadcasts.observedAt);
        await migrator.addColumn(broadcasts, broadcasts.latitude);
        await migrator.addColumn(broadcasts, broadcasts.longitude);
      }
    },
  );

  // DAOs for Incidents
  Future<int> insertIncident(IncidentsCompanion incident) => into(incidents).insert(incident);
  Future<List<Incident>> getAllIncidents() => select(incidents).get();
  Future<List<Incident>> getUnsyncedIncidents() => (select(incidents)..where((t) => t.syncStatus.equals(SyncStatus.pending.name))).get();

  // DAOs for Broadcasts

  /// Insert a broadcast, ignoring duplicates (same title + observedAt = same event).
  Future<int> insertBroadcast(BroadcastsCompanion broadcast) =>
      into(broadcasts).insertOnConflictUpdate(broadcast);

  Future<List<Broadcast>> getAllBroadcasts() => select(broadcasts).get();

  /// Return alerts sorted newest-first, optionally limited to those observed after [since].
  Future<List<Broadcast>> getAlertsSince(DateTime since) {
    final cutoffMs = since.millisecondsSinceEpoch;
    return (select(broadcasts)
          ..where((t) => t.observedAt.isBiggerOrEqualValue(cutoffMs))
          ..orderBy([(t) => OrderingTerm.desc(t.observedAt)]))
        .get();
  }

  /// Return the most-recent sync timestamp across all non-local alerts.
  Future<DateTime?> getLastSyncTime() async {
    final row = await (select(broadcasts)
          ..where((t) => t.source.isNotValue('local'))
          ..orderBy([(t) => OrderingTerm.desc(t.lastUpdatedAt)])
          ..limit(1))
        .getSingleOrNull();
    return row?.lastUpdatedAt;
  }

  // DAOs for Contacts
  Future<int> insertContact(EmergencyContactsCompanion contact) => into(emergencyContacts).insert(contact);
  Future<List<EmergencyContact>> getAllContacts() => select(emergencyContacts).get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'safety_offline.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
