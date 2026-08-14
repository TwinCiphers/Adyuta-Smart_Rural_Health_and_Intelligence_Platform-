import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoreStorageManager {
  static const String _settingsBoxName = 'app_settings';

  static Future<void> initialize() async {
    // Initialize Hive for preferences & settings
    await Hive.initFlutter();
    await Hive.openBox(_settingsBoxName);

    // Initialize Supabase
    await Supabase.initialize(
      url: 'https://wntieyjzdqfaykvzvxia.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndudGlleWp6ZHFmYXlrdnp2eGlhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODUzMzc2MTAsImV4cCI6MjEwMDkxMzYxMH0.JAyXybLOQdvGVsuBrYfsOBYw_KTaaq84rbqc0KhR5mo',
    );
  }

  static Box get settingsBox => Hive.box(_settingsBoxName);

  static SupabaseClient get supabaseClient => Supabase.instance.client;
}
