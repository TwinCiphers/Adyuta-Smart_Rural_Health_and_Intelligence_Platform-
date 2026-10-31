import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// The default backend URL, securely loaded from .env instead of hardcoded.
String get kDefaultBaseUrl => dotenv.env['ADYUTA_BASE_URL'] ?? 'http://10.45.71.6:8000';

/// How a question is sent.
///
/// [direct] calls `POST /rag/answer` — retrieval plus generation, nothing else.
/// [router] calls `POST /router/route` — the same pipeline behind the
/// connectivity router, so the reply also carries `mode`, `intent` and `via`.
enum AskRoute { direct, router }

/// Value for the router's `force` field: whichever the user picks, so the
/// online and offline paths can both be demonstrated without unplugging
/// anything.
enum ForceMode { auto, online, offline }

String forceModeName(ForceMode m) => switch (m) {
      ForceMode.auto => 'auto',
      ForceMode.online => 'online',
      ForceMode.offline => 'offline',
    };

/// The five answer domains the API understands. `safety` is included on
/// purpose: it is the one domain whose reply is static and must never be
/// generated, so being able to select it is part of the test.
const List<String> kDomains = <String>[
  'agriculture',
  'health',
  'governance',
  'education',
  'safety',
];

/// Language hints the router accepts as `locale`. This is NOT a translation
/// feature, and the tiers are real:
///
///   tier 1 (en/kn/hi/ta) — advisories, intent keywords and the RAG glossary;
///   tier 2 (te/bn/gu/pa/ml) — script detected, but the reply comes back in
///                            English and the response says so;
///   tier 3 (mr/or/as/ur)   — no detection at all.
///
/// Pinning one of these is how the `locale`-versus-`advisory_locale` difference
/// becomes visible: a Telugu symptom question gets an English advisory, and the
/// reply's `offline_lite.advisory_locale` says `en` rather than pretending.
const List<String> kLocales = <String>[
  'en',
  'kn',
  'hi',
  'ta',
  'te',
  'bn',
  'gu',
  'pa',
  'ml',
];

class AppSettings {
  AppSettings({
    String? baseUrl,
    this.route = AskRoute.direct,
    this.force = ForceMode.auto,
    this.domain,
    this.locale,
    this.topK = 5,
    this.speakReplies = false,
  }) : baseUrl = baseUrl ?? kDefaultBaseUrl;

  String baseUrl;
  AskRoute route;
  ForceMode force;
  String? domain;

  /// Null means "let the router detect it".
  String? locale;
  int topK;
  bool speakReplies;

  static const String _key = 'adyuta_chat_settings_v1';

  Map<String, dynamic> toJson() => <String, dynamic>{
        'baseUrl': baseUrl,
        'route': route.name,
        'force': force.name,
        'domain': domain,
        'locale': locale,
        'topK': topK,
        'speakReplies': speakReplies,
      };

  static AppSettings fromJson(Map<String, dynamic> json) => AppSettings(
        baseUrl: (json['baseUrl'] as String?)?.trim().isNotEmpty == true
            ? (json['baseUrl'] as String).trim()
            : kDefaultBaseUrl,
        route: AskRoute.values.firstWhere(
          (AskRoute r) => r.name == json['route'],
          orElse: () => AskRoute.direct,
        ),
        force: ForceMode.values.firstWhere(
          (ForceMode f) => f.name == json['force'],
          orElse: () => ForceMode.auto,
        ),
        domain: json['domain'] as String?,
        locale: json['locale'] as String?,
        topK: (json['topK'] as num?)?.toInt() ?? 5,
        speakReplies: json['speakReplies'] as bool? ?? false,
      );

  static Future<AppSettings> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return AppSettings();
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return AppSettings.fromJson(decoded);
    } catch (_) {
      // A corrupt settings blob must never stop the app from starting.
    }
    return AppSettings();
  }

  Future<void> save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(toJson()));
  }
}
