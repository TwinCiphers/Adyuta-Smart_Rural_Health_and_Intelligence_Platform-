import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/first_aid_repo.dart';
import '../models/emergency_scenario.dart';
import '../models/first_aid_step.dart';

final firstAidRepositoryProvider = Provider<FirstAidRepository>((ref) {
  return FirstAidRepository();
});

final emergencyTopicsProvider = FutureProvider<List<EmergencyScenario>>((ref) async {
  final repo = ref.watch(firstAidRepositoryProvider);
  return repo.getEmergencyTopics();
});

final firstAidStepsProvider = FutureProvider.family<List<FirstAidStep>, int>((ref, topicId) async {
  final repo = ref.watch(firstAidRepositoryProvider);
  return repo.getStepsForTopic(topicId);
});

final firstAidSearchQueryProvider = StateProvider<String>((ref) => '');

final searchTopicsProvider = FutureProvider<List<EmergencyScenario>>((ref) async {
  final query = ref.watch(firstAidSearchQueryProvider);
  final allTopics = await ref.watch(emergencyTopicsProvider.future);
  
  if (query.isEmpty) return allTopics;
  
  return allTopics.where((topic) => 
    topic.title.toLowerCase().contains(query.toLowerCase()) || 
    topic.category.toLowerCase().contains(query.toLowerCase())
  ).toList();
});
