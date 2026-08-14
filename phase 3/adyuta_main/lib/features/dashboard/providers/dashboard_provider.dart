import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:adyuta_main/features/authentication/providers/auth_provider.dart';

class DashboardData {
  final Map<String, dynamic>? profile;
  final List<Map<String, dynamic>> domains;

  DashboardData({this.profile, required this.domains});
}

class ActivityLogEntry {
  final String id;
  final String domain;
  final String message;
  final DateTime createdAt;

  ActivityLogEntry({
    required this.id,
    required this.domain,
    required this.message,
    required this.createdAt,
  });

  factory ActivityLogEntry.fromMap(Map<String, dynamic> map) {
    return ActivityLogEntry(
      id: map['id'],
      domain: map['domain'],
      message: map['message'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardData?>>((ref) {
  final authState = ref.watch(authStateProvider);
  final userId = authState.valueOrNull?.session?.user.id;
  
  return DashboardNotifier(userId);
});

class DashboardNotifier extends StateNotifier<AsyncValue<DashboardData?>> {
  final String? userId;
  final _supabase = Supabase.instance.client;

  DashboardNotifier(this.userId) : super(const AsyncValue.loading()) {
    if (userId != null) {
      _fetchDashboard();
    } else {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> _fetchDashboard() async {
    try {
      state = const AsyncValue.loading();
      
      final response = await _supabase.rpc('get_home_dashboard', params: {
        'p_user_id': userId,
      });

      if (response != null) {
        final profile = response['profile'] as Map<String, dynamic>?;
        final domainsList = response['domains'] as List<dynamic>? ?? [];
        
        final domains = domainsList.map((e) => e as Map<String, dynamic>).toList();

        state = AsyncValue.data(DashboardData(
          profile: profile,
          domains: domains,
        ));
      } else {
        state = AsyncValue.data(DashboardData(domains: []));
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    if (userId != null) {
      await _fetchDashboard();
    }
  }
}

// Realtime Feed Provider
final activityFeedProvider = StreamProvider.autoDispose<List<ActivityLogEntry>>((ref) {
  final authState = ref.watch(authStateProvider);
  final userId = authState.valueOrNull?.session?.user.id;
  
  if (userId == null) return Stream.value([]);

  final supabase = Supabase.instance.client;
  
  // Create a StreamController that yields the initial data and updates on realtime events
  final controller = StreamController<List<ActivityLogEntry>>();
  List<ActivityLogEntry> currentLogs = [];

  // 1. Fetch initial load
  supabase
      .from('activity_log')
      .select()
      .eq('user_id', userId)
      .order('created_at', ascending: false)
      .limit(5)
      .then((data) {
        currentLogs = data.map((e) => ActivityLogEntry.fromMap(e)).toList();
        controller.add(currentLogs);
      }).catchError((e) {
        controller.addError(e);
      });

  // 2. Subscribe to realtime inserts
  final channel = supabase.channel('public:activity_log');
  channel.onPostgresChanges(
    event: PostgresChangeEvent.insert,
    schema: 'public',
    table: 'activity_log',
    filter: PostgresChangeFilter(
      type: PostgresChangeFilterType.eq,
      column: 'user_id',
      value: userId,
    ),
    callback: (payload) {
      final newEntry = ActivityLogEntry.fromMap(payload.newRecord);
      currentLogs = [newEntry, ...currentLogs];
      if (currentLogs.length > 10) currentLogs.removeLast(); // Keep feed bounded
      controller.add(currentLogs);
    }
  ).subscribe();

  ref.onDispose(() {
    supabase.removeChannel(channel);
    controller.close();
  });

  return controller.stream;
});
