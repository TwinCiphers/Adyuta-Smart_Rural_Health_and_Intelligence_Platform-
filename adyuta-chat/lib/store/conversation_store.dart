import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/conversation.dart';

/// Persists conversations locally (browser storage on web, a prefs file
/// elsewhere). The server's session memory is in-process and idle-TTL only, so
/// this is what makes history survive a reload or an API restart.
class ConversationStore {
  static const String _key = 'adyuta_chat_conversations_v1';

  Future<List<Conversation>> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return <Conversation>[];
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! List) return <Conversation>[];
      final List<Conversation> out = decoded
          .whereType<Map<String, dynamic>>()
          .map(Conversation.fromJson)
          .where((Conversation c) => c.id.isNotEmpty)
          .toList();
      out.sort((Conversation a, Conversation b) => b.updatedAt.compareTo(a.updatedAt));
      return out;
    } catch (_) {
      // Corrupt storage must not brick the app; start clean instead.
      return <Conversation>[];
    }
  }

  Future<void> saveAll(List<Conversation> conversations) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> payload =
        conversations.map((Conversation c) => c.toJson()).toList();
    await prefs.setString(_key, jsonEncode(payload));
  }

  Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
