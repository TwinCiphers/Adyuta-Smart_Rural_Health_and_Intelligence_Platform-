import 'package:bhashini_core/bhashini_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_module/core/theme/app_theme.dart';
import 'package:health_module/core/widgets/soft_background_layout.dart';
import '../providers/nutrition_provider.dart';

final atlasSearchQueryProvider = StateProvider<String>((ref) => '');
final selectedAtlasFoodIdProvider = StateProvider<String?>((ref) => null);
final selectedChemicalIdProvider = StateProvider<String?>((ref) => null);

class FoodAtlasResearchScreen extends ConsumerWidget {
  const FoodAtlasResearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(atlasSearchQueryProvider);
    final selectedFoodId = ref.watch(selectedAtlasFoodIdProvider);
    final selectedChemicalId = ref.watch(selectedChemicalIdProvider);

    return SoftBackgroundLayout(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: AppTheme.softShadow),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                ),
              ),
              const SizedBox(height: 24),
              GlobalBhashiniText('Clinical Research', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 32)),
              const SizedBox(height: 8),
              GlobalBhashiniText('Powered by FoodAtlas AI Knowledge Graph.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14, color: Colors.blueGrey)),
              const SizedBox(height: 24),
              
              // Search Box
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: AppTheme.softShadow),
                child: TextField(
                  onChanged: (val) {
                    ref.read(atlasSearchQueryProvider.notifier).state = val;
                    ref.read(selectedAtlasFoodIdProvider.notifier).state = null;
                    ref.read(selectedChemicalIdProvider.notifier).state = null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search clinical foods (e.g. Garlic)...',
                    prefixIcon: Icon(Icons.biotech, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Search Results
              if (query.isNotEmpty && selectedFoodId == null) ...[
                GlobalBhashiniText('Results', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                const SizedBox(height: 16),
                ref.watch(foodAtlasSearchProvider(query)).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => GlobalBhashiniText('Error: $e'),
                  data: (results) {
                    if (results.isEmpty) return const GlobalBhashiniText('No clinical records found.');
                    return Column(
                      children: results.map((item) => Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: GlobalBhashiniText(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: GlobalBhashiniText('ID: ${item['id']}'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            ref.read(selectedAtlasFoodIdProvider.notifier).state = item['id'];
                          },
                        ),
                      )).toList(),
                    );
                  },
                ),
              ],

              // Food Detail (Chemicals)
              if (selectedFoodId != null) ...[
                GlobalBhashiniText('Active Chemicals in this Food', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                const SizedBox(height: 16),
                ref.watch(foodChemicalsProvider(selectedFoodId)).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => GlobalBhashiniText('Error: $e'),
                  data: (chems) {
                    if (chems.isEmpty) return const GlobalBhashiniText('No chemicals mapped.');
                    return Column(
                      children: chems.map((chem) => Card(
                        color: selectedChemicalId == chem['chemical_id'] ? Colors.green[50] : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.science, color: Colors.white, size: 16)),
                          title: GlobalBhashiniText(chem['chemical_name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: GlobalBhashiniText('Relation: ${chem['relationship']}'),
                          onTap: () {
                            ref.read(selectedChemicalIdProvider.notifier).state = chem['chemical_id'];
                          },
                        ),
                      )).toList(),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],

              // Chemical Diseases
              if (selectedChemicalId != null) ...[
                GlobalBhashiniText('Clinical Effects (Diseases)', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, color: Colors.redAccent)),
                const SizedBox(height: 16),
                ref.watch(chemicalDiseasesProvider(selectedChemicalId)).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => GlobalBhashiniText('Error: $e'),
                  data: (diseases) {
                    if (diseases.isEmpty) return const GlobalBhashiniText('No known disease relationships.');
                    return Column(
                      children: diseases.map((disease) => Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.redAccent.withOpacity(0.3))),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(Icons.medical_services, color: Colors.redAccent),
                          title: GlobalBhashiniText(disease['disease_name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: GlobalBhashiniText('Effect: ${disease['relationship'].toString().toUpperCase()}'),
                        ),
                      )).toList(),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
