import 'package:adyuta_chat/api/adyuta_client.dart';
import 'package:adyuta_chat/api/outcome.dart';
import 'package:adyuta_chat/models/chat_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('outcomeFromAnswerJson', () {
    test('real answer becomes Answered', () {
      final ChatOutcome o = AdyutaClient.outcomeFromAnswerJson(<String, dynamic>{
        'status': 'ok',
        'answer': 'Apply chlorothalonil as directed.',
        'answer_model': 'groq:openai/gpt-oss-120b',
        'answer_placeholder': false,
      });
      expect(o, isA<Answered>());
      expect(o.displayText, 'Apply chlorothalonil as directed.');
    });

    test('placeholder is never exposed as display text', () {
      const String placeholder =
          "[PLACEHOLDER - no LLM connected in Stage 5E-A] Question received: 'x'.";
      final ChatOutcome o = AdyutaClient.outcomeFromAnswerJson(<String, dynamic>{
        'status': 'ok',
        'answer': placeholder,
        'answer_model': 'dummy',
        'answer_placeholder': true,
      });
      expect(o, isA<Placeholder>());
      // The decisive assertion: the UI can only render `notice`, never the
      // placeholder string, because displayText is null.
      expect(o.displayText, isNull);
      expect(o.notice, isNot(contains('PLACEHOLDER - no LLM connected')));
      expect(o.notice.toLowerCase(), contains('no language model'));
    });

    test('empty retrieval becomes Abstained', () {
      final ChatOutcome o = AdyutaClient.outcomeFromAnswerJson(<String, dynamic>{
        'status': 'empty_retrieval',
        'answer': '',
        'answer_model': 'none',
        'answer_placeholder': false,
      });
      expect(o, isA<Abstained>());
      expect(o.displayText, isNull);
    });

    test('blank answer without the flag still abstains', () {
      final ChatOutcome o = AdyutaClient.outcomeFromAnswerJson(<String, dynamic>{
        'status': 'ok',
        'answer': '   ',
        'answer_model': 'groq:x',
        'answer_placeholder': false,
      });
      expect(o, isA<Abstained>());
    });

    test('a floor refusal with no model becomes Declined, not Answered', () {
      final ChatOutcome o = AdyutaClient.outcomeFromAnswerJson(<String, dynamic>{
        'status': 'ok',
        'answer': "I don't have enough information in the retrieved context "
            'to answer this question. (The closest passage scored 0.512, below '
            'the relevance floor of 0.55; it was not used.)',
        'answer_model': 'none',
        'answer_placeholder': false,
        'retrieval_info': <String, dynamic>{
          'retrieved_count': 5,
          'selected_count': 0,
          'dropped_below_floor': 5,
          'best_score': 0.512,
        },
      });

      expect(o, isA<Declined>());
      // The server's own wording is still shown, just labelled as a refusal.
      expect(o.displayText, contains('relevance floor'));
    });

    test('static safety content is an answer even with no model', () {
      final ChatOutcome o = AdyutaClient.outcomeFromAnswerJson(<String, dynamic>{
        'status': 'ok',
        'answer': 'For a snake bite: keep the limb still and call 108.',
        'answer_model': 'none',
        'answer_placeholder': false,
        'retrieval_info': <String, dynamic>{
          'selected_count': 0,
          'min_score_applied': null,
          'safety_static': true,
        },
      });

      expect(o, isA<Answered>(),
          reason: 'a safety reply must never be mistaken for a refusal');
    });

    test('offline router template counts as a real answer', () {
      final ChatOutcome o = AdyutaClient.outcomeFromAnswerJson(<String, dynamic>{
        'status': 'ok',
        'answer': '[LOCAL] Advisory (offline): limited to cached context.',
        'answer_model': 'local-lite',
        'answer_placeholder': false,
      });
      expect(o, isA<Answered>());
    });
  });

  group('metaFromAnswerJson', () {
    test('online answer surfaces score, floor and sources', () {
      final MessageMeta m = AdyutaClient.metaFromAnswerJson(<String, dynamic>{
        'answer_model': 'groq:openai/gpt-oss-120b',
        'generation_latency_ms': 1200,
        'retrieval_info': <String, dynamic>{
          'retrieved_count': 5,
          'selected_count': 5,
          'dropped_below_floor': 2,
          'best_score': 0.6012,
          'min_score_applied': 0.55,
          'grounding': <String, dynamic>{
            'thin': false,
            'note': null,
          },
        },
        'source_references': <dynamic>[
          <String, dynamic>{
            'chunk_id': 'ADY-1-c00001',
            'source_title': 'Tomato production guide',
            'source_url': null,
            'source_url_recorded': false,
            'heading_path': <dynamic>['Disease management'],
          },
        ],
      }, isRouter: false);

      expect(m.model, 'groq:openai/gpt-oss-120b');
      expect(m.generationLatencyMs, 1200);
      expect(m.bestScore, closeTo(0.6012, 1e-9));
      expect(m.minScoreApplied, 0.55);
      expect(m.hasFloor, isTrue);
      expect(m.droppedBelowFloor, 2);
      expect(m.sources.single.chunkId, 'ADY-1-c00001');
      expect(m.sources.single.label, 'Tomato production guide');
      expect(m.sources.single.urlRecorded, isFalse);
      expect(m.sources.single.url, isNull);
    });

    test('safety exemption reports a present-but-null floor', () {
      final MessageMeta m = AdyutaClient.metaFromAnswerJson(<String, dynamic>{
        'answer_model': 'none',
        'retrieval_info': <String, dynamic>{
          'retrieved_count': 7,
          'selected_count': 0,
          'min_score_applied': null,
        },
      }, isRouter: false);

      expect(m.hasFloor, isTrue, reason: 'the key was sent, so a floor policy exists');
      expect(m.minScoreApplied, isNull, reason: 'null is the safety exemption');
    });

    test('offline reply has no floor at all and says it is offline', () {
      final MessageMeta m = AdyutaClient.metaFromAnswerJson(<String, dynamic>{
        'mode': 'offline',
        'via': 'local:symptom_checker',
        'intent': 'symptom_checker',
        'answer_model': 'local-lite',
        'retrieval_info': <String, dynamic>{
          'retrieved_count': 0,
          'selected_count': 0,
          'offline': true,
        },
      }, isRouter: true);

      expect(m.mode, 'offline');
      expect(m.via, 'local:symptom_checker');
      expect(m.hasFloor, isFalse);
      expect(m.deliveryNotice, contains('offline'));
    });

    test('offline advisory language is carried, not assumed from the question', () {
      final MessageMeta m = AdyutaClient.metaFromAnswerJson(<String, dynamic>{
        'mode': 'offline',
        'locale': 'ta',
        'answer_model': 'local-lite',
        'retrieval_info': <String, dynamic>{'offline': true},
        'offline_lite': <String, dynamic>{
          'available': true,
          'artifact_version': 'v1',
          'source': 'rule:urgent_keywords',
          'triage': 'urgent',
          'advisory_locale': 'en',
        },
      }, isRouter: true);

      expect(m.locale, 'ta', reason: 'the question was Tamil');
      expect(m.advisoryLocale, 'en',
          reason: 'the advisory served was English and the UI must say so');
    });

    test('online replies carry no advisory locale', () {
      final MessageMeta m = AdyutaClient.metaFromAnswerJson(<String, dynamic>{
        'answer_model': 'groq:x',
        'retrieval_info': <String, dynamic>{'offline': false},
      }, isRouter: true);

      expect(m.advisoryLocale, isNull);
    });

    test('router degradation is reported, not hidden', () {
      final MessageMeta m = AdyutaClient.metaFromAnswerJson(<String, dynamic>{
        'mode': 'offline',
        'answer_model': 'local-lite',
        'error': 'connection reset',
        'retrieval_info': <String, dynamic>{'offline': true},
      }, isRouter: true);

      expect(m.deliveryNotice, contains('degraded'));
      expect(m.deliveryNotice, contains('connection reset'));
    });

    test('thin grounding note is carried through', () {
      final MessageMeta m = AdyutaClient.metaFromAnswerJson(<String, dynamic>{
        'answer_model': 'groq:x',
        'retrieval_info': <String, dynamic>{
          'retrieved_count': 1,
          'selected_count': 1,
          'min_score_applied': 0.55,
          'grounding': <String, dynamic>{
            'thin': true,
            'note': 'Treat this as a pointer to the source.',
          },
        },
      }, isRouter: false);

      expect(m.thin, isTrue);
      expect(m.thinNote, 'Treat this as a pointer to the source.');
    });
  });

  group('message persistence', () {
    test('a message with meta survives a JSON round trip', () {
      final ChatMessage original = ChatMessage(
        id: 'a1',
        role: ChatRole.assistant,
        text: 'Answer',
        at: DateTime.parse('2026-09-30T10:00:00Z'),
        kind: MessageKind.placeholder,
        notice: 'no model',
        meta: const MessageMeta(
          model: 'dummy',
          minScoreApplied: 0.55,
          hasFloor: true,
          sources: <SourceRef>[SourceRef(chunkId: 'c1', title: 'T')],
        ),
      );

      final ChatMessage restored = ChatMessage.fromJson(original.toJson());
      expect(restored.kind, MessageKind.placeholder);
      expect(restored.notice, 'no model');
      expect(restored.meta?.model, 'dummy');
      expect(restored.meta?.sources.single.chunkId, 'c1');
      expect(restored.at, original.at);
    });
  });
}
