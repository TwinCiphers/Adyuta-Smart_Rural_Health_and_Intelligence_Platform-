import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:adyuta_main/features/authentication/providers/auth_provider.dart';

class DashboardData {
  final Map<String, dynamic>? profile;
  final List<Map<String, dynamic>> domains;
  final bool isOffline;
  DashboardData({this.profile, required this.domains, this.isOffline = false});
}

class ActivityLogEntry {
  final String id;
  final String domain;
  final String message;
  final DateTime createdAt;

  ActivityLogEntry({
    required this.id, required this.domain, required this.message, required this.createdAt,
  });

  factory ActivityLogEntry.fromMap(Map<String, dynamic> map) {
    return ActivityLogEntry(
      id: map['id'].toString(),
      domain: map['domain'] ?? 'general',
      message: map['message'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? map['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

// ─── Offline seed data ─────────────────────────────────────────────────────

DashboardData _offlineDashboard(AppUser? user) => DashboardData(
  isOffline: true,
  profile: {
    'display_name': user?.name ?? 'Citizen User',
    'email': user?.email ?? '',
  },
  domains: [
    {'domain': 'health', 'label': 'Health', 'data': {'nearestFacility': 'PHC — Offline Mode', 'status': 'cached'}},
    {'domain': 'agriculture', 'label': 'Agriculture', 'data': {'cropAdvisory': 'Offline mode — last sync data shown'}},
    {'domain': 'safety', 'label': 'Safety', 'data': {'emergencyContacts': ['112', '100', '108']}},
    {'domain': 'education', 'label': 'Education', 'data': {'status': 'Offline mode'}},
    {'domain': 'governance', 'label': 'Governance', 'data': {'status': 'Schemes cached locally'}},
  ],
);

List<ActivityLogEntry> _offlineFeed() => [
  ActivityLogEntry(id: 'off1', domain: 'health', message: '📶 Offline mode — last cached activity', createdAt: DateTime.now()),
  ActivityLogEntry(id: 'off2', domain: 'agriculture', message: '🌾 Crop advisory available offline', createdAt: DateTime.now().subtract(const Duration(hours: 1))),
  ActivityLogEntry(id: 'off3', domain: 'safety', message: '🛡️ Emergency contacts loaded locally', createdAt: DateTime.now().subtract(const Duration(hours: 2))),
];

// ─── Dashboard Provider ────────────────────────────────────────────────────

final dashboardProvider = StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardData?>>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.session?.user;
  final token = authState.session?.accessToken;
  return DashboardNotifier(token, user);
});

class DashboardNotifier extends StateNotifier<AsyncValue<DashboardData?>> {
  final String? token;
  final AppUser? user;
  String get _baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:3000/api';

  DashboardNotifier(this.token, this.user) : super(const AsyncValue.loading()) {
    if (token != null) {
      _fetchDashboard();
    } else {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> _fetchDashboard() async {
    try {
      state = const AsyncValue.loading();
      // Skip network for offline guest tokens
      if (token == 'offline_guest_token' || token!.startsWith('offline_')) {
        if (!mounted) return;
        state = AsyncValue.data(_offlineDashboard(user));
        return;
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/dashboard'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 10));

      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final profile = data['profile'] as Map<String, dynamic>?;
        final domainsList = data['domains'] as List<dynamic>? ?? [];
        final domains = domainsList.map((e) => e as Map<String, dynamic>).toList();
        state = AsyncValue.data(DashboardData(profile: profile, domains: domains));
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } catch (e, st) {
      if (!mounted) return;
      // Offline fallback: show cached/seed data instead of an error screen
      state = AsyncValue.data(_offlineDashboard(user));
    }
  }

  Future<void> refresh() async {
    if (token != null) await _fetchDashboard();
  }
}

// ─── Activity Feed Provider ────────────────────────────────────────────────

final activityFeedProvider = StreamProvider.autoDispose<List<ActivityLogEntry>>((ref) async* {
  final authState = ref.watch(authStateProvider);
  final token = authState.session?.accessToken;
  if (token == null) { yield []; return; }

  // Offline guest — yield seed data immediately
  if (token == 'offline_guest_token' || token.startsWith('offline_')) {
    yield _offlineFeed();
    return;
  }

  try {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:3000/api/dashboard'),
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final feed = data['feed'] as List<dynamic>? ?? [];
      yield feed.map((e) => ActivityLogEntry.fromMap(e as Map<String, dynamic>)).toList();
    } else {
      yield _offlineFeed();
    }
  } catch (_) {
    yield _offlineFeed();
  }
});

