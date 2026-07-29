import 'package:flutter/material.dart';
// import '../../features/agriculture/presentation/screens/agri_home_screen.dart';
// import '../../features/education/presentation/screens/edu_home_screen.dart';
// import '../../features/governance/presentation/screens/gov_home_screen.dart';
// import '../../features/safety/presentation/screens/safety_home_screen.dart';

// Assuming the health module has a dashboard or home screen
// If there isn't a single entry point yet, this acts as a placeholder
class HealthHomeScreen extends StatelessWidget {
  const HealthHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Center'), backgroundColor: const Color(0xFF00796B)),
      body: const Center(child: Text('Health Module Loaded')),
    );
  }
}

class AdyutaDashboard extends StatelessWidget {
  const AdyutaDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Soft clean background
      appBar: AppBar(
        title: const Text(
          'ADYUTA Platform',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        backgroundColor: Colors.indigo.shade900,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select Module',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _ModuleCard(
                    title: 'Health',
                    subtitle: 'Clinical Advisory & Vitals',
                    color: const Color(0xFF00796B), // Healing Green
                    icon: Icons.health_and_safety,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthHomeScreen())),
                  ),
                  const SizedBox(height: 12),
                  _ModuleCard(
                    title: 'Agriculture',
                    subtitle: 'Crop Advisory & Farm Diary',
                    color: const Color(0xFF2E7D32), // Earthy Green
                    icon: Icons.eco,
                    onTap: () {}, // Navigator.push(context, MaterialPageRoute(builder: (_) => const AgriHomeScreen())),
                  ),
                  const SizedBox(height: 12),
                  _ModuleCard(
                    title: 'Education',
                    subtitle: 'Offline Lessons & Quizzes',
                    color: const Color(0xFF3F51B5), // Indigo
                    icon: Icons.menu_book,
                    onTap: () {}, // Navigator.push(context, MaterialPageRoute(builder: (_) => const EduHomeScreen())),
                  ),
                  const SizedBox(height: 12),
                  _ModuleCard(
                    title: 'Safety',
                    subtitle: 'SOS & First Response',
                    color: const Color(0xFFD32F2F), // Alert Red
                    icon: Icons.warning,
                    onTap: () {}, // Navigator.push(context, MaterialPageRoute(builder: (_) => const SafetyHomeScreen())),
                  ),
                  const SizedBox(height: 12),
                  _ModuleCard(
                    title: 'Governance',
                    subtitle: 'Schemes & Grievances',
                    color: const Color(0xFF00695C), // Civic Teal
                    icon: Icons.gavel,
                    onTap: () {}, // Navigator.push(context, MaterialPageRoute(builder: (_) => const GovHomeScreen())),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}
