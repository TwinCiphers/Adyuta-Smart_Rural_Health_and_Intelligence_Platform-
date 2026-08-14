import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:safety_module/core/services/background_safety_service.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:adyuta_main/core/routing/app_router.dart';
import 'package:adyuta_main/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Initialize Supabase
  try {
    const supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://wntieyjzdqfaykvzvxia.supabase.co');
    const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndudGlleWp6ZHFmYXlrdnp2eGlhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODUzMzc2MTAsImV4cCI6MjEwMDkxMzYxMH0.JAyXybLOQdvGVsuBrYfsOBYw_KTaaq84rbqc0KhR5mo');
    
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  } catch (e) {
    debugPrint('Supabase init error: $e');
  }

  // Background Safety Service
  try {
    // await initializeBackgroundService();
  } catch (e) {
    debugPrint('Background service init error: $e');
  }

  runApp(
    const ProviderScope(
      child: AdyutaHostApp(),
    ),
  );
}

class AdyutaHostApp extends ConsumerWidget {
  const AdyutaHostApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'ADYUTA',
      debugShowCheckedModeBanner: false,
      
      routerConfig: goRouter,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            const GlobalSafetyBanner(),
          ],
        );
      },
    );
  }
}

// ── Global Safety Banner ──────────────────────────

class GlobalSafetyBanner extends StatefulWidget {
  const GlobalSafetyBanner({super.key});

  @override
  State<GlobalSafetyBanner> createState() => _GlobalSafetyBannerState();
}

class _GlobalSafetyBannerState extends State<GlobalSafetyBanner> with WidgetsBindingObserver {
  bool _isRunning = false;
  Timer? _checkTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkStatus();
    _startTimer();
  }

  void _startTimer() {
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(const Duration(seconds: 5), (_) => _checkStatus());
  }

  void _stopTimer() {
    _checkTimer?.cancel();
    _checkTimer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkStatus();
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopTimer();
    super.dispose();
  }

  Future<void> _checkStatus() async {
    final service = FlutterBackgroundService();
    final running = await service.isRunning();
    if (mounted && running != _isRunning) {
      setState(() => _isRunning = running);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isRunning) return const SizedBox.shrink();
    return Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.security, color: Colors.white),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Safety Service Active (Live Tracking & Watch Me)',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
              GestureDetector(
                onTap: () {
                  FlutterBackgroundService().invoke('stopService');
                  setState(() => _isRunning = false);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text('STOP',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
