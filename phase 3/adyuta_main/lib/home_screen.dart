import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_module/main.dart'; // Import the Health module's entry point
import 'package:agri_module/agri_module.dart'; // Import the Agriculture module's entry point
import 'package:safety_module/safety_module.dart'; // Import the Safety module's entry point
import 'package:education_module/education_module.dart'; // Import the Education module's entry point
import 'package:governance_module/governance_module.dart'; // Import the Governance module's entry point
import 'package:adyuta_main/services/bhashini_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:adyuta_main/features/authentication/providers/auth_provider.dart';
import 'package:adyuta_main/features/profile/providers/profile_provider.dart';
import 'package:adyuta_main/features/dashboard/providers/dashboard_provider.dart';
import 'package:intl/intl.dart';
import 'package:adyuta_main/core/widgets/skeleton_loader.dart';
import 'package:adyuta_main/core/widgets/error_state_widget.dart';

class AdyutaMainHome extends ConsumerStatefulWidget {
  const AdyutaMainHome({super.key});

  @override
  ConsumerState<AdyutaMainHome> createState() => _AdyutaMainHomeState();
}

class _AdyutaMainHomeState extends ConsumerState<AdyutaMainHome> {
  BhashiniService get b => BhashiniService.instance;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _updatesKey = GlobalKey();
  int _currentNavIndex = 0;

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: b,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          drawer: _buildDrawer(),
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
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Consumer(
                    builder: (context, ref, child) {
                      final user = ref.watch(userProvider);
                      // Security setup pending check can be implemented later
                      if (user != null && false) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.shade400),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text('Complete security setup to enable fast MPIN login.'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.push('/setup_mpin');
                                },
                                child: const Text('Setup now'),
                              )
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  _buildSyncStatus(context),
                  const SizedBox(height: 16),
                  _buildHeroBanner(),
                  const SizedBox(height: 24),
                  _buildServiceGrid(context),
                  const SizedBox(height: 24),
                  _buildActivityFeed(context),
                  const SizedBox(height: 24),
                  _buildAboutBanner(),
                  const SizedBox(height: 24),
                  _buildFooter(),
                  const SizedBox(height: 100), // padding for FAB
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAIChatbotModal(context),
            backgroundColor: const Color(0xFF3366FF),
            elevation: 6,
            shape: const CircleBorder(),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 30),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _buildBottomNav(),
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                context.push('/settings');
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF19326A), Color(0xFF3366FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset('assets/images/adyuta_logo.png', fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final user = ref.watch(userProvider);
                          final name = user?.userMetadata?['full_name'] ?? user?.userMetadata?['name'];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name?.isNotEmpty == true ? name : 'Citizen User',
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                              ),
                              Text(
                                user?.phone ?? '+91 \u2022\u2022\u2022\u2022\u2022 \u2022\u2022808',
                                style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
                              ),
                            ],
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.home_outlined, color: Color(0xFF19326A)),
              title: Text(b.t('Home Dashboard'), style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_view, color: Color(0xFF2E7D32)),
              title: Text(b.t('Our Services'), style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _scrollToKey(_servicesKey);
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome, color: Color(0xFF3366FF)),
              title: Text(b.t('AI Assistant & Chatbot'), style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _showAIChatbotModal(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active_outlined, color: Color(0xFFE65100)),
              title: Text(b.t('Updates & Alerts'), style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _scrollToKey(_updatesKey);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: Color(0xFF4A148C)),
              title: Text(b.t('Settings & Preferences'), style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                context.push('/settings');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language, color: Color(0xFF19326A)),
              title: Text(b.t('Language / भाषा'), style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              subtitle: Text(
                b.currentLanguageCode == 'en' ? 'English (Default)' : BhashiniService.supportedLanguages.firstWhere((l) => l['code'] == b.currentLanguageCode)['native']!,
                style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFC67D00), fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                b.showLanguageSelector(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.black87),
              title: Text(b.t('Help & Helpline 1930'), style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('National Cyber & Citizen Helpline: 1930 / 112')),
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Adyuta v1.0.0 (Pure Dart Offline)',
                style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 105,
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87, size: 28),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: 'Menu',
        ),
      ),
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/adyuta_logo.png', height: 80),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Adyuta', style: GoogleFonts.caveat(fontWeight: FontWeight.bold, fontSize: 42, color: const Color(0xFF19326A), height: 1.0)),
                const SizedBox(height: 2),
                Text(
                  'Where Rare Stands Alone',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700, height: 1.2),
                ),
              ],
            ),
          ],
        ),
      ),
      centerTitle: true,
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black87, size: 26),
              onPressed: () => _showNotificationsDialog(context),
              tooltip: 'Notifications',
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
          padding: const EdgeInsets.only(right: 16.0, left: 6.0),
          child: GestureDetector(
            onTap: () => context.push('/profile'),
            child: Consumer(
              builder: (context, ref, _) {
                final profileAsync = ref.watch(profileProvider);
                final avatarUrl = profileAsync.valueOrNull?.avatarUrl;

                return CircleAvatar(
                  backgroundColor: const Color(0xFF19326A),
                  radius: 16,
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl == null
                      ? const Icon(Icons.person, color: Colors.white, size: 20)
                      : null,
                );
              }
            ),
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
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFF19326A), Color(0xFF2E7D32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(Icons.account_balance, size: 180, color: Colors.white.withOpacity(0.1)),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                    child: Text('Bharat Citizen Portal', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Smart Rural Health,\nAgri & Governance',
                    style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _scrollToKey(_servicesKey),
                    icon: const Icon(Icons.explore, size: 16),
                    label: Text('Explore Services', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF19326A),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatus(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.cloud_done, size: 14, color: Colors.green),
                const SizedBox(width: 4),
                Text('Online & Synced', style: GoogleFonts.inter(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildServiceGrid(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final dashboardAsync = ref.watch(dashboardProvider);
        
        return Padding(
          key: _servicesKey,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(b.t('Our Services'), style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              ),
              const SizedBox(height: 16),
              dashboardAsync.when(
                loading: () => Column(
                  children: List.generate(5, (index) => const Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: SkeletonLoader(width: double.infinity, height: 140, borderRadius: 20),
                  )),
                ),
                error: (err, stack) => ErrorStateWidget(
                  message: 'Failed to load services. Please check your connection.',
                  onRetry: () => ref.read(dashboardProvider.notifier).refresh(),
                ),
                data: (data) {
                  final domains = data?.domains ?? [];
                  
                  // Helper to extract status for a domain
                  String getStatus(String domainName, String defaultText) {
                    final d = domains.firstWhere((e) => e['domain'] == domainName, orElse: () => {});
                    if (d.isEmpty) return defaultText;
                    
                    final dData = d['data'] as Map<String, dynamic>? ?? {};
                    if (domainName == 'agriculture') {
                      final crops = (dData['cropTypes'] as List<dynamic>? ?? []).length;
                      return crops > 0 ? '$crops crops tracked' : defaultText;
                    } else if (domainName == 'health') {
                      return dData['nearestFacility'] != null ? 'PHC Linked' : defaultText;
                    } else if (domainName == 'safety') {
                      final contacts = (dData['emergencyContacts'] as List<dynamic>? ?? []).length;
                      return contacts > 0 ? '$contacts emergency contacts' : defaultText;
                    } else if (domainName == 'education') {
                      return 'Learning active';
                    } else if (domainName == 'governance') {
                      return 'Schemes unlocked';
                    }
                    return defaultText;
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    child: Row(
                      children: [
                        _ServiceCard(
                          title: b.t('Health'),
                          subtitle: getStatus('health', 'Setup Profile'),
                          color: const Color(0xFFE8F5E9),
                          iconBgColor: const Color(0xFFC8E6C9),
                          iconColor: const Color(0xFF2E7D32),
                          icon: Icons.favorite,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdyutaHealthApp())),
                        ),
                        const SizedBox(width: 12),
                        _ServiceCard(
                          title: b.t('Agriculture'),
                          subtitle: getStatus('agriculture', 'Setup Profile'),
                          color: const Color(0xFFF9FBE7),
                          iconBgColor: const Color(0xFFF0F4C3),
                          iconColor: const Color(0xFF827717),
                          icon: Icons.eco,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdyutaAgriApp())),
                        ),
                        const SizedBox(width: 12),
                        _ServiceCard(
                          title: b.t('Safety'),
                          subtitle: getStatus('safety', 'Setup Contacts'),
                          color: const Color(0xFFFFF3E0),
                          iconBgColor: const Color(0xFFFFE0B2),
                          iconColor: const Color(0xFFE65100),
                          icon: Icons.shield,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdyutaSafetyApp())),
                        ),
                        const SizedBox(width: 12),
                        _ServiceCard(
                          title: b.t('Education'),
                          subtitle: getStatus('education', 'Explore Courses'),
                          color: const Color(0xFFF3E5F5),
                          iconBgColor: const Color(0xFFE1BEE7),
                          iconColor: const Color(0xFF4A148C),
                          icon: Icons.school,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdyutaEducationApp())),
                        ),
                        const SizedBox(width: 12),
                        _ServiceCard(
                          title: b.t('Governance'),
                          subtitle: getStatus('governance', 'Check Eligibility'),
                          color: const Color(0xFFE3F2FD),
                          iconBgColor: const Color(0xFFBBDEFB),
                          iconColor: const Color(0xFF0D47A1),
                          icon: Icons.account_balance,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdyutaGovernanceApp())),
                        ),
                      ],
                    ),
                  );
                }
              )
            ],
          ),
        );
      }
    );
  }

  Widget _buildActivityFeed(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final feedAsync = ref.watch(activityFeedProvider);
        
        return Padding(
          key: _updatesKey,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(b.t('Recent Activity'), style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  Icon(Icons.history, color: Colors.grey.shade600, size: 20),
                ],
              ),
              const SizedBox(height: 16),
              feedAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => const Text('Unable to load activity.'),
                data: (logs) {
                  if (logs.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text('No recent activity. Start exploring the modules above!', 
                        style: GoogleFonts.inter(color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: logs.length,
                      separatorBuilder: (_, __) => Divider(color: Colors.grey.shade100, height: 1),
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        IconData icon;
                        Color color;
                        switch (log.domain) {
                          case 'agriculture': icon = Icons.eco; color = const Color(0xFF2E7D32); break;
                          case 'health': icon = Icons.favorite; color = const Color(0xFFD32F2F); break;
                          case 'safety': icon = Icons.shield; color = const Color(0xFFE65100); break;
                          case 'education': icon = Icons.school; color = const Color(0xFF4A148C); break;
                          case 'governance': icon = Icons.account_balance; color = const Color(0xFF0D47A1); break;
                          default: icon = Icons.check_circle; color = Colors.blue; break;
                        }
                        
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                            child: Icon(icon, color: color, size: 20),
                          ),
                          title: Text(log.message, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                          subtitle: Text(DateFormat.yMMMd().add_jm().format(log.createdAt), style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500)),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }
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
            Row(
              children: [
                Image.asset('assets/images/adyuta_logo.png', height: 38),
                const SizedBox(width: 10),
                Text('About Adyuta Platform', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Adyuta is your all-in-one platform bringing essential services, statutory rights, and government schemes to your fingertips.',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.black87, height: 1.4),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showDetailSheet(
                context,
                'About Adyuta Platform',
                'Adyuta stands for illumination and clarity. Our modular Flutter architecture brings together 5 independent pillars into a single cohesive experience:\n\n1. Health Module\n2. Agri & Farming Module\n3. Women & Citizen Safety Module\n4. E-Learn Rural Skills Module\n5. SchemeSaathi Governance & Legal Rights Module.',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3366FF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text('Know More', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        image: const DecorationImage(
          image: AssetImage('assets/images/footer_bg.jpg'),
          fit: BoxFit.cover,
          opacity: 0.25,
        ),
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          Image.asset('assets/images/adyuta_logo.png', height: 110),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '#AdyutaForIndia',
              style: GoogleFonts.caveat(
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF19326A),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 26,
                  height: 16,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: Colors.grey.shade400, width: 0.5),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, 1)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(child: Container(color: const Color(0xFFFF9933))),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: Color(0xFF000080),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container(color: const Color(0xFF138808))),
                    ],
                  ),
                ),
                Text('Made by India', style: GoogleFonts.caveat(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF334155))),
              ],
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite, color: Color(0xFFE11D48), size: 20),
                const SizedBox(width: 6),
                Text('crafted by TwinCiphers at Tech-Pheonix world', style: GoogleFonts.caveat(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF64748B))),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              _FooterLink(label: 'Knowledge Base', onTap: () => _scrollToKey(_updatesKey)),
              _FooterLink(label: 'Security & Safety', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdyutaSafetyApp()))),
              _FooterLink(label: 'Citizen Rights', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdyutaGovernanceApp()))),
              _FooterLink(label: 'Helpline 1930', onTap: () => _showNotificationsDialog(context)),
              _FooterLink(label: 'Terms of Service', onTap: () => _showDetailSheet(context, 'Terms of Service', 'Adyuta provides authentic statutory and government scheme information for educational and citizen empowerment purposes.')),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '© 2026 Adyuta Smart Rural Health & Intelligence Platform. All rights reserved.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavIcon(
              icon: Icons.home,
              label: b.t('Home'),
              isActive: _currentNavIndex == 0,
              onTap: () {
                setState(() => _currentNavIndex = 0);
                _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
              },
            ),
            _NavIcon(
              icon: Icons.grid_view,
              label: b.t('Services'),
              isActive: _currentNavIndex == 1,
              onTap: () {
                setState(() => _currentNavIndex = 1);
                _scrollToKey(_servicesKey);
              },
            ),
            const SizedBox(width: 48), // Space for FAB
            _NavIcon(
              icon: Icons.notifications_active_outlined,
              label: b.t('Updates'),
              isActive: _currentNavIndex == 2,
              onTap: () {
                setState(() => _currentNavIndex = 2);
                _scrollToKey(_updatesKey);
              },
            ),
            _NavIcon(
              icon: Icons.settings_outlined,
              label: b.t('Settings'),
              isActive: _currentNavIndex == 3,
              onTap: () {
                setState(() => _currentNavIndex = 3);
                context.push('/settings');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAIChatbotModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Image.asset('assets/images/adyuta_logo.png', height: 72),
            const SizedBox(height: 16),
            Text('Adyuta AI Assistant', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            Text(
              'Your intelligent rural guide for Government Schemes, Statutory Laws, Health diagnosis, and Farming advice.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const Icon(Icons.psychology, color: Color(0xFF3366FF), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Voice & multilingual AI conversational agent is connected to SchemeSaathi offline directory! (Live LLM streaming interface will be added in upcoming release).',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.black87, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3366FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('Got it, Return to Dashboard', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.notifications_active, color: Color(0xFFE65100)),
            const SizedBox(width: 10),
            Text('Recent Notifications', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NotificationItem(title: '🌾 PM-KISAN 18th Installment', time: '2 hours ago', desc: 'Check your eligibility and land seeding status in Governance tab.'),
            const Divider(),
            _NotificationItem(title: '⚖️ Zero FIR Statutory Right', time: '1 day ago', desc: 'New citizen legal rights guide added under BNSS Section 154.'),
            const Divider(),
            _NotificationItem(title: '🚜 Kisan Credit Card Alert', time: '3 days ago', desc: 'Enjoy 4% p.a. interest rate with prompt repayment subvention.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF3366FF))),
          )
        ],
      ),
    );
  }

  void _showProfileSheet(BuildContext context) {
    context.push('/profile');
  }

  void _showSettingsSheet(BuildContext context) {
    context.push('/settings');
  }

  void _showDetailSheet(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Row(
              children: [
                Image.asset('assets/images/adyuta_logo.png', height: 32),
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF19326A)))),
              ],
            ),
            const SizedBox(height: 16),
            Text(content, style: GoogleFonts.inter(fontSize: 13, color: Colors.black87, height: 1.5)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3366FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('Close', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
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
        width: 115,
        height: 155,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: iconBgColor, width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(fontSize: 10, color: Colors.black54, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}

class _KnowledgeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _KnowledgeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: iconColor.withOpacity(0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const Spacer(),
            Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 2),
            Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavIcon({required this.icon, required this.label, this.isActive = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF3366FF) : Colors.grey.shade500;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            Text(label, style: GoogleFonts.inter(fontSize: 9.5, color: color, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF3366FF)),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String title;
  final String time;
  final String desc;

  const _NotificationItem({required this.title, required this.time, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
              Text(time, style: GoogleFonts.inter(fontSize: 10, color: Colors.grey.shade500)),
            ],
          ),
          const SizedBox(height: 4),
          Text(desc, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}
