$modules = @("safety_module", "agri_module", "education_module", "governance_module")
$basePath = "C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3"

foreach ($mod in $modules) {
    Write-Host "Processing $mod..."
    $pubspecPath = "$basePath\$mod\pubspec.yaml"
    
    if (-Not (Test-Path $pubspecPath)) {
        Write-Host "pubspec.yaml not found for $mod"
        continue
    }
    
    $content = Get-Content $pubspecPath -Raw
    
    if (-Not $content.Contains("drift:")) {
        $content = $content -replace "dev_dependencies:", "  drift: any`n  sqlite3_flutter_libs: any`n  path_provider: any`n  path: any`n`ndev_dependencies:"
    }
    
    if (-Not $content.Contains("drift_dev:")) {
        $content = $content -replace "flutter_test:", "flutter_test:`n  build_runner: any`n  drift_dev: any"
    }
    
    Set-Content -Path $pubspecPath -Value $content -NoNewline
    Write-Host "Updated pubspec.yaml for $mod"
    
    $dbDir = "$basePath\$mod\lib\core\db"
    if (-Not (Test-Path $dbDir)) {
        New-Item -ItemType Directory -Force -Path $dbDir | Out-Null
    }
    
    $prefix = $mod.Replace("_module", "")
    $className = $prefix.Substring(0,1).ToUpper() + $prefix.Substring(1) + "Database"
    $dbFile = "$dbDir\${prefix}_database.dart"
    
    if (-Not (Test-Path $dbFile)) {
        $dbContent = @"
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
"@
        # Fix the _$className issue by string replacement since PowerShell interprets _$className
        $dbContent = $dbContent.Replace("_" + $className, "_`$" + $className)
        
        Set-Content -Path $dbFile -Value $dbContent
        Write-Host "Created ${prefix}_database.dart"
    }
}
