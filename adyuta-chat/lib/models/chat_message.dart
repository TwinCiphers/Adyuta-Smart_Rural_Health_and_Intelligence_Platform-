/// One cited passage the answer rests on.
class SourceRef {
  const SourceRef({
    required this.chunkId,
    this.title,
    this.filename,
    this.headingPath = const <String>[],
    this.url,
    this.urlRecorded = false,
    this.domain,
  });

  final String chunkId;
  final String? title;
  final String? filename;
  final List<String> headingPath;
  final String? url;

  /// True only when the knowledge base actually recorded a URL. A null URL is
  /// "not recorded", never a reason to invent a link.
  final bool urlRecorded;
  final String? domain;

  String get label {
    final String t = title?.trim() ?? '';
    if (t.isNotEmpty) return t;
    final String f = filename?.trim() ?? '';
    if (f.isNotEmpty) return f;
    return chunkId;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'chunkId': chunkId,
        'title': title,
        'filename': filename,
        'headingPath': headingPath,
        'url': url,
        'urlRecorded': urlRecorded,
        'domain': domain,
      };

  static SourceRef fromJson(Map<String, dynamic> json) => SourceRef(
        chunkId: json['chunkId'] as String? ?? '',
        title: json['title'] as String?,
        filename: json['filename'] as String?,
        headingPath: (json['headingPath'] as List<dynamic>?)
                ?.map((dynamic e) => e.toString())
                .toList() ??
            const <String>[],
        url: json['url'] as String?,
        urlRecorded: json['urlRecorded'] as bool? ?? false,
        domain: json['domain'] as String?,
      );
}

/// Everything the UI shows underneath an answer: which model replied, how well
/// grounded it was, and whether the answer is thin. All of it comes from the
/// server; nothing here is inferred.
class MessageMeta {
  const MessageMeta({
    this.model,
    this.mode,
    this.via,
    this.intent,
    this.locale,
    this.tier,
    this.advisoryLocale,
    this.generationLatencyMs,
    this.totalLatencyMs,
    this.retrievedCount,
    this.selectedCount,
    this.droppedBelowFloor,
    this.bestScore,
    this.minScoreApplied,
    this.hasFloor = true,
    this.thin,
    this.thinNote,
    this.safetyStatic = false,
    this.sources = const <SourceRef>[],
    this.transcript,
    this.transcriptSource,
    this.isAsr,
    this.isVoiceTurn = false,
    this.deliveryNotice,
  });

  final String? model;

  /// `online` or `offline` — router replies only.
  final String? mode;

  /// e.g. `rag:groq:openai/gpt-oss-120b` or `local:symptom_checker`.
  final String? via;
  final String? intent;
  final String? locale;
  final String? tier;

  /// The language an offline advisory is actually written in. On a router reply
  /// this can differ from [locale] — a Tamil question whose advisory only exists
  /// in English reports `locale: ta` and `advisoryLocale: en` here, so the UI
  /// never implies the villager received Tamil text it did not receive.
  final String? advisoryLocale;
  final int? generationLatencyMs;
  final int? totalLatencyMs;
  final int? retrievedCount;
  final int? selectedCount;
  final int? droppedBelowFloor;
  final double? bestScore;

  /// The relevance floor actually applied. Null together with [hasFloor] false
  /// means no floor applies at all — which is the deliberate safety exemption.
  final double? minScoreApplied;
  final bool hasFloor;
  final bool? thin;
  final String? thinNote;

  /// True when the reply is the static safety content, which is policy-
  /// forbidden from reaching a language model. It explains an `answer_model`
  /// of `none` that is not a refusal.
  final bool safetyStatic;
  final List<SourceRef> sources;

  /// Voice turns only.
  final String? transcript;
  final String? transcriptSource;
  final bool? isAsr;

  /// True when the turn was produced through the voice endpoint, so the UI can
  /// label the transcript as server-side ASR or device-supplied text.
  final bool isVoiceTurn;

