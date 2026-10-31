import 'package:hive_flutter/hive_flutter.dart';


class CoreStorageManager {
  static const String _settingsBoxName = 'app_settings';

  static Future<void> initialize() async {
    // Initialize Hive for preferences & settings
    await Hive.initFlutter();
    await Hive.openBox(_settingsBoxName);

    // Supabase completely removed
  }

  static Box get settingsBox => Hive.box(_settingsBoxName);

  
}

