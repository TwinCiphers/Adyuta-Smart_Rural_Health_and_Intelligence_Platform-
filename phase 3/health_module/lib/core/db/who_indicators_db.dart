import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'who_indicators_db.g.dart';

class WhoIndicator extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get indicatorCode => text()();
  TextColumn get indicatorName => text()();
  RealColumn get value => real()();
  TextColumn get unit => text()();
  IntColumn get year => integer()();
  IntColumn get ingestedAt => integer()();
}

@DriftDatabase(tables: [WhoIndicator])
class WhoIndicatorsDatabase extends _$WhoIndicatorsDatabase {
  WhoIndicatorsDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
  
  Future<List<WhoIndicatorData>> getAllIndicators() => select(whoIndicator).get();
  
  Future<void> upsertIndicators(List<WhoIndicatorCompanion> rows) async {
    await batch((b) {
      // Very simple replace-all for the cache
      b.deleteAll(whoIndicator);
      b.insertAll(whoIndicator, rows);
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'who_cache.db'));
    return NativeDatabase.createInBackground(file);
  });
}
