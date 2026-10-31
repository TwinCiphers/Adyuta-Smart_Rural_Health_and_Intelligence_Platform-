import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/chat_message.dart';

import 'outcome.dart';

/// A parsed reply plus every honesty field the server sent with it.
class Reply {
  const Reply({
    required this.outcome,
    required this.meta,
    required this.raw,
  });

  final ChatOutcome outcome;
  final MessageMeta meta;

  /// The untouched response body, so the UI can offer "show raw JSON" and
  /// nothing about the contract is hidden from the person testing it.
  final Map<String, dynamic> raw;

  /// The text to store on the message: the real answer, or empty when the turn
  /// carries only a notice.
  String get storedText => outcome.displayText ?? '';
}

/// Coarse service status for the strip at the top of the chat.
class ServiceStatus {
  const ServiceStatus({
    required this.reachable,
    this.adapter,
    this.online,
    this.vectors,
    this.cropAccuracy,
    this.cropModel,
    this.error,
  });

  final bool reachable;
  final String? adapter;
  final bool? online;
  final int? vectors;
  final double? cropAccuracy;
  final String? cropModel;
  final String? error;
}

class AdyutaClient {
  AdyutaClient({http.Client? client, this.timeout = const Duration(seconds: 60)})
      : _client = client ?? http.Client();

  final http.Client _client;
  final Duration timeout;

  Uri _uri(String baseUrl, String path, [Map<String, String>? query]) =>
      Uri.parse('$baseUrl$path').replace(queryParameters: query);

