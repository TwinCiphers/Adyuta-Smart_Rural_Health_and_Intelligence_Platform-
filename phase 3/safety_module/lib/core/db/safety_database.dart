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

// Table: Broadcasts
class Broadcasts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get message => text()();
  TextColumn get severity => text()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();

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

@DriftDatabase(tables: [Incidents, Broadcasts, EmergencyContacts])
class SafetyDatabase extends _$SafetyDatabase {
  SafetyDatabase() : super(_openConnection());
  SafetyDatabase.forTesting(QueryExecutor e) : super(e);
  @override
  int get schemaVersion => 1;

  // DAOs for Incidents
  Future<int> insertIncident(IncidentsCompanion incident) => into(incidents).insert(incident);
  Future<List<Incident>> getAllIncidents() => select(incidents).get();
  Future<List<Incident>> getUnsyncedIncidents() => (select(incidents)..where((t) => t.syncStatus.equals(SyncStatus.pending.name))).get();

  // DAOs for Broadcasts
  Future<int> insertBroadcast(BroadcastsCompanion broadcast) => into(broadcasts).insert(broadcast);
  Future<List<Broadcast>> getAllBroadcasts() => select(broadcasts).get();

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
