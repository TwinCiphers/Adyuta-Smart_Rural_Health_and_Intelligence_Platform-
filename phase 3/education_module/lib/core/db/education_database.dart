import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'education_database.g.dart';

enum SyncStatus { pending, synced, error }

class SyncStatusConverter extends TypeConverter<SyncStatus, String> {
  const SyncStatusConverter();
  @override
  SyncStatus fromSql(String fromDb) => SyncStatus.values.firstWhere((e) => e.name == fromDb, orElse: () => SyncStatus.pending);
  @override
  String toSql(SyncStatus value) => value.name;
}

// Example Table
class ExampleTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get data => text()();
  TextColumn get syncStatus => text().map(const SyncStatusConverter()).withDefault(const Constant('pending'))();
  DateTimeColumn get lastUpdatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [ExampleTable])
class EducationDatabase extends _$EducationDatabase {
  EducationDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'education_offline.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
