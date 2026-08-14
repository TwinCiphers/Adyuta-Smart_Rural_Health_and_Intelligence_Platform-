import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/safety_theme.dart';
import 'features/sos/sos_screen.dart';
import 'features/helpline/helpline_screen.dart';
import 'features/tips/safety_tips_screen.dart';
import 'features/timer/safety_timer_screen.dart';
import 'features/reporting/incident_report_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('broadcasts_db');
  await Hive.openBox('offline_reports');
  runApp(const AdyutaSafetyApp());
}

class AdyutaSafetyApp extends StatelessWidget {
  const AdyutaSafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SheGuard Women Safety',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: SafetyTheme.primaryRed,
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(
          seedColor: SafetyTheme.primaryRed,
          primary: SafetyTheme.primaryRed,
          secondary: SafetyTheme.warningOrange,
        ),
      ),
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
      home: const SafetyHomeNav(),
    );
  }
}

class SafetyHomeNav extends StatefulWidget {
  const SafetyHomeNav({super.key});

  @override
  State<SafetyHomeNav> createState() => _SafetyHomeNavState();
}

class _SafetyHomeNavState extends State<SafetyHomeNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    SosScreen(),
    SafetyTimerScreen(),
    IncidentReportScreen(),
    HelplineScreen(),
    SafetyTipsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.sos, 'SOS', const Color(0xFFDC2626)),
                _buildNavItem(1, Icons.timer, 'Timer', const Color(0xFFEA580C)),
                _buildNavItem(2, Icons.report_problem, 'Report', const Color(0xFF4F46E5)),
                _buildNavItem(3, Icons.phone_in_talk, 'Helplines', const Color(0xFF2563EB)),
                _buildNavItem(4, Icons.menu_book, 'Tips', const Color(0xFF9333EA)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, Color activeColor) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? activeColor : const Color(0xFF64748B), size: 24),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: activeColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
