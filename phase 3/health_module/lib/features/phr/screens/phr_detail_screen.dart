import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_module/core/theme/app_theme.dart';
import 'package:health_module/core/widgets/soft_background_layout.dart';
import '../repositories/phr_repo.dart';

final phrRepoProvider = Provider<PhrRepository>((ref) => PhrRepository());

class PhrDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> profile;

  const PhrDetailScreen({super.key, required this.profile});

  @override
  ConsumerState<PhrDetailScreen> createState() => _PhrDetailScreenState();
}

class _PhrDetailScreenState extends ConsumerState<PhrDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final profileId = widget.profile['id'] as int;

    return SoftBackgroundLayout(
      hasScrollBody: true,
      child: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.profile['name'],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppTheme.primaryColor,
            tabs: const [
              Tab(text: 'Vitals'),
              Tab(text: 'Medicines'),
              Tab(text: 'Visits'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _VitalsTab(profileId: profileId),
                _MedicinesTab(profileId: profileId),
                _VisitsTab(profileId: profileId),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ---------------- VITALS TAB ----------------
class _VitalsTab extends ConsumerWidget {
  final int profileId;
  const _VitalsTab({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _BaseTab(
      fetchData: () => ref.read(phrRepoProvider).getVitals(profileId),
      onAdd: () => _showAddVitals(context, ref),
      buildItem: (item) => ListTile(
        title: Text('BP: ${item['blood_pressure_sys']}/${item['blood_pressure_dia']}  •  Sugar: ${item['blood_sugar']}'),
        subtitle: Text('Weight: ${item['weight_kg']}kg  •  Temp: ${item['temperature_f']}°F'),
        trailing: Text(item['timestamp'].toString().split('T')[0]),
      ),
    );
  }

  void _showAddVitals(BuildContext context, WidgetRef ref) {
    final sysCtrl = TextEditingController();
    final diaCtrl = TextEditingController();
    final sugarCtrl = TextEditingController();
    final weightCtrl = TextEditingController();

    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Add Vitals'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            Expanded(child: TextField(controller: sysCtrl, decoration: const InputDecoration(labelText: 'Sys BP'))),
            const SizedBox(width: 8),
            Expanded(child: TextField(controller: diaCtrl, decoration: const InputDecoration(labelText: 'Dia BP'))),
          ]),
          TextField(controller: sugarCtrl, decoration: const InputDecoration(labelText: 'Sugar Level')),
          TextField(controller: weightCtrl, decoration: const InputDecoration(labelText: 'Weight (kg)')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            await ref.read(phrRepoProvider).addVitals({
              'profile_id': profileId,
              'timestamp': DateTime.now().toIso8601String(),
              'blood_pressure_sys': int.tryParse(sysCtrl.text),
              'blood_pressure_dia': int.tryParse(diaCtrl.text),
              'blood_sugar': double.tryParse(sugarCtrl.text),
              'weight_kg': double.tryParse(weightCtrl.text),
            });
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Save'),
        )
      ],
    ));
  }
}

// ---------------- MEDICINES TAB ----------------
class _MedicinesTab extends ConsumerWidget {
  final int profileId;
  const _MedicinesTab({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _BaseTab(
      fetchData: () => ref.read(phrRepoProvider).getMedicines(profileId),
      onAdd: () => _showAddMedicine(context, ref),
      buildItem: (item) => ListTile(
        title: Text(item['medicine_name']),
        subtitle: Text('Dosage: ${item['dosage']}'),
        trailing: item['is_active'] == 1 ? const Icon(Icons.check_circle, color: Colors.green) : null,
      ),
    );
  }

  void _showAddMedicine(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final dosageCtrl = TextEditingController();

    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Add Medicine'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Medicine Name')),
          TextField(controller: dosageCtrl, decoration: const InputDecoration(labelText: 'Dosage (e.g. 1-0-1)')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            if (nameCtrl.text.isNotEmpty) {
              await ref.read(phrRepoProvider).addMedicine({
                'profile_id': profileId,
                'medicine_name': nameCtrl.text,
                'dosage': dosageCtrl.text,
                'start_date': DateTime.now().toIso8601String(),
                'is_active': 1,
              });
              if(context.mounted) Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        )
      ],
    ));
  }
}

// ---------------- VISITS TAB ----------------
class _VisitsTab extends ConsumerWidget {
  final int profileId;
  const _VisitsTab({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _BaseTab(
      fetchData: () => ref.read(phrRepoProvider).getVisits(profileId),
      onAdd: () => _showAddVisit(context, ref),
      buildItem: (item) => ListTile(
        title: Text(item['chief_complaint'] ?? 'Routine Visit'),
        subtitle: Text('Doctor: ${item['doctor_name']}  •  Facility: ${item['facility_name']}'),
        trailing: Text(item['visit_date'].toString().split('T')[0]),
      ),
    );
  }

  void _showAddVisit(BuildContext context, WidgetRef ref) {
    final complaintCtrl = TextEditingController();
    final doctorCtrl = TextEditingController();
    final facilityCtrl = TextEditingController();

    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Add Visit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: complaintCtrl, decoration: const InputDecoration(labelText: 'Chief Complaint')),
          TextField(controller: doctorCtrl, decoration: const InputDecoration(labelText: 'Doctor Name')),
          TextField(controller: facilityCtrl, decoration: const InputDecoration(labelText: 'Facility/Hospital')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            if (complaintCtrl.text.isNotEmpty) {
              await ref.read(phrRepoProvider).addVisit({
                'profile_id': profileId,
                'visit_date': DateTime.now().toIso8601String(),
                'chief_complaint': complaintCtrl.text,
                'doctor_name': doctorCtrl.text,
                'facility_name': facilityCtrl.text,
              });
              if(context.mounted) Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        )
      ],
    ));
  }
}

// ---------------- BASE TAB ----------------
class _BaseTab extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> Function() fetchData;
  final Widget Function(Map<String, dynamic>) buildItem;
  final VoidCallback onAdd;

  const _BaseTab({required this.fetchData, required this.buildItem, required this.onAdd});

  @override
  State<_BaseTab> createState() => _BaseTabState();
}

class _BaseTabState extends State<_BaseTab> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _future = widget.fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final data = snapshot.data ?? [];
              if (data.isEmpty) {
                return const Center(child: Text('No records found.'));
              }
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: widget.buildItem(data[index]),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              widget.onAdd();
              // A slight delay to allow dialog to pop and DB to save
              Future.delayed(const Duration(milliseconds: 500), _loadData);
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Add New', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        )
      ],
    );
  }
}
