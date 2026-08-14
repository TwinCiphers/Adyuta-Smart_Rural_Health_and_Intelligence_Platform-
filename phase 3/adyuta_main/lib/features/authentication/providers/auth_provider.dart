import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange;
});

final userProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider).value;
  if (authState != null) {
    return authState.session?.user;
  }
  return ref.watch(supabaseClientProvider).auth.currentUser;
});

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  Future<AuthResponse> signUpWithEmail(String email, String password, {String? fullName, String? phone}) async {
    return await _client.auth.signUp(
      email: email, 
      password: password,
      data: {
        if (fullName != null) 'full_name': fullName,
        if (phone != null) 'phone': phone,
      },
    );
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signInWithGoogle() async {
    // Uses Supabase's native OAuth flow
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.flutter://callback',
      queryParams: {
        'prompt': 'select_account',
      },
    );
  }

  Future<void> sendMagicLink(String email) async {
    await _client.auth.signInWithOtp(
      email: email,
      emailRedirectTo: 'io.supabase.flutter://callback',
    );
  }

  Future<void> signInAnonymously() async {
    await _client.auth.signInAnonymously();
  }
  
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
});
