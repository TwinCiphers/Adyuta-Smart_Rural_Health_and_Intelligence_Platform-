import 'package:adyuta_chat/models/chat_message.dart';
import 'package:adyuta_chat/ui/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpBubble(WidgetTester tester, ChatMessage message) async {
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(body: MessageBubble(message: message)),
  ));
}

/// `SelectableText` is used for answer bodies so they can be copied, which
/// `find.text` does not match reliably.
bool showsText(WidgetTester tester, String needle) => tester
    .widgetList<SelectableText>(find.byType(SelectableText))
    .any((SelectableText w) => (w.data ?? '').contains(needle));

void main() {
  testWidgets('answered turn shows the answer text', (WidgetTester tester) async {
    await pumpBubble(
      tester,
      ChatMessage(
        id: 'a1',
        role: ChatRole.assistant,
        text: 'Spray chlorothalonil at first symptoms.',
        at: DateTime.now(),
      ),
    );
    expect(showsText(tester, 'Spray chlorothalonil'), isTrue);
  });

  testWidgets('placeholder turn renders a notice, never the placeholder string',
      (WidgetTester tester) async {
    await pumpBubble(
      tester,
      ChatMessage(
        id: 'a2',
        role: ChatRole.assistant,
        text: '',
        at: DateTime.now(),
        kind: MessageKind.placeholder,
        notice: 'No model connected.',
      ),
    );

    expect(find.text('No model connected — this is not an answer'), findsOneWidget);
    expect(showsText(tester, 'No model connected.'), isTrue);
    expect(showsText(tester, 'PLACEHOLDER'), isFalse);
  });

  testWidgets('a server refusal keeps its own words but is labelled',
      (WidgetTester tester) async {
    await pumpBubble(
      tester,
      ChatMessage(
        id: 'a10',
        role: ChatRole.assistant,
        text: 'I do not have enough information in the retrieved context.',
        at: DateTime.now(),
        kind: MessageKind.declined,
        notice: 'unused for a refusal',
        meta: const MessageMeta(
          model: 'none',
          selectedCount: 0,
          droppedBelowFloor: 5,
        ),
      ),
    );

    expect(showsText(tester, 'I do not have enough information'), isTrue,
        reason: 'the server\'s own refusal wording is shown');
    expect(showsText(tester, 'unused for a refusal'), isFalse);
    expect(
      find.textContaining('nothing cleared the relevance floor'),
      findsOneWidget,
    );
    expect(find.textContaining('dropped below floor: 5'), findsOneWidget);
  });

  testWidgets('static safety content says so instead of showing a model',
      (WidgetTester tester) async {
    await pumpBubble(
      tester,
      ChatMessage(
        id: 'a11',
        role: ChatRole.assistant,
        text: 'For a snake bite: keep the limb still and call 108.',
        at: DateTime.now(),
        meta: const MessageMeta(
          model: 'none',
          safetyStatic: true,
          hasFloor: true,
        ),
      ),
    );

    expect(find.textContaining('static safety content, no model'), findsOneWidget);
  });

  testWidgets('abstained turn is labelled as such', (WidgetTester tester) async {
    await pumpBubble(
      tester,
      ChatMessage(
        id: 'a3',
        role: ChatRole.assistant,
        text: '',
        at: DateTime.now(),
        kind: MessageKind.abstained,
        notice: 'Nothing relevant was found.',
      ),
    );
    expect(find.text('No relevant information found'), findsOneWidget);
  });

  testWidgets('failed turn is labelled as a failure', (WidgetTester tester) async {
    await pumpBubble(
      tester,
      ChatMessage(
        id: 'a4',
        role: ChatRole.assistant,
        text: '',
        at: DateTime.now(),
        kind: MessageKind.failed,
        notice: 'Could not reach the server.',
      ),
    );
    expect(find.text('Request failed'), findsOneWidget);
  });

  testWidgets('metadata chips and citations are rendered', (WidgetTester tester) async {
    await pumpBubble(
      tester,
      ChatMessage(
        id: 'a5',
        role: ChatRole.assistant,
        text: 'Grounded answer.',
        at: DateTime.now(),
        meta: const MessageMeta(
          model: 'groq:openai/gpt-oss-120b',
          mode: 'online',
          via: 'rag:groq:openai/gpt-oss-120b',
          bestScore: 0.6012,
          minScoreApplied: 0.55,
          hasFloor: true,
          thin: true,
          thinNote: 'Treat this as a pointer to the source.',
          droppedBelowFloor: 2,
          sources: <SourceRef>[
            SourceRef(chunkId: 'ADY-1-c00001', title: 'Tomato guide'),
          ],
        ),
      ),
    );

    expect(find.textContaining('model: groq:'), findsOneWidget);
    expect(find.textContaining('mode: online'), findsOneWidget);
    expect(find.textContaining('floor 0.55'), findsOneWidget);
    expect(find.textContaining('best score 0.601'), findsOneWidget);
    expect(find.textContaining('dropped below floor: 2'), findsOneWidget);
    expect(find.textContaining('thin grounding'), findsOneWidget);
    expect(find.text('Treat this as a pointer to the source.'), findsOneWidget);
    expect(find.text('Tomato guide'), findsOneWidget);
  });

  testWidgets('detected locale is shown on a router reply',
      (WidgetTester tester) async {
    await pumpBubble(
      tester,
      ChatMessage(
        id: 'a8',
        role: ChatRole.assistant,
        text: 'Answer.',
        at: DateTime.now(),
        meta: const MessageMeta(
          model: 'groq:x',
          locale: 'kn',
          tier: 'lite',
        ),
      ),
    );
    expect(find.textContaining('locale: kn'), findsOneWidget);
    expect(find.textContaining('server tier: lite'), findsOneWidget,
        reason: 'tier must be labelled as the server profile, not the device');
  });

  testWidgets('a thin-grounding note already inside the answer is not repeated',
      (WidgetTester tester) async {
    const String note =
        'This answer rests on 1 passage(s) from the knowledge base.';
    await pumpBubble(
      tester,
      ChatMessage(
        id: 'a9',
        role: ChatRole.assistant,
        text: 'PM-KISAN is a scheme. $note',
        at: DateTime.now(),
        meta: const MessageMeta(
          model: 'groq:x',
          thin: true,
          thinNote: note,
          minScoreApplied: 0.55,
        ),
      ),
    );

    expect(showsText(tester, note), isTrue, reason: 'it is still in the body');
    expect(find.text(note), findsNothing,
        reason: 'it must not also be printed a second time as a meta note');
    expect(find.textContaining('thin grounding'), findsOneWidget);
  });

  testWidgets('an advisory in another language is flagged, not glossed over',
      (WidgetTester tester) async {
    await pumpBubble(
      tester,
      ChatMessage(
        id: 'a7',
        role: ChatRole.assistant,
        text: 'This is not a medical diagnosis. Seek care.',
        at: DateTime.now(),
        meta: const MessageMeta(
          model: 'local-lite',
          mode: 'offline',
          locale: 'ta',
          advisoryLocale: 'en',
        ),
      ),
    );
    expect(find.textContaining('advisory in en (asked in ta)'), findsOneWidget);
  });

  testWidgets('safety exemption is labelled instead of showing a floor',
      (WidgetTester tester) async {
    await pumpBubble(
      tester,
      ChatMessage(
        id: 'a6',
        role: ChatRole.assistant,
        text: 'Static safety content.',
        at: DateTime.now(),
        meta: const MessageMeta(
          model: 'none',
          minScoreApplied: null,
          hasFloor: true,
        ),
      ),
    );
    expect(find.textContaining('no floor (safety exemption)'), findsOneWidget);
  });
}
