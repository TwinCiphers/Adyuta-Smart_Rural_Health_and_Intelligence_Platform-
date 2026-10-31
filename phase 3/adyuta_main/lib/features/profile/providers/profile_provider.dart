import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:adyuta_main/features/authentication/providers/auth_provider.dart';

const _secureStorage = FlutterSecureStorage();

class ProfileData {
  final String id;
  final String? displayName;
  final String? avatarUrl;
  final String? bio;
  final String? phone;
  final String? location;

  const ProfileData({
    required this.id, this.displayName, this.avatarUrl, this.bio, this.phone, this.location,
  });

  factory ProfileData.fromMap(Map<String, dynamic> map) {
    return ProfileData(
      id: map['id'] as String,
      displayName: map['name'] as String?, // Map to 'name' from backend User model
      avatarUrl: map['avatar_url'] as String?,
      bio: map['bio'] as String?,
      phone: map['phoneNumber'] as String?,
      location: map['location'] as String?,
    );
  }

  ProfileData copyWith({
    String? displayName, String? avatarUrl, String? bio, String? phone, String? location,
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
  final token = authState.session?.accessToken;
  return ProfileNotifier(token);
});

class ProfileNotifier extends StateNotifier<AsyncValue<ProfileData?>> {
  final String? token;
  String get _baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:3000/api';

  ProfileNotifier(this.token) : super(const AsyncValue.loading()) {
    if (token != null) {
      _fetchProfile();
    } else {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> _fetchProfile() async {
    try {
      state = const AsyncValue.loading();
      
      // Offline guest token — use data from auth session directly
      if (token == 'offline_guest_token' || token!.startsWith('offline_')) {
        if (!mounted) return;
        final authData = await FlutterSecureStorage().read(key: 'userProfile');
        if (authData != null) {
          final map = jsonDecode(authData) as Map<String, dynamic>;
          state = AsyncValue.data(ProfileData(
            id: map['id'] ?? 'guest',
            displayName: map['name'] ?? 'Guest User',
            phone: map['phoneNumber'],
            bio: map['bio'],
            location: map['location'],
          ));
        } else {
          state = const AsyncValue.data(ProfileData(id: 'guest', displayName: 'Guest User'));
        }
        return;
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/profile'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 10));

      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        state = AsyncValue.data(ProfileData.fromMap(data));
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e, st) {
      if (!mounted) return;
      // Offline fallback: load from secure storage cache
      try {
        final authData = await FlutterSecureStorage().read(key: 'userProfile');
        if (authData != null) {
          final map = jsonDecode(authData) as Map<String, dynamic>;
          state = AsyncValue.data(ProfileData(
            id: map['id'] ?? 'unknown',
            displayName: map['name'] ?? 'Citizen User',
          ));
          return;
        }
      } catch (_) {}
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile({
    String? displayName, String? phone, String? bio, String? location,
  }) async {
    if (token == null) return;
    try {
      final updates = <String, dynamic>{
        if (displayName != null) 'name': displayName,
        if (phone != null) 'phoneNumber': phone,
        if (bio != null) 'bio': bio,
        if (location != null) 'location': location,
      };

      if (updates.isEmpty) return;

      final response = await http.put(
        Uri.parse('$_baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(updates),
      );
      
      if (response.statusCode == 200 && state.hasValue && state.value != null) {
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
    throw UnimplementedError('Avatar upload needs backend Multer integration.');
  }
}



