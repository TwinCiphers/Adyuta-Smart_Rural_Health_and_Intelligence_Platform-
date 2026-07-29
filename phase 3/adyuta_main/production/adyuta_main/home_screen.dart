import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_module/features/health/presentation/screens/health_home_screen.dart';
import 'package:agriculture_module/features/agriculture/presentation/screens/agri_home_screen.dart';
import 'package:safety_module/features/safety/presentation/screens/safety_home_screen.dart';
import 'package:education_module/features/education/presentation/screens/edu_home_screen.dart';
import 'package:governance_module/features/governance/presentation/screens/gov_home_screen.dart';

class AdyutaMainHome extends StatelessWidget {
  const AdyutaMainHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA),
            image: DecorationImage(
              image: AssetImage('assets/images/app_bg.png'),
              fit: BoxFit.cover,
            opacity: 0.22,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildHeroBanner(),
              const SizedBox(height: 24),
              _buildOurServices(context),
              const SizedBox(height: 24),
              _buildMoreServices(),
            const SizedBox(height: 24),
            _buildAboutBanner(),
            const SizedBox(height: 100), // padding for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner, color: Color(0xFF2E7D32), size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 105,
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black87),
        onPressed: () {},
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/adyuta_logo.png', height: 80),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Adyuta', style: GoogleFonts.caveat(fontWeight: FontWeight.bold, fontSize: 42, color: const Color(0xFF19326A), height: 1.0)),
              const SizedBox(height: 3),
              Text(
                'Where Rare Stands Alone',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700, height: 1.2),
              ),
            ],
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black87),
              onPressed: () {},
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            radius: 16,
            child: const Icon(Icons.person, color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget _buildHeroBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: const DecorationImage(
            image: AssetImage('assets/images/hero.png'),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'One App, Many Services,',
                style: GoogleFonts.inter(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500),
              ),
              Text(
                'Stronger Tomorrow.',
                style: GoogleFonts.inter(fontSize: 22, color: const Color(0xFF3366FF), fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Your trusted companion for\na better and empowered life.',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3366FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Explore Services', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward, size: 14),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOurServices(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Our Services', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              Row(
                children: [
                  Text('View All', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF3366FF))),
                  const Icon(Icons.arrow_forward, size: 16, color: Color(0xFF3366FF))
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: [
                _ServiceCard(
                  title: 'Health',
                  subtitle: 'Healthcare &\nWellness for all',
                  color: const Color(0xFFE8F5E9),
                  iconBgColor: const Color(0xFFC8E6C9),
                  iconColor: const Color(0xFF2E7D32),
                  icon: Icons.favorite,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthHomeScreen())),
                ),
                const SizedBox(width: 12),
                _ServiceCard(
                  title: 'Agriculture',
                  subtitle: 'Smart Solutions\nfor Farmers',
                  color: const Color(0xFFF9FBE7),
                  iconBgColor: const Color(0xFFF0F4C3),
                  iconColor: const Color(0xFF827717),
                  icon: Icons.eco,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AgriHomeScreen())),
                ),
                const SizedBox(width: 12),
                _ServiceCard(
                  title: 'Safety',
                  subtitle: 'Your Safety,\nOur Priority',
                  color: const Color(0xFFFFF3E0),
                  iconBgColor: const Color(0xFFFFE0B2),
                  iconColor: const Color(0xFFE65100),
                  icon: Icons.shield,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SafetyHomeScreen())),
                ),
                const SizedBox(width: 12),
                _ServiceCard(
                  title: 'Education',
                  subtitle: 'Learn, Grow\nand Succeed',
                  color: const Color(0xFFF3E5F5),
                  iconBgColor: const Color(0xFFE1BEE7),
                  iconColor: const Color(0xFF4A148C),
                  icon: Icons.school,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EduHomeScreen())),
                ),
                const SizedBox(width: 12),
                _ServiceCard(
                  title: 'Governance',
                  subtitle: 'Transparent\n& Efficient',
                  color: const Color(0xFFE3F2FD),
                  iconBgColor: const Color(0xFFBBDEFB),
                  iconColor: const Color(0xFF0D47A1),
                  icon: Icons.account_balance,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GovHomeScreen())),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMoreServices() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('More Services', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 8,
              childAspectRatio: 0.7,
              children: [
                _MiniIcon(icon: Icons.account_balance_wallet_outlined, label: 'Payments'),
                _MiniIcon(icon: Icons.description_outlined, label: 'Documents'),
                _MiniIcon(icon: Icons.headset_mic_outlined, label: 'Grievance'),
                _MiniIcon(icon: Icons.card_giftcard_outlined, label: 'Schemes'),
                _MiniIcon(icon: Icons.work_outline, label: 'Jobs'),
                _MiniIcon(icon: Icons.newspaper_outlined, label: 'News'),
                _MiniIcon(icon: Icons.calendar_month_outlined, label: 'Events'),
                _MiniIcon(icon: Icons.phone_in_talk_outlined, label: 'Helpline'),
                _MiniIcon(icon: Icons.location_on_outlined, label: 'Nearby'),
                _MiniIcon(icon: Icons.more_horiz, label: 'More'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAboutBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)]),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('About Adyuta', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            Text(
              'Adyuta is your all-in-one platform\nbringing essential services at\nyour fingertips.',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3366FF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text('Know More', style: GoogleFonts.inter(fontSize: 12)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavIcon(icon: Icons.home, label: 'Home', isActive: true),
            _NavIcon(icon: Icons.grid_view, label: 'Services'),
            const SizedBox(width: 48), // Space for FAB
            _NavIcon(icon: Icons.inbox_outlined, label: 'Inbox'),
            _NavIcon(icon: Icons.person_outline, label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final Color iconBgColor;
  final Color iconColor;
  final IconData icon;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.iconBgColor,
    required this.iconColor,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: iconBgColor, width: 1),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 12),
            Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
            const SizedBox(height: 4),
            Text(subtitle, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 10, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _MiniIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MiniIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF19326A), size: 24),
        const SizedBox(height: 6),
        Text(label, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 10, color: Colors.black87)),
      ],
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _NavIcon({required this.icon, required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF3366FF) : Colors.grey.shade500;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        Text(label, style: GoogleFonts.inter(fontSize: 10, color: color, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
