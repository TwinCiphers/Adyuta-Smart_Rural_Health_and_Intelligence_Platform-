import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:adyuta_main/features/authentication/providers/auth_provider.dart';

class PreferencesData {
  final String userId;
  final String theme;
  final String language;
  final String? timezone;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool? literacyMode;

  PreferencesData({
    required this.userId,
    required this.theme,
    required this.language,
    this.timezone,
    required this.emailNotifications,
    required this.pushNotifications,
    this.literacyMode,
  });

  factory PreferencesData.fromMap(Map<String, dynamic> map) {
    return PreferencesData(
      userId: map['user_id'] as String,
      theme: map['theme'] as String? ?? 'system',
      language: map['language'] as String? ?? 'en',
      timezone: map['timezone'] as String?,
      emailNotifications: map['email_notifications'] as bool? ?? true,
      pushNotifications: map['push_notifications'] as bool? ?? true,
      literacyMode: map['literacy_mode'] as bool?,
    );
  }

  PreferencesData copyWith({
    String? theme,
    String? language,
    String? timezone,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? literacyMode,
  }) {
    return PreferencesData(
      userId: userId,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      timezone: timezone ?? this.timezone,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      literacyMode: literacyMode ?? this.literacyMode,
    );
  }
}

final preferencesProvider = StateNotifierProvider<PreferencesNotifier, AsyncValue<PreferencesData?>>((ref) {
  final authState = ref.watch(authStateProvider);
  final userId = authState.valueOrNull?.session?.user.id;
  
  return PreferencesNotifier(userId);
});

class PreferencesNotifier extends StateNotifier<AsyncValue<PreferencesData?>> {
  final String? userId;
  final _supabase = Supabase.instance.client;

  PreferencesNotifier(this.userId) : super(const AsyncValue.loading()) {
    if (userId != null) {
      _fetchPreferences();
    } else {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> _fetchPreferences() async {
    try {
      state = const AsyncValue.loading();
      final data = await _supabase
          .from('preferences')
          .select()
          .eq('user_id', userId!)
          .maybeSingle(); // maybeSingle instead of single so it handles missing rows smoothly
      
      if (data != null) {
        state = AsyncValue.data(PreferencesData.fromMap(data));
      } else {
        // If row doesn't exist, provide a default object
        state = AsyncValue.data(PreferencesData(
          userId: userId!,
          theme: 'system',
          language: 'en',
          emailNotifications: true,
          pushNotifications: true,
          literacyMode: false,
        ));
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePreferences({
    String? theme,
    String? language,
    String? timezone,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? literacyMode,
  }) async {
    if (userId == null) return;
    
    try {
      final updates = <String, dynamic>{
        if (theme != null) 'theme': theme,
        if (language != null) 'language': language,
        if (timezone != null) 'timezone': timezone,
        if (emailNotifications != null) 'email_notifications': emailNotifications,
        if (pushNotifications != null) 'push_notifications': pushNotifications,
        if (literacyMode != null) 'literacy_mode': literacyMode,
      };

      if (updates.isEmpty) return;

      // Upsert so it works even if the trigger didn't fire for older accounts
      await _supabase.from('preferences').upsert({
        'user_id': userId,
        ...updates,
      });
      
      if (state.hasValue && state.value != null) {
        state = AsyncValue.data(state.value!.copyWith(
          theme: theme,
          language: language,
          timezone: timezone,
          emailNotifications: emailNotifications,
          pushNotifications: pushNotifications,
          literacyMode: literacyMode,
        ));
      } else {
        // Just refetch to be safe if local state was null
        await _fetchPreferences();
      }
    } catch (e) {
      rethrow;
    }
  }
}
