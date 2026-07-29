import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() {
  final dbDir = Directory('c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase 3/health_module/assets/offline/health');
  if (!dbDir.existsSync()) {
    print('Directory not found.');
    return;
  }

  for (var file in dbDir.listSync()) {
    if (file is File && file.path.endsWith('.db')) {
      print('\n--- \${file.path.split(Platform.pathSeparator).last} ---');
      final db = sqlite3.open(file.path);
      
      // Get tables
      final ResultSet tables = db.select('SELECT name FROM sqlite_master WHERE type="table";');
      for (final Row tableRow in tables) {
        final tableName = tableRow['name'] as String;
        if (tableName == 'sqlite_sequence' || tableName == 'android_metadata') continue;
        print('Table: \$tableName');
        
        final ResultSet rows = db.select('SELECT * FROM \$tableName LIMIT 5;');
        for (final Row row in rows) {
          print('  \$row');
        }
      }
      db.dispose();
    }
  }
}
