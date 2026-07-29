import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Import local packages' Hive models to initialize the offline databases universally
import 'package:agriculture_module/features/agriculture/domain/models.dart';
import 'package:education_module/features/education/domain/models.dart';
import 'package:governance_module/features/governance/domain/models.dart';

import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Global Hive for all modules
  await Hive.initFlutter();
  
  // Register adapters for all modules
  Hive.registerAdapter(FarmLogAdapter());
  Hive.registerAdapter(ProgressRecordAdapter());
  Hive.registerAdapter(GrievanceDraftAdapter());
  
  // Open boxes
  await Hive.openBox<FarmLog>('farmLogs');
  await Hive.openBox<ProgressRecord>('progressRecords');
  await Hive.openBox<GrievanceDraft>('grievanceDrafts');

  runApp(const ProviderScope(child: AdyutaHostApp()));
}

class AdyutaHostApp extends StatelessWidget {
  const AdyutaHostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADYUTA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF3366FF),
      ),
      home: const AdyutaMainHome(),
    );
  }
}
