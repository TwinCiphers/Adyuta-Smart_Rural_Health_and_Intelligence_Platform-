import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'agri_database.g.dart';

// ---------------------------------------------------------------------------
// Sync helpers (kept from original)
// ---------------------------------------------------------------------------

enum SyncStatus { pending, synced, error }

class SyncStatusConverter extends TypeConverter<SyncStatus, String> {
  const SyncStatusConverter();
  @override
  SyncStatus fromSql(String fromDb) =>
      SyncStatus.values.firstWhere((e) => e.name == fromDb,
          orElse: () => SyncStatus.pending);
  @override
  String toSql(SyncStatus value) => value.name;
}

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------

/// Example table kept from original scaffold.
class ExampleTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get data => text()();
  TextColumn get syncStatus =>
      text().map(const SyncStatusConverter()).withDefault(const Constant('pending'))();
  DateTimeColumn get lastUpdatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Mandi prices cached from data.gov.in / Agmarknet.
/// Modal price is the most-traded price; min/max bracket the session range.
class MandiPrices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get state => text()();
  TextColumn get district => text()();
  TextColumn get market => text()();
  TextColumn get commodity => text()();
  TextColumn get variety => text().withDefault(const Constant(''))();
  RealColumn get minPrice => real().withDefault(const Constant(0.0))();
  RealColumn get maxPrice => real().withDefault(const Constant(0.0))();
  RealColumn get modalPrice => real()();
  TextColumn get priceUnit => text().withDefault(const Constant('per Qtl'))();
  /// Unix milliseconds – when the price was reported at the mandi.
  IntColumn get observedAt => integer()();
  /// Unix milliseconds – when this row was written to local DB.
  IntColumn get ingestedAt => integer()();
  TextColumn get source => text().withDefault(const Constant('Agmarknet'))();
}

/// Full Open-Meteo JSON cached per location for offline use.
/// Only the most-recent row per location name is used; old rows can be pruned.
class WeatherCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get locationName => text()();
  /// Complete JSON response body from Open-Meteo /v1/forecast.
  TextColumn get responseJson => text()();
  /// Unix milliseconds – when this cache entry was fetched.
  IntColumn get fetchedAt => integer()();
}

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

@DriftDatabase(tables: [ExampleTable, MandiPrices, WeatherCache])
class AgriDatabase extends _$AgriDatabase {
  AgriDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  // ── MandiPrices helpers ──────────────────────────────────────────────────

  /// Bulk-insert mandi prices, replacing any conflict (state+market+commodity+observedAt).
  Future<void> upsertMandiPrices(List<MandiPricesCompanion> rows) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(mandiPrices, rows);
    });
  }

  /// Load all cached mandi prices, newest first.
  Future<List<MandiPrice>> loadMandiPrices({String? state}) {
    final query = select(mandiPrices);
    if (state != null && state.isNotEmpty && state != 'All India') {
      query.where((t) => t.state.equals(state));
    }
    query.orderBy([(t) => OrderingTerm.desc(t.ingestedAt)]);
    return query.get();
  }

  // ── WeatherCache helpers ─────────────────────────────────────────────────

  /// Upsert a weather response for a location. We keep only the latest row per
  /// location name to avoid unbounded growth.
  Future<void> upsertWeatherCache(WeatherCacheCompanion entry) async {
    // Delete the old entry for this location first (keeps table small).
    await (delete(weatherCache)
          ..where((t) => t.locationName.equals(entry.locationName.value)))
        .go();
    await into(weatherCache).insert(entry);
  }

  /// Load the most-recent cached weather response for [locationName].
  Future<WeatherCacheData?> loadWeatherCache(String locationName) {
    final query = select(weatherCache)
      ..where((t) => t.locationName.equals(locationName))
      ..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)])
      ..limit(1);
    return query.getSingleOrNull();
  }
}

// ---------------------------------------------------------------------------
// Connection factory
// ---------------------------------------------------------------------------

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'agri_cache.db'));
    return NativeDatabase.createInBackground(file);
  });
}
