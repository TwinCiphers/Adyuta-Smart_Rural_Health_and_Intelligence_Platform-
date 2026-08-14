import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safety_module/core/db/safety_database.dart';

void main() {
  late SafetyDatabase db;

  setUp(() {
    // Uses an in-memory database for testing
    db = SafetyDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('Database should be empty initially', () async {
    final incidents = await db.getAllIncidents();
    expect(incidents, isEmpty);
  });

  test('Can insert and retrieve an Incident', () async {
    final newIncident = IncidentsCompanion(
      type: const Value('Robbery'),
      description: const Value('Suspicious activity near main road'),
      latitude: const Value(23.2599),
      longitude: const Value(77.4126),
      timestamp: Value(DateTime.now()),
    );

    await db.insertIncident(newIncident);

    final incidents = await db.getAllIncidents();
    expect(incidents.length, 1);
    expect(incidents.first.type, 'Robbery');
    expect(incidents.first.syncStatus, SyncStatus.pending.name);
  });

  test('Can fetch only unsynced (pending) incidents', () async {
    // Insert pending
    await db.insertIncident(IncidentsCompanion(
      type: const Value('Harassment'),
      latitude: const Value(23.0),
      longitude: const Value(77.0),
    ));

    // Insert synced
    await db.into(db.incidents).insert(IncidentsCompanion(
      type: const Value('Stalking'),
      latitude: const Value(23.1),
      longitude: const Value(77.1),
      syncStatus: const Value(SyncStatus.synced),
    ));

    final unsynced = await db.getUnsyncedIncidents();
    expect(unsynced.length, 1);
    expect(unsynced.first.type, 'Harassment');
  });
}
