import 'package:flutter/material.dart';
import 'core/theme/agri_theme.dart';
import 'features/dashboard/agri_dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AdyutaAgriApp());
}

class AdyutaAgriApp extends StatelessWidget {
  const AdyutaAgriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adyuta Agriculture',
      debugShowCheckedModeBanner: false,
      theme: AgriTheme.theme,
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
      home: const AgriDashboardScreen(),
    );
  }
}
