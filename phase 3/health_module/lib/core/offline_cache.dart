import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Generic offline-first cache wrapper. Every module uses this same
/// pattern so the sync logic is identical when modules are unified later.
class OfflineCache {
  static Future<void> saveJson(String key, Map<String, dynamic> value) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? [];
    list.add(jsonEncode(value));
    await prefs.setStringList(key, list);
  }

  static Future<List<Map<String, dynamic>>> readJsonList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? [];
    return list.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  static Future<void> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
