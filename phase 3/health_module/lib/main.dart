import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Theme & Global Widgets
import 'core/theme/app_theme.dart';
import 'core/widgets/adyuta_bottom_nav.dart';
import 'core/sync/sync_service.dart';

// Screens
import 'features/health_hub/screens/health_hub_screen.dart';
import 'features/health_hub/screens/all_services_screen.dart';
import 'features/pharmacy/screens/pharmacy_screen.dart';
import 'features/pharmacy/screens/all_medicines_screen.dart';
import 'features/first_aid/screens/first_aid_screen.dart';
import 'features/mch/screens/mch_screen.dart';
import 'features/directory/screens/directory_screen.dart';
import 'features/phr/screens/phr_screen.dart';
import 'features/nutrition/screens/nutrition_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  
  // Trigger background sync
  SyncService().performSync();

  runApp(
    const ProviderScope(
      child: AdyutaHealthApp(),
    ),
  );
}

class AdyutaHealthApp extends StatelessWidget {
  const AdyutaHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adyuta Health',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA),
            image: DecorationImage(
              image: AssetImage('assets/images/app_bg.png'),
              fit: BoxFit.cover,
              opacity: 0.22,
            ),
          ),
          child: child,
        );
      },
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigationScaffold(),
        '/all_services': (context) => const AllServicesScreen(),
        '/pharmacy': (context) => const PharmacyScreen(),
        '/all_medicines': (context) => const AllMedicinesScreen(),
        '/firstaid': (context) => const FirstAidScreen(),
        '/mch': (context) => const MchScreen(),
        '/directory': (context) => const DirectoryScreen(),
        '/phr': (context) => const PhrScreen(),
        '/nutrition': (context) => const NutritionScreen(),
      },
    );
  }
}

// Global state for bottom nav
final bottomNavIndexProvider = StateProvider<int>((ref) => 1); // 1 = Health/Services

class MainNavigationScaffold extends ConsumerWidget {
  const MainNavigationScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      body: Stack(
        children: [
          // The selected screen
          _buildBody(currentIndex),
          
          // Floating custom bottom nav bar removed as per user request

        ],
      ),
    );
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return const Center(child: Text('Home Dashboard (Coming Soon)'));
      case 1:
        return const HealthHubScreen(); // The main health grid
      default:
        return const HealthHubScreen();
    }
  }
}
