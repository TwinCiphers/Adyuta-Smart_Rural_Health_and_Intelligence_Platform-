import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Mock imports removed

import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Global Hive for all modules
  await Hive.initFlutter();
  
  // Register adapters for all real modules (if any for host app in future)

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
