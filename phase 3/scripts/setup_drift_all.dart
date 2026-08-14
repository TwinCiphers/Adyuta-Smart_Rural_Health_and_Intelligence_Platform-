import 'dart:io';

void main() async {
  final modules = ['safety_module', 'agri_module', 'education_module', 'governance_module'];
  final basePath = 'C:\\Users\\dk-32\\OneDrive\\Desktop\\Adyuta-MP\\phase 3';

  for (final module in modules) {
    print('Processing $module...');
    final pubspecPath = '$basePath\\$module\\pubspec.yaml';
    final pubspecFile = File(pubspecPath);
    
    if (!pubspecFile.existsSync()) {
      print('pubspec.yaml not found for $module');
      continue;
    }
    
    var content = pubspecFile.readAsStringSync();
    
    // Add dependencies if not present
    if (!content.contains('drift:')) {
      content = content.replaceFirst('dev_dependencies:', 
'''  drift: any
  sqlite3_flutter_libs: any
  path_provider: any
  path: any

dev_dependencies:''');
    }
    
    if (!content.contains('drift_dev:')) {
      content = content.replaceFirst('flutter_test:', 
'''flutter_test:
  build_runner: any
  drift_dev: any''');
    }
    
    pubspecFile.writeAsStringSync(content);
    print('Updated pubspec.yaml for $module');

    // Create database file
    final dbDir = Directory('$basePath\\$module\\lib\\core\\db');
    if (!dbDir.existsSync()) {
      dbDir.createSync(recursive: true);
    }
    
    final prefix = module.replaceAll('_module', '');
    final className = prefix[0].toUpperCase() + prefix.substring(1) + 'Database';
    final dbFile = File('$basePath\\$module\\lib\\core\\db\\${prefix}_database.dart');
    
    if (!dbFile.existsSync()) {
      final dbContent = '''
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part '${prefix}_database.g.dart';

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
class $className extends _$className {
  $className() : super(_openConnection());
  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, '${prefix}_offline.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
''';
      dbFile.writeAsStringSync(dbContent.replaceAll('_$className', '_$$className'));
      print('Created ${prefix}_database.dart');
    }
  }
}
