import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'seed_data.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal() {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  final Map<String, Database> _databases = {};
  // Prevents simultaneous parallel initialization of the same DB
  final Map<String, Future<Database>> _initializing = {};

  Future<Database> getDatabase(String dbName) async {
    if (_databases.containsKey(dbName)) {
      return _databases[dbName]!;
    }
    // If another call is already initializing this DB, wait for it
    if (_initializing.containsKey(dbName)) {
      return _initializing[dbName]!;
    }
    final future = _initDatabase(dbName).then((db) {
      _databases[dbName] = db;
      _initializing.remove(dbName);
      return db;
    });
    _initializing[dbName] = future;
    return future;
  }

  // Invalidate cached instance (used after uninstall/wipe)
  void invalidate(String dbName) {
    _databases.remove(dbName);
  }

  Future<Database> _initDatabase(String dbName) async {
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, dbName);

    // NOTE: We do NOT call deleteDatabase anymore — that was wiping all user data.
    final exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(p.dirname(path)).create(recursive: true);
      } catch (_) {}

      // Try copying pre-built asset first
      bool assetCopied = false;
      try {
        final data = await rootBundle.load('assets/offline/health/$dbName');
        final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
        assetCopied = true;
        debugPrint('DatabaseHelper: Copied $dbName from assets');
      } catch (_) {
        debugPrint('DatabaseHelper: No bundled asset for $dbName — will create fresh.');
      }

      // Asset DBs are stripped shells with wrong schemas — always recreate schema
      if (assetCopied) {
        final tempDb = await openDatabase(path);
        await _dropStaleSchema(tempDb, dbName);
        await tempDb.close();
      }

      if (!assetCopied) {
        // Create fresh database with full schema + seed data
        final db = await openDatabase(
          path,
          version: 2,
          onCreate: (db, version) async {
            await _createSchema(db, dbName);
            await SeedData.seedDatabase(db, dbName);
          },
        );
        await _ensureSeeded(db, dbName);
        return db;
      }
    }

    // Open existing or freshly-copied asset DB.
    // version 2 triggers onUpgrade for any old v1 DB (asset copy) so we seed it.
    final db = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await _createSchema(db, dbName);
        await SeedData.seedDatabase(db, dbName);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          debugPrint('DatabaseHelper: Upgrading $dbName from v$oldVersion to v$newVersion — seeding data');
          await _ensureSchema(db, dbName);
          await SeedData.seedDatabase(db, dbName);
        }
      },
    );

    await _ensureSeeded(db, dbName);
    return db;
  }

  /// Drops stale asset tables that have wrong schemas.
  Future<void> _dropStaleSchema(Database db, String dbName) async {
    try {
      if (dbName == 'firstaid.db') {
        await db.execute('DROP TABLE IF EXISTS emergency_topics');
        await db.execute('DROP TABLE IF EXISTS emergency_steps');
        await db.execute('DROP TABLE IF EXISTS danger_signs');
        await db.execute('DROP TABLE IF EXISTS avoid_actions');
        await db.execute('DROP TABLE IF EXISTS referral_rules');
      }
      if (dbName == 'nutrition.db') {
        await db.execute('DROP TABLE IF EXISTS foods');
        await db.execute('DROP TABLE IF EXISTS ayurveda_food_meta');
        await db.execute('DROP TABLE IF EXISTS diet_tags');
        await db.execute('DROP TABLE IF EXISTS recipes');
      }
      if (dbName == 'mch.db') {
        await db.execute('DROP TABLE IF EXISTS pregnancy_weeks');
        await db.execute('DROP TABLE IF EXISTS maternal_vaccines');
        await db.execute('DROP TABLE IF EXISTS danger_signs');
      }
      if (dbName == 'medicines.db') {
        await db.execute('DROP TABLE IF EXISTS medicines');
        await db.execute('DROP TABLE IF EXISTS purchase_links');
      }
      if (dbName == 'directory.db') {
        await db.execute('DROP TABLE IF EXISTS facilities');
        await db.execute('DROP TABLE IF EXISTS local_helpers');
      }
    } catch (e) {
      debugPrint('DatabaseHelper: _dropStaleSchema error: $e');
    }
  }

  /// Creates all tables for a given database if they do not already exist.
  Future<void> _createSchema(Database db, String dbName) async {
    if (dbName == 'medicines.db') {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS medicines (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          system TEXT NOT NULL,
          brand_name TEXT,
          generic_name TEXT,
          uses TEXT,
          mechanism TEXT,
          dosage_and_form TEXT,
          side_effects TEXT,
          drug_interactions TEXT,
          warnings_and_contraindications TEXT,
          safety_pregnancy_lactation TEXT,
          quality_standardization TEXT,
          manufacturer_approval TEXT,
          source_ref TEXT,
          botanical_name TEXT,
          family TEXT,
          vernacular_names TEXT,
          part_used TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS purchase_links (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          medicine_id INTEGER NOT NULL,
          platform TEXT,
          url TEXT,
          price_inr REAL
        )
      ''');
    }

    if (dbName == 'firstaid.db') {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS emergency_topics (
          id INTEGER PRIMARY KEY,
          slug TEXT UNIQUE,
          title TEXT NOT NULL,
          category TEXT,
          urgency_level TEXT,
          audio_key TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS emergency_steps (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          topic_id INTEGER NOT NULL,
          step_no INTEGER NOT NULL,
          type TEXT,
          text_content TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS danger_signs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          topic_id INTEGER,
          sign_text TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS avoid_actions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          topic_id INTEGER,
          action_text TEXT,
          reason_text TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS referral_rules (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          topic_id INTEGER,
          rule_text TEXT,
          referral_level TEXT
        )
      ''');
    }

    if (dbName == 'mch.db') {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS pregnancy_weeks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          week_no INTEGER UNIQUE NOT NULL,
          baby_growth TEXT,
          mother_changes TEXT,
          diet_tip TEXT,
          activity_tip TEXT,
          warning_signs TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS maternal_vaccines (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          code TEXT UNIQUE,
          title TEXT NOT NULL,
          recommended_time TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS danger_signs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          stage TEXT,
          sign_text TEXT,
          referral_level TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS local_helpers (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          helper_type TEXT,
          village TEXT,
          district TEXT,
          phone TEXT
        )
      ''');
    }

    if (dbName == 'directory.db') {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS facilities (
          facility_id INTEGER PRIMARY KEY,
          facility_name TEXT NOT NULL,
          facility_type TEXT,
          system_of_medicine TEXT,
          address TEXT,
          phone TEXT,
          working_hours TEXT,
          is_24x7 INTEGER DEFAULT 0
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS local_helpers (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          helper_type TEXT,
          village TEXT,
          district TEXT,
          phone TEXT
        )
      ''');
    }

    if (dbName == 'nutrition.db') {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS foods (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          local_name TEXT,
          category TEXT,
          serving_size_g INTEGER DEFAULT 100,
          calories REAL DEFAULT 0,
          protein_g REAL DEFAULT 0,
          iron_mg REAL DEFAULT 0,
          calcium_mg REAL DEFAULT 0,
          fibre_g REAL DEFAULT 0,
          fat_g REAL DEFAULT 0,
          carbs_g REAL DEFAULT 0,
          sugar_g REAL DEFAULT 0,
          sodium_mg REAL DEFAULT 0
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ayurveda_food_meta (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          food_id INTEGER,
          rasa TEXT,
          guna TEXT,
          virya TEXT,
          notes TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS diet_tags (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          food_id INTEGER,
          tag TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS recipes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          local_name TEXT,
          serving_size_g INTEGER,
          calories REAL,
          protein_g REAL,
          iron_mg REAL,
          notes TEXT
        )
      ''');
    }

    if (dbName == 'phr.db') {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS profiles (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          relation TEXT,
          blood_group TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS conditions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          profile_id INTEGER NOT NULL,
          condition_name TEXT,
          diagnosed_date TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS vitals (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          profile_id INTEGER NOT NULL,
          date TEXT,
          systolic INTEGER,
          diastolic INTEGER,
          sugar_level INTEGER,
          timestamp TEXT DEFAULT CURRENT_TIMESTAMP
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS medicines (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          profile_id INTEGER NOT NULL,
          medicine_name TEXT,
          dosage TEXT,
          start_date TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS visits (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          profile_id INTEGER NOT NULL,
          doctor_name TEXT,
          visit_date TEXT,
          reason TEXT,
          notes TEXT
        )
      ''');
    }
  }

  /// Ensures schema exists on existing DBs (asset copies may be missing tables).
  Future<void> _ensureSchema(Database db, String dbName) async {
    await _createSchema(db, dbName);
  }

  /// Automatically self-heals empty or missing tables by seeding data.
  Future<void> _ensureSeeded(Database db, String dbName) async {
    try {
      await _ensureSchema(db, dbName);
      int count = 0;
      if (dbName == 'medicines.db') {
        count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM medicines')) ?? 0;
      } else if (dbName == 'firstaid.db') {
        count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM emergency_topics')) ?? 0;
      } else if (dbName == 'mch.db') {
        count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM pregnancy_weeks')) ?? 0;
      } else if (dbName == 'directory.db') {
        count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM facilities')) ?? 0;
      } else if (dbName == 'nutrition.db') {
        count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM foods')) ?? 0;
      }
      if (count == 0 && dbName != 'phr.db') {
        debugPrint('DatabaseHelper: $dbName is empty ($count rows) — running seedDatabase now');
        await SeedData.seedDatabase(db, dbName);
      }
    } catch (e) {
      debugPrint('DatabaseHelper: _ensureSeeded error for $dbName: $e');
      await _ensureSchema(db, dbName);
      await SeedData.seedDatabase(db, dbName);
    }
  }
}
