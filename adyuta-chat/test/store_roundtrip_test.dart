import 'package:adyuta_chat/models/chat_message.dart';
import 'package:adyuta_chat/models/conversation.dart';
import 'package:adyuta_chat/store/conversation_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('starts empty', () async {
    final ConversationStore store = ConversationStore();
    expect(await store.load(), isEmpty);
  });

  test('saves and reloads a conversation with its messages and meta', () async {
    final ConversationStore store = ConversationStore();
    final Conversation c = Conversation(
      id: 'c1',
      title: '',
      createdAt: DateTime.parse('2026-09-30T09:00:00Z'),
      updatedAt: DateTime.parse('2026-09-30T09:05:00Z'),
    );
    c.messages.add(ChatMessage(
      id: 'u1',
      role: ChatRole.user,
      text: 'How do I control early blight in tomato?',
      at: DateTime.parse('2026-09-30T09:00:01Z'),
    ));
    c.messages.add(ChatMessage(
      id: 'a1',
      role: ChatRole.assistant,
      text: 'Grounded answer.',
      at: DateTime.parse('2026-09-30T09:00:02Z'),
      meta: const MessageMeta(
        model: 'groq:openai/gpt-oss-120b',
        mode: 'online',
        bestScore: 0.77,
        minScoreApplied: 0.55,
        thin: true,
        sources: <SourceRef>[
          SourceRef(chunkId: 'ADY-x-c00007', title: 'Tomato guide', urlRecorded: false),
        ],
      ),
    ));
    c.maybeRetitle();

    await store.saveAll(<Conversation>[c]);
    final List<Conversation> loaded = await store.load();

    expect(loaded, hasLength(1));
    final Conversation r = loaded.single;
    expect(r.id, 'c1');
    expect(r.title, 'How do I control early blight in tomato?');
    expect(r.messages, hasLength(2));
    expect(r.messages.last.meta?.model, 'groq:openai/gpt-oss-120b');
    expect(r.messages.last.meta?.bestScore, closeTo(0.77, 1e-9));
    expect(r.messages.last.meta?.thin, isTrue);
    expect(r.messages.last.meta?.sources.single.chunkId, 'ADY-x-c00007');
  });

  test('title is derived only from the first user turn', () {
    final Conversation c = Conversation(
      id: 'c2',
      title: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    c.messages.add(ChatMessage(
      id: 'u1',
      role: ChatRole.user,
      text: 'What is PM-KISAN?',
      at: DateTime.now(),
    ));
    c.maybeRetitle();
    expect(c.title, 'What is PM-KISAN?');

    c.messages.add(ChatMessage(
      id: 'a1',
      role: ChatRole.assistant,
      text: 'A scheme.',
      at: DateTime.now(),
    ));
    c.maybeRetitle();
    expect(c.title, 'What is PM-KISAN?', reason: 'title must not drift');
  });

  test('a long first question is truncated for the drawer', () {
    final Conversation c = Conversation(
      id: 'c3',
      title: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    c.messages.add(ChatMessage(
      id: 'u1',
      role: ChatRole.user,
      text: 'x' * 200,
      at: DateTime.now(),
    ));
    c.maybeRetitle();
    expect(c.title.length, lessThanOrEqualTo(42));
    expect(c.title.endsWith('…'), isTrue);
  });

  test('corrupt storage degrades to empty instead of throwing', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'adyuta_chat_conversations_v1': 'not json at all',
    });
    expect(await ConversationStore().load(), isEmpty);
  });

  test('loaded conversations are newest-first', () async {
    final ConversationStore store = ConversationStore();
    final Conversation older = Conversation(
      id: 'old',
      title: 'older',
      createdAt: DateTime.parse('2026-09-01T00:00:00Z'),
      updatedAt: DateTime.parse('2026-09-01T00:00:00Z'),
    );
    final Conversation newer = Conversation(
      id: 'new',
      title: 'newer',
      createdAt: DateTime.parse('2026-09-29T00:00:00Z'),
      updatedAt: DateTime.parse('2026-09-29T00:00:00Z'),
    );
    await store.saveAll(<Conversation>[older, newer]);

    final List<Conversation> loaded = await ConversationStore().load();
    expect(loaded.first.id, 'new');
    expect(loaded.last.id, 'old');
  });
}
