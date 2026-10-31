import re
path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\health_module\lib\features\directory\providers\directory_provider.dart'
with open(path, 'r', encoding='utf-8') as f:
    code = f.read()

new_imports = """import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/directory_repo.dart';
import '../repositories/realtime_directory_service.dart';
import '../models/facility.dart';
"""
code = re.sub(r"import 'package:flutter_riverpod/flutter_riverpod.dart';\s*import '../repositories/directory_repo.dart';\s*import '../models/facility.dart';", new_imports, code)

new_provider = """
final searchFacilitiesProvider = FutureProvider<List<Facility>>((ref) async {
  final query = ref.watch(directorySearchQueryProvider);
  if (query.isEmpty) return [];
  // Use REAL OSM Overpass API to find actual hospitals matching the city/state query
  final realData = await RealTimeDirectoryService.searchHospitalsByCity(query);
  if (realData.isNotEmpty) return realData;
  
  // Fallback to local DB if OSM fails or returns empty
  final repo = ref.watch(directoryRepositoryProvider);
  return repo.searchFacilities(query);
});
"""

code = re.sub(r"final searchFacilitiesProvider = FutureProvider<List<Facility>>\(\(ref\) async \{.*?return repo\.searchFacilities\(query\);\s*\}\);", new_provider, code, flags=re.DOTALL)

with open(path, 'w', encoding='utf-8') as f:
    f.write(code)
