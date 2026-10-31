import 'package:adyuta_chat/api/adyuta_client.dart';
import 'package:adyuta_chat/config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildAskBody', () {
    test('direct route sends neither force nor locale', () {
      final Map<String, dynamic> body = AdyutaClient.buildAskBody(
        settings: AppSettings(
          route: AskRoute.direct,
          force: ForceMode.offline,
          locale: 'ta',
        ),
        query: 'chest pain',
        sessionId: 's1',
        history: const <ChatTurn>[],
      );

      expect(body['query'], 'chest pain');
      expect(body.containsKey('force'), isFalse,
          reason: '/rag/answer has no connectivity to force');
      expect(body.containsKey('locale'), isFalse);
      expect(body['session_id'], 's1');
      expect(body.containsKey('history'), isFalse,
          reason: 'an empty history is not sent at all');
    });

    test('router sends force even when it is auto, and the pinned locale', () {
      final Map<String, dynamic> body = AdyutaClient.buildAskBody(
        settings: AppSettings(
          route: AskRoute.router,
          force: ForceMode.auto,
          locale: 'te',
        ),
        query: 'fever',
        sessionId: 's1',
        history: const <ChatTurn>[],
      );

      expect(body['force'], 'auto');
      expect(body['locale'], 'te');
    });

    test('auto locale is omitted so the server detects it', () {
      final Map<String, dynamic> body = AdyutaClient.buildAskBody(
        settings: AppSettings(route: AskRoute.router),
        query: 'fever',
        sessionId: 's1',
        history: const <ChatTurn>[],
      );

      expect(body.containsKey('locale'), isFalse);
      expect(body['force'], 'auto');
    });

    test('domain and history are forwarded when present', () {
      final Map<String, dynamic> body = AdyutaClient.buildAskBody(
        settings: AppSettings(domain: 'health'),
        query: 'what should I do about a fever',
        sessionId: 's1',
        history: const <ChatTurn>[
          ChatTurn(role: 'user', content: 'hi'),
          ChatTurn(role: 'assistant', content: 'hello'),
        ],
      );

      expect(body['filter_domain'], 'health');
      expect(body['top_k'], 5);
      expect(body['history'], hasLength(2));
      expect((body['history'] as List<dynamic>).first,
          <String, String>{'role': 'user', 'content': 'hi'});
    });
  });
}
