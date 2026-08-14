import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_provider.dart';

final profileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) return null;

  final client = ref.watch(supabaseClientProvider);
  
  final response = await client
      .from('profiles')
      .select()
      .eq('id', user.id)
      .maybeSingle();
      
  return response;
});

final settingsProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) return null;

  final client = ref.watch(supabaseClientProvider);
  
  final response = await client
      .from('settings')
      .select()
      .eq('user_id', user.id)
      .maybeSingle();
      
  return response;
});