  /// `POST /rag/answer` or `POST /router/route`, depending on [settings].
  ///
  /// [history] is sent as the caller-held alternative to server memory. The API
  /// ignores it when the session already holds turns, so sending both is safe.
  Future<Reply> ask({
    required AppSettings settings,
    required String query,
    required String sessionId,
    required List<ChatTurn> history,
  }) async {
    final Map<String, dynamic> body = buildAskBody(
      settings: settings,
      query: query,
      sessionId: sessionId,
      history: history,
    );

    final String path =
        settings.route == AskRoute.router ? '/router/route' : '/rag/answer';

    try {
      final http.Response res = await _client
          .post(
            _uri(settings.baseUrl, path),
            headers: const <String, String>{'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(timeout);
      return _parseReply(res, isRouter: settings.route == AskRoute.router);
    } catch (e) {
      return Reply(
        outcome: Failed(
          message: 'Could not reach the ADYUTA server at ${settings.baseUrl}. '
              'Check that it is running, and that CORS is enabled on it. ($e)',
          networkError: true,
        ),
        meta: const MessageMeta(),
        raw: <String, dynamic>{},
      );
    }
  }

  /// The request body for one question. Pure, so the field-level contract of
  /// each route can be tested without a server: `force` and `locale` exist only
  /// on `/router/route`, and `/rag/answer` would reject neither but means
  /// nothing by them.
  static Map<String, dynamic> buildAskBody({
    required AppSettings settings,
    required String query,
    required String sessionId,
    required List<ChatTurn> history,
  }) {
    final bool isRouter = settings.route == AskRoute.router;
    return <String, dynamic>{
      'query': query,
      'top_k': settings.topK,
      if (settings.domain != null) 'filter_domain': settings.domain,
      // Only the direct route understands multi-turn state; the router takes
      // the same fields, so both are populated either way.
      'session_id': sessionId,
      // Sent even when it is `auto`, so the raw JSON shows exactly what was
      // asked for rather than leaving the tester to infer the default.
      if (isRouter) 'force': forceModeName(settings.force),
      if (isRouter && settings.locale != null) 'locale': settings.locale,
      if (history.isNotEmpty)
        'history': history
            .map((ChatTurn t) => <String, String>{'role': t.role, 'content': t.content})
            .toList(),
    };
  }

  /// `POST /voice/ask`.
  ///
  /// The endpoint requires an audio file — its `local_transcript` fallback is
  /// only honoured when *the server itself* cannot reach the network, so the app
  /// must not pretend a typed transcript is transcription.
  Future<Reply> askVoice({
    required AppSettings settings,
    required Uint8List audioBytes,
    required String filename,
    String? language,
  }) =>
      _voice(settings: settings, audioBytes: audioBytes, filename: filename, language: language);

  Future<Reply> transcribeOnly({
    required AppSettings settings,
    required Uint8List audioBytes,
    required String filename,
    String? language,
  }) =>
      _voice(
        settings: settings,
        audioBytes: audioBytes,
        filename: filename,
        language: language,
        path: '/voice/transcribe',
      );

  Future<Reply> _voice({
    required AppSettings settings,
    required Uint8List audioBytes,
    required String filename,
    String? language,
    String path = '/voice/ask',
  }) async {
    try {
      final http.MultipartRequest req =
          http.MultipartRequest('POST', _uri(settings.baseUrl, path));
      // No explicit content type: the API accepts application/octet-stream,
      // and staying generic keeps this working for webm/opus, wav and mp4.
      req.files.add(http.MultipartFile.fromBytes('audio', audioBytes, filename: filename));
      if (language != null && language.isNotEmpty) req.fields['language'] = language;
      if (path == '/voice/ask') {
        req.fields['force'] = forceModeName(settings.force);
        req.fields['top_k'] = '${settings.topK}';
      }

      final http.StreamedResponse streamed = await _client.send(req).timeout(timeout);
      final http.Response res = await http.Response.fromStream(streamed);
      return _parseVoice(res);
    } catch (e) {
      return Reply(
        outcome: Failed(
          message: 'Voice upload failed. Check the server is reachable and the '
              'microphone permission is granted. ($e)',
          networkError: true,
        ),
        meta: const MessageMeta(),
        raw: <String, dynamic>{},
      );
    }
  }

  Future<Reply> detectDisease({
    required AppSettings settings,
    required Uint8List imageBytes,
    required String filename,
  }) async {
    try {
      final http.MultipartRequest req =
          http.MultipartRequest('POST', _uri(settings.baseUrl, '/disease/detect'));
      req.files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: filename));

      final http.StreamedResponse streamed = await _client.send(req).timeout(timeout);
      final http.Response res = await http.Response.fromStream(streamed);

      if (res.statusCode != 200) {
        return Reply(
          outcome: Failed(
            message: 'Disease detection failed: ${res.statusCode}. ${_detail(res)}',
            statusCode: res.statusCode,
          ),
          meta: const MessageMeta(),
          raw: <String, dynamic>{},
        );
      }

      final Map<String, dynamic> data = _decode(res);
      final String condition = data['condition'] as String? ?? 'Unknown';
      final String crop = data['crop'] as String? ?? 'Plant';
      final double conf = (data['confidence'] as num?)?.toDouble() ?? 0.0;
      final String advice = data['advice_hint'] as String? ?? '';
      
      String text;
      if (data['predicted_class'] == 'Unrecognized Image') {
        text = '⚠️ I am not confident this is a plant leaf (Confidence: ${(conf * 100).toStringAsFixed(1)}%). $advice';
      } else if (data['low_confidence'] == true) {
        text = '⚠️ I am not very confident about this image (Confidence: ${(conf * 100).toStringAsFixed(1)}%). It might be **$condition** on a $crop leaf, but please ensure you took a clear picture of a single plant leaf.\n\n$advice';
      } else {
        text = 'I detected **$condition** on this $crop leaf (Confidence: ${(conf * 100).toStringAsFixed(1)}%).\n\n$advice';
      }

      return Reply(
        outcome: Answered(text),
        meta: MessageMeta(
          model: 'plant_disease.tflite',
          generationLatencyMs: (data['execution_time_ms'] as num?)?.toInt(),
        ),
        raw: data,
      );
    } catch (e) {
      return Reply(
        outcome: Failed(
          message: 'Failed to upload image. Check network connection. ($e)',
          networkError: true,
        ),
        meta: const MessageMeta(),
        raw: <String, dynamic>{},
      );
    }
  }

  /// `GET /capabilities` + `GET /router/health` for the status strip.
  Future<ServiceStatus> status(AppSettings settings) async {
    try {
      final List<http.Response> res = await Future.wait(<Future<http.Response>>[
        _client.get(_uri(settings.baseUrl, '/capabilities')).timeout(timeout),
        _client.get(_uri(settings.baseUrl, '/router/health')).timeout(timeout),
      ]);

      String? adapter;
      bool? online;
      int? vectors;
      double? cropAccuracy;
      String? cropModel;

      if (res[1].statusCode == 200) {
        final Map<String, dynamic> health = _decode(res[1]);
        online = health['online'] as bool?;
        adapter = health['rag_model'] as String?;
      }
      if (res[0].statusCode == 200) {
        final Map<String, dynamic> caps = _decode(res[0]);
        final Map<String, dynamic>? prov =
            caps['model_provenance'] as Map<String, dynamic>?;
        final Map<String, dynamic>? crop = prov?['crop_disease'] as Map<String, dynamic>?;
        final Map<String, dynamic>? emb = prov?['embedding'] as Map<String, dynamic>?;
        final Map<String, dynamic>? llm = prov?['llm'] as Map<String, dynamic>?;
        vectors = (emb?['vector_count'] as num?)?.toInt();
        cropAccuracy = (crop?['test_accuracy'] as num?)?.toDouble();
        cropModel = crop?['architecture'] as String?;
        adapter ??= llm?['serving_adapter'] as String?;
      }
      return ServiceStatus(
        reachable: true,
        adapter: adapter,
        online: online,
        vectors: vectors,
        cropAccuracy: cropAccuracy,
        cropModel: cropModel,
      );
    } catch (e) {
      return ServiceStatus(reachable: false, error: '$e');
    }
  }

