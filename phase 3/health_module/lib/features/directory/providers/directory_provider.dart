import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/directory_repo.dart';
import '../models/facility.dart';

final directoryRepositoryProvider = Provider<DirectoryRepository>((ref) {
  return DirectoryRepository();
});

final directorySearchQueryProvider = StateProvider<String>((ref) => '');

final searchFacilitiesProvider = FutureProvider<List<Facility>>((ref) async {
  final query = ref.watch(directorySearchQueryProvider);
  if (query.isEmpty) return [];
  final repo = ref.watch(directoryRepositoryProvider);
  return repo.searchFacilities(query);
});

final facilitiesProvider = FutureProvider<List<Facility>>((ref) async {
  final repo = ref.watch(directoryRepositoryProvider);
  return repo.getNearbyFacilities();
});

final localHelpersProvider = FutureProvider<List<LocalHelper>>((ref) async {
  final repo = ref.watch(directoryRepositoryProvider);
  return repo.getLocalHelpers();
});
