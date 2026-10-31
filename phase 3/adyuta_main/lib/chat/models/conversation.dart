import 'chat_message.dart';

/// One saved conversation.
///
/// [id] doubles as the server-side `session_id`, so the backend can fold prior
/// turns into the next prompt. Local storage keeps the display history; the
/// server copy is in-memory only (idle TTL, evicted on restart), which is why
/// the app also works when the server forgets.
class Conversation {
  Conversation({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    List<ChatMessage>? messages,
  }) : messages = messages ?? <ChatMessage>[];

  final String id;
  String title;
  final DateTime createdAt;
  DateTime updatedAt;
  final List<ChatMessage> messages;

  void touch() => updatedAt = DateTime.now();

  /// Title from the first user turn, so the drawer is readable without asking
  /// the user to name anything.
  void maybeRetitle() {
    if (title.isNotEmpty) return;
    for (final ChatMessage m in messages) {
      if (m.isUser && m.text.trim().isNotEmpty) {
        final String t = m.text.trim().replaceAll('\n', ' ');
        title = t.length <= 42 ? t : '${t.substring(0, 41)}…';
        return;
      }
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'messages': messages.map((ChatMessage m) => m.toJson()).toList(),
      };

  static Conversation fromJson(Map<String, dynamic> json) => Conversation(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
        messages: (json['messages'] as List<dynamic>?)
                ?.map((dynamic e) => ChatMessage.fromJson(e as Map<String, dynamic>))
                .toList() ??
            <ChatMessage>[],
      );
}