  // ------------------------------------------------------------------ parsing

  static Map<String, dynamic> _decode(http.Response res) {
    final Object? decoded = jsonDecode(utf8.decode(res.bodyBytes));
    return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
  }

  /// Pure function so the contract is testable without a live server.
  static Reply _parseReply(http.Response res, {required bool isRouter}) {
    if (res.statusCode != 200) {
      return Reply(
        outcome: Failed(
          message: 'Server returned status ${res.statusCode}. '
              '${_detail(res)}'.trim(),
          statusCode: res.statusCode,
        ),
        meta: const MessageMeta(),
        raw: <String, dynamic>{},
      );
    }

    final Map<String, dynamic> data = _decode(res);
    return Reply(
      outcome: outcomeFromAnswerJson(data),
      meta: metaFromAnswerJson(data, isRouter: isRouter),
      raw: data,
    );
  }

  static Reply _parseVoice(http.Response res) {
    if (res.statusCode != 200) {
      return Reply(
        outcome: Failed(
          message: 'Voice request returned status ${res.statusCode}. '
              '${_detail(res)}'.trim(),
          statusCode: res.statusCode,
        ),
        meta: const MessageMeta(),
        raw: <String, dynamic>{},
      );
    }

    final Map<String, dynamic> data = _decode(res);
    final Map<String, dynamic>? transcription =
        data['transcription'] as Map<String, dynamic>?;
    final Map<String, dynamic>? answer = data['answer'] as Map<String, dynamic>?;
    final Map<String, dynamic>? answerMeta =
        data['answer_meta'] as Map<String, dynamic>?;

    final Map<String, dynamic> tmeta = (transcription?['meta'] as Map<String, dynamic>?) ??
        <String, dynamic>{};
    final String transcriptText = (transcription?['text'] as String? ?? '').trim();
    final bool transcriptPlaceholder = transcription?['placeholder'] == true;
    final bool isAsr = tmeta['is_asr'] != false;

    // A transcript placeholder, or no nested answer at all, means there is
    // nothing genuine to show. Never render the placeholder string.
    if (transcriptPlaceholder || answer == null) {
      final String reason =
          (answerMeta?['reason'] as String?) ?? (tmeta['reason'] as String?) ?? 'unknown';
      return Reply(
        outcome: Placeholder('whisper:$reason'),
        meta: MessageMeta(
          transcript: transcriptPlaceholder ? null : transcriptText,
          transcriptSource: tmeta['transcript_source'] as String?,
          isAsr: isAsr,
          isVoiceTurn: true,
          totalLatencyMs: (data['latency_ms'] as num?)?.toInt(),
          deliveryNotice: reason == 'transcription_unavailable'
              ? 'The server reported no transcription for this audio.'
              : null,
        ),
        raw: data,
      );
    }

    final MessageMeta base = metaFromAnswerJson(answer, isRouter: true);
    return Reply(
      outcome: outcomeFromAnswerJson(answer),
      meta: MessageMeta(
        model: base.model,
        mode: base.mode,
        via: base.via,
        intent: base.intent,
        locale: base.locale,
        tier: base.tier,
        advisoryLocale: base.advisoryLocale,
        generationLatencyMs: base.generationLatencyMs,
        totalLatencyMs: (data['latency_ms'] as num?)?.toInt() ?? base.totalLatencyMs,
        retrievedCount: base.retrievedCount,
        selectedCount: base.selectedCount,
        droppedBelowFloor: base.droppedBelowFloor,
        bestScore: base.bestScore,
        minScoreApplied: base.minScoreApplied,
        hasFloor: base.hasFloor,
        thin: base.thin,
        thinNote: base.thinNote,
        safetyStatic: base.safetyStatic,
        sources: base.sources,
        transcript: transcriptText.isEmpty ? null : transcriptText,
        transcriptSource: (tmeta['transcript_source'] as String?) ??
            (transcriptText.isEmpty ? null : 'server_asr'),
        isAsr: isAsr,
        isVoiceTurn: true,
        deliveryNotice: base.deliveryNotice,
      ),
      raw: data,
    );
  }

