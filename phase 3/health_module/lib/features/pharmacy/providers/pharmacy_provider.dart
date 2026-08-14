import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/pharmacy_repo.dart';
import '../models/medicine.dart';

final pharmacyRepositoryProvider = Provider<PharmacyRepository>((ref) {
  return PharmacyRepository();
});

final topMedicinesProvider = FutureProvider<List<Medicine>>((ref) async {
  final repo = ref.watch(pharmacyRepositoryProvider);
  return repo.getTopMedicines(limit: 5);
});

final allMedicinesProvider = FutureProvider<List<Medicine>>((ref) async {
  final repo = ref.watch(pharmacyRepositoryProvider);
  return repo.getAllMedicines();
});

final pharmacySearchQueryProvider = StateProvider<String>((ref) => '');

final searchMedicinesProvider = FutureProvider<List<Medicine>>((ref) async {
  final query = ref.watch(pharmacySearchQueryProvider);
  if (query.isEmpty) return [];
  final repo = ref.watch(pharmacyRepositoryProvider);
  return repo.searchMedicines(query);
});
