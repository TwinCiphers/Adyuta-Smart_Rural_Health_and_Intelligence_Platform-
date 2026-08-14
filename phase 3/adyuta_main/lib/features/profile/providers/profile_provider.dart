import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:adyuta_main/features/authentication/providers/auth_provider.dart';

class ProfileData {
  final String id;
  final String? displayName;
  final String? avatarUrl;
  final String? bio;
  final String? phone;
  final String? location;

  ProfileData({
    required this.id,
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.phone,
    this.location,
  });

  factory ProfileData.fromMap(Map<String, dynamic> map) {
    return ProfileData(
      id: map['id'] as String,
      displayName: map['display_name'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      bio: map['bio'] as String?,
      phone: map['phone'] as String?,
      location: map['location'] as String?,
    );
  }

  ProfileData copyWith({
    String? displayName,
    String? avatarUrl,
    String? bio,
    String? phone,
    String? location,
  }) {
    return ProfileData(
      id: id,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      phone: phone ?? this.phone,
      location: location ?? this.location,
    );
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileData?>>((ref) {
  final authState = ref.watch(authStateProvider);
  final userId = authState.value?.session?.user.id;
  
  return ProfileNotifier(userId);
});

class ProfileNotifier extends StateNotifier<AsyncValue<ProfileData?>> {
  final String? userId;
  final _supabase = Supabase.instance.client;

  ProfileNotifier(this.userId) : super(const AsyncValue.loading()) {
    if (userId != null) {
      _fetchProfile();
    } else {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> _fetchProfile() async {
    try {
      state = const AsyncValue.loading();
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId!)
          .single();
      
      state = AsyncValue.data(ProfileData.fromMap(data));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? phone,
    String? bio,
    String? location,
  }) async {
    if (userId == null) return;
    
    try {
      final updates = <String, dynamic>{
        if (displayName != null) 'display_name': displayName,
        if (phone != null) 'phone': phone,
        if (bio != null) 'bio': bio,
        if (location != null) 'location': location,
      };

      if (updates.isEmpty) return;

      await _supabase.from('profiles').update(updates).eq('id', userId!);
      
      // Update local state if we have data
      if (state.hasValue && state.value != null) {
        state = AsyncValue.data(state.value!.copyWith(
          displayName: displayName,
          phone: phone,
          bio: bio,
          location: location,
        ));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadAvatar(File imageFile) async {
    if (userId == null) return;

    try {
      final fileExt = imageFile.path.split('.').last;
      final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = 'avatars/$fileName';

      // 1. Upload to Supabase Storage
      await _supabase.storage.from('user_storage').upload(
        filePath, 
        imageFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
      );

      // 2. Get public URL
      final publicUrl = _supabase.storage.from('user_storage').getPublicUrl(filePath);

      // 3. Update profile row
      await _supabase.from('profiles').update({'avatar_url': publicUrl}).eq('id', userId!);

      // 4. Update local state
      if (state.hasValue && state.value != null) {
        state = AsyncValue.data(state.value!.copyWith(avatarUrl: publicUrl));
      }
    } catch (e) {
      rethrow;
    }
  }
}
