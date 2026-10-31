import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

const _secureStorage = FlutterSecureStorage();
String get _backendUrl => '${dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:3000/api'}/auth';

// ─── Models ────────────────────────────────────────────────────────────────

class AppUser {
  final String id;
  final String email;
  final String name;
  final String? role;
  final bool isAnonymous;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.role,
    this.isAnonymous = false,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? json['full_name'] ?? 'User',
      role: json['role'],
      isAnonymous: json['is_anonymous'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'role': role,
    'is_anonymous': isAnonymous,
  };
}

class AppSession {
  final AppUser user;
  final String accessToken;

  AppSession({required this.user, required this.accessToken});
}

class AuthState {
  final AppSession? session;
  final bool isLoading;
  AuthState(this.session, {this.isLoading = false});
}

// ─── Notifier ──────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(null, isLoading: true)) {
    _loadSession();
  }

  /// Restores session from secure storage (works 100% offline).
  Future<void> _loadSession() async {
    try {
      final token = await _secureStorage.read(key: 'accessToken');
      final userStr = await _secureStorage.read(key: 'userProfile');
      if (token != null && userStr != null) {
        final user = AppUser.fromJson(jsonDecode(userStr) as Map<String, dynamic>);
        if (mounted) state = AuthState(AppSession(user: user, accessToken: token));
        return;
      }
    } catch (_) {}
    if (mounted) state = AuthState(null);
  }

  void setSession(AppSession? session) {
    if (mounted) state = AuthState(session);
  }
}

// ─── Providers ─────────────────────────────────────────────────────────────

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

final userProvider = Provider<AppUser?>((ref) {
  return ref.watch(authStateProvider).session?.user;
});

// ─── Repository ────────────────────────────────────────────────────────────

class AuthRepository {
  final AuthNotifier _notifier;
  AuthRepository(this._notifier);

  Future<String> _getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('deviceId');
    if (deviceId == null) {
      deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString('deviceId', deviceId);
    }
    return deviceId;
  }

  Future<void> _saveSession(Map<String, dynamic> data) async {
    await _secureStorage.write(key: 'accessToken', value: data['accessToken'] as String?);
    await _secureStorage.write(key: 'refreshToken', value: data['refreshToken'] as String?);
    await _secureStorage.write(key: 'userProfile', value: jsonEncode(data['user']));
    final user = AppUser.fromJson(data['user'] as Map<String, dynamic>);
    _notifier.setSession(AppSession(user: user, accessToken: data['accessToken'] as String? ?? ''));
  }

  Future<void> signUpWithEmail(String email, String password, {String? fullName, String? phone}) async {
    final response = await http.post(
      Uri.parse('$_backendUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'name': fullName ?? 'User'}),
    ).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Signup failed: ${response.body}');
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    final deviceId = await _getDeviceId();
    final response = await http.post(
      Uri.parse('$_backendUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'deviceId': deviceId}),
    ).timeout(const Duration(seconds: 15));
    if (response.statusCode == 200) {
      await _saveSession(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<void> signInWithGoogle() async {
    // Delegate to anonymous for now (no Google OAuth in custom backend)
    await signInAnonymously();
  }

  Future<void> sendMagicLink(String email) async {
    // Not supported in custom backend; fall back to anonymous
    await signInAnonymously();
  }

  /// Guest / anonymous sign-in — works offline via a locally-generated session.
  Future<void> signInAnonymously() async {
    // Try backend first
    try {
      final response = await http.post(
        Uri.parse('$_backendUrl/anonymous'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({}),
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        await _saveSession(jsonDecode(response.body) as Map<String, dynamic>);
        return;
      }
    } catch (_) {}

    // ── Offline fallback: create a local-only guest session ──────────────
    final guestUser = AppUser(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      email: 'guest@adyuta.local',
      name: 'Guest User',
      role: 'guest',
      isAnonymous: true,
    );
    const fakeToken = 'offline_guest_token';
    await _secureStorage.write(key: 'accessToken', value: fakeToken);
    await _secureStorage.write(key: 'userProfile', value: jsonEncode(guestUser.toJson()));
    _notifier.setSession(AppSession(user: guestUser, accessToken: fakeToken));
  }

  Future<void> signOut() async {
    // Try to notify backend (best-effort, ignore errors)
    try {
      final token = await _secureStorage.read(key: 'accessToken');
      final deviceId = await _getDeviceId();
      if (token != null && !token.startsWith('offline_')) {
        await http.post(
          Uri.parse('$_backendUrl/logout'),
          headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
          body: jsonEncode({'deviceId': deviceId}),
        ).timeout(const Duration(seconds: 8));
      }
    } catch (_) {}
    await _secureStorage.delete(key: 'accessToken');
    await _secureStorage.delete(key: 'refreshToken');
    await _secureStorage.delete(key: 'userProfile');
    _notifier.setSession(null);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(authStateProvider.notifier));
});

// Convenience alias — the Supabase client provider is no longer needed.
// Kept as a stub so any screens that still reference it won't break at compile time.
final supabaseClientProvider = Provider<Object?>((ref) => null);