  /// The order here is the safety property: the placeholder flag is checked
  /// BEFORE the answer text, so a placeholder can never be rendered as advice.
  static ChatOutcome outcomeFromAnswerJson(Map<String, dynamic> data) {
    final String status = data['status'] as String? ?? 'ok';
    final bool isPlaceholder = data['answer_placeholder'] == true;
    final String model = data['answer_model'] as String? ?? 'unknown';

    if (status == 'empty_retrieval') return const Abstained();
    if (isPlaceholder) return Placeholder(model);

    final String text = (data['answer'] as String? ?? '').trim();
    if (text.isEmpty) return const Abstained();

    // A refusal is not always an `empty_retrieval` status: when every retrieved
    // passage falls below the floor, the API still returns `status: ok` with no
    // model behind it (`answer_model: none`) and 0 passages kept. Without this
    // the refusal would render exactly like a generated answer.
    final Map<String, dynamic>? ri = data['retrieval_info'] as Map<String, dynamic>?;
    final bool safetyStatic = ri?['safety_static'] == true;
    final int? selected = (ri?['selected_count'] as num?)?.toInt();
    final bool noModel = model.isEmpty || model == 'none' || model == 'unknown';
    if (!safetyStatic && noModel && selected == 0) return Declined(text);

    return Answered(text);
  }

  static MessageMeta metaFromAnswerJson(
    Map<String, dynamic> data, {
    required bool isRouter,
  }) {
    final Map<String, dynamic>? ri = data['retrieval_info'] as Map<String, dynamic>?;
    final Map<String, dynamic>? grounding = ri?['grounding'] as Map<String, dynamic>?;
    final Map<String, dynamic>? offlineLite = data['offline_lite'] as Map<String, dynamic>?;
    final bool offline = ri?['offline'] == true;

    // `min_score_applied` is present-but-null for safety, which is the deliberate
    // exemption from the relevance floor. A missing key means the floor was not
    // applicable at all (the offline templates never retrieve).
    final bool hasFloorKey = ri != null && ri.containsKey('min_score_applied');

    return MessageMeta(
      model: data['answer_model'] as String?,
      mode: isRouter ? data['mode'] as String? : null,
      via: isRouter ? data['via'] as String? : null,
      intent: isRouter ? data['intent'] as String? : null,
      locale: isRouter ? data['locale'] as String? : null,
      tier: isRouter ? data['tier'] as String? : null,
      advisoryLocale:
          isRouter ? (offlineLite?['advisory_locale'] as String?) : null,
      generationLatencyMs: (data['generation_latency_ms'] as num?)?.toInt(),
      totalLatencyMs: (data['latency_ms'] as num?)?.toInt(),
      retrievedCount: (ri?['retrieved_count'] as num?)?.toInt(),
      selectedCount: (ri?['selected_count'] as num?)?.toInt(),
      droppedBelowFloor: (ri?['dropped_below_floor'] as num?)?.toInt(),
      bestScore: (ri?['best_score'] as num?)?.toDouble(),
      minScoreApplied: (ri?['min_score_applied'] as num?)?.toDouble(),
      hasFloor: hasFloorKey,
      thin: grounding?['thin'] as bool?,
      thinNote: grounding?['note'] as String?,
      safetyStatic: ri?['safety_static'] == true,
      sources: (data['source_references'] as List<dynamic>?)
              ?.map((dynamic e) => _sourceFromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SourceRef>[],
      deliveryNotice: _deliveryNotice(data, offline: offline),
    );
  }

  static String? _deliveryNotice(Map<String, dynamic> data, {required bool offline}) {
    // The router degrades to offline instead of returning a 500; when that
    // happens it records the reason in `error`. Saying so beats letting the
    // reader assume the offline template was the intended reply.
    final String? error = data['error'] as String?;
    if (error != null && error.trim().isNotEmpty) {
      return 'Online RAG failed and the router degraded to offline: $error';
    }
    if (offline) return 'Answered from the offline path.';
    return null;
  }

  static SourceRef _sourceFromJson(Map<String, dynamic> json) => SourceRef(
        chunkId: json['chunk_id'] as String? ?? '',
        title: json['source_title'] as String?,
        filename: json['source_filename'] as String?,
        headingPath: (json['heading_path'] as List<dynamic>?)
                ?.map((dynamic e) => e.toString())
                .toList() ??
            const <String>[],
        url: json['source_url'] as String?,
        urlRecorded: json['source_url_recorded'] as bool? ?? false,
      );

  static String _detail(http.Response res) {
    try {
      final Map<String, dynamic> data = _decode(res);
      final Object? detail = data['detail'];
      if (detail != null) return detail.toString();
    } catch (_) {
      // Fall through to the generic status message.
    }
    return '';
  }
}

/// One prior turn sent to the API as the caller-held history.
class ChatTurn {
  const ChatTurn({required this.role, required this.content});

  final String role;
  final String content;
}
