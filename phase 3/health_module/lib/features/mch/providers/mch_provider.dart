import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/mch_repo.dart';
import '../models/pregnancy_week.dart';

final mchRepositoryProvider = Provider<MchRepository>((ref) {
  return MchRepository();
});

final pregnancyWeeksProvider = FutureProvider<List<PregnancyWeek>>((ref) async {
  final repo = ref.watch(mchRepositoryProvider);
  return repo.getPregnancyWeeks();
});

final maternalVaccinesProvider = FutureProvider<List<MaternalVaccine>>((ref) async {
  final repo = ref.watch(mchRepositoryProvider);
  return repo.getMaternalVaccines();
});

final pregnancyDangerSignsProvider = FutureProvider<List<DangerSign>>((ref) async {
  final repo = ref.watch(mchRepositoryProvider);
  return repo.getDangerSigns();
});