  /// Shown when the reply arrived by a degraded path (e.g. the router fell back
  /// from online to offline because RAG threw).
  final String? deliveryNotice;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'model': model,
        'mode': mode,
        'via': via,
        'intent': intent,
        'locale': locale,
        'tier': tier,
        'advisoryLocale': advisoryLocale,
        'generationLatencyMs': generationLatencyMs,
        'totalLatencyMs': totalLatencyMs,
        'retrievedCount': retrievedCount,
        'selectedCount': selectedCount,
        'droppedBelowFloor': droppedBelowFloor,
        'bestScore': bestScore,
        'minScoreApplied': minScoreApplied,
        'hasFloor': hasFloor,
        'thin': thin,
        'thinNote': thinNote,
        'safetyStatic': safetyStatic,
        'sources': sources.map((SourceRef s) => s.toJson()).toList(),
        'transcript': transcript,
        'transcriptSource': transcriptSource,
        'isAsr': isAsr,
        'isVoiceTurn': isVoiceTurn,
        'deliveryNotice': deliveryNotice,
      };

  static MessageMeta fromJson(Map<String, dynamic> json) => MessageMeta(
        model: json['model'] as String?,
        mode: json['mode'] as String?,
        via: json['via'] as String?,
        intent: json['intent'] as String?,
        locale: json['locale'] as String?,
        tier: json['tier'] as String?,
        advisoryLocale: json['advisoryLocale'] as String?,
        generationLatencyMs: (json['generationLatencyMs'] as num?)?.toInt(),
        totalLatencyMs: (json['totalLatencyMs'] as num?)?.toInt(),
        retrievedCount: (json['retrievedCount'] as num?)?.toInt(),
        selectedCount: (json['selectedCount'] as num?)?.toInt(),
        droppedBelowFloor: (json['droppedBelowFloor'] as num?)?.toInt(),
        bestScore: (json['bestScore'] as num?)?.toDouble(),
        minScoreApplied: (json['minScoreApplied'] as num?)?.toDouble(),
        hasFloor: json['hasFloor'] as bool? ?? true,
        thin: json['thin'] as bool?,
        thinNote: json['thinNote'] as String?,
        safetyStatic: json['safetyStatic'] as bool? ?? false,
        sources: (json['sources'] as List<dynamic>?)
                ?.map((dynamic e) => SourceRef.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const <SourceRef>[],
        transcript: json['transcript'] as String?,
        transcriptSource: json['transcriptSource'] as String?,
        isAsr: json['isAsr'] as bool?,
        isVoiceTurn: json['isVoiceTurn'] as bool? ?? false,
        deliveryNotice: json['deliveryNotice'] as String?,
      );
}

enum ChatRole { user, assistant }

/// How an assistant turn should be rendered. Persisted so a reloaded
/// conversation renders exactly as it did when it was answered.
enum MessageKind {
  answered,
  declined,
  abstained,
  placeholder,
  failed,
  deviceTranscript,
}

MessageKind kindFromName(String? name) => MessageKind.values.firstWhere(
      (MessageKind k) => k.name == name,
      orElse: () => MessageKind.answered,
    );

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.at,
    this.kind = MessageKind.answered,
    this.notice = '',
    this.meta,
  });

  final String id;
  final ChatRole role;
  final String text;
  final DateTime at;
  final MessageKind kind;

  /// Explanation rendered instead of [text] when the turn carries no real
  /// answer (abstention, placeholder, failure).
  final String notice;
  final MessageMeta? meta;

  bool get isUser => role == ChatRole.user;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'role': role.name,
        'text': text,
        'at': at.toIso8601String(),
        'kind': kind.name,
        'notice': notice,
        'meta': meta?.toJson(),
      };

  static ChatMessage fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String? ?? '',
        role: json['role'] == 'user' ? ChatRole.user : ChatRole.assistant,
        text: json['text'] as String? ?? '',
        at: DateTime.tryParse(json['at'] as String? ?? '') ?? DateTime.now(),
        kind: kindFromName(json['kind'] as String?),
        notice: json['notice'] as String? ?? '',
        meta: json['meta'] is Map<String, dynamic>
            ? MessageMeta.fromJson(json['meta'] as Map<String, dynamic>)
            : null,
      );
}
