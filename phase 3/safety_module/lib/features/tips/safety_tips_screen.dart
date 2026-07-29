import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/safety_theme.dart';

class SafetyTipCategory {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<String> tips;
  const SafetyTipCategory({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.tips,
  });
}

class SafetyTipsScreen extends StatelessWidget {
  const SafetyTipsScreen({super.key});

  final List<SafetyTipCategory> _categories = const [
    SafetyTipCategory(
      title: 'Self-Defense Essentials',
      subtitle: 'Physical readiness and personal protection',
      icon: Icons.security,
      color: Color(0xFFDC2626),
      tips: [
        'Maintain situational awareness: Avoid wearing headphones or scrolling on your phone when walking alone in secluded areas.',
        'Trust your instincts: If a street, cab, or individual feels unsafe, immediately move toward a crowded commercial shop or bank.',
        'Know key pressure points: In an attack, target vulnerable areas such as the eyes, nose, throat, groin, or instep with decisive force.',
        'Carry safety tools: Always keep a pepper spray canister or personal safety alarm accessible in your hand or outer jacket pocket.',
        'Use vocal deterrents: Shout "Fire!" or "Police!" loudly instead of just screaming, as specific emergency words attract faster bystander intervention.',
      ],
    ),
    SafetyTipCategory(
      title: 'Cab & Travel Guidelines',
      subtitle: 'Commute security for taxis, autos, and transit',
      icon: Icons.local_taxi,
      color: Color(0xFF2563EB),
      tips: [
        'Verify before boarding: Always match the taxi/auto license plate, driver photo, and car model with your booking app details.',
        'Share trip status: Use the "Share Live Trip" feature with trusted family members before stepping into a cab.',
        'Sit in the back seat: Always occupy the rear seat diagonally opposite the driver to maintain maximum personal space and visibility.',
        'Monitor GPS navigation: Keep your own maps app open to ensure the driver is strictly following the standard route without unauthorized detours.',
        'Check child locks: Ensure rear passenger doors can be opened from the inside before closing the door in unfamiliar vehicles.',
      ],
    ),
    SafetyTipCategory(
      title: 'Digital & Cyber Safety',
      subtitle: 'Online privacy, social media, and harassment defense',
      icon: Icons.phonelink_lock,
      color: Color(0xFF0D9488),
      tips: [
        'Enable 2-Factor Authentication (2FA): Protect all email, banking, and social media accounts with authenticator apps or biometric locks.',
        'Disable location metadata: Turn off automatic geo-tagging on smartphone camera photos before posting pictures on public social media platforms.',
        'Report cyber stalking: Immediately call 1930 or file a complaint on cybercrime.gov.in for online harassment, morphing, or blackmail.',
        'Beware of phishing: Never share OTPs, banking UPI PINs, or personal identity documents with unverified callers claiming to be bank or courier agents.',
      ],
    ),
    SafetyTipCategory(
      title: 'Legal Rights of Women',
      subtitle: 'Indian constitutional protections and emergency laws',
      icon: Icons.gavel,
      color: Color(0xFF9333EA),
      tips: [
        'Right to Zero FIR: You can file an FIR at ANY police station regardless of jurisdiction or where the incident occurred. The police must register and transfer it.',
        'No arrest after sunset: Under Section 46(4) of CrPC, a woman cannot be arrested after sunset and before sunrise without prior orders from a Judicial Magistrate.',
        'Right to privacy in recording statements: Under Section 164 of CrPC, a woman victim\'s statement can be recorded in private, preferably by a woman police officer.',
        'Free Legal Aid: Under the Legal Services Authorities Act, women are entitled to free legal counsel and representation in court proceedings.',
        'Protection against workplace harassment: The POSH Act mandates every organization with 10+ employees to have an Internal Complaints Committee (ICC).',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            elevation: 0,
            title: Text('Safety Guide & Legal Rights', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: SafetyTheme.textDark)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Empower yourself with actionable self-defense knowledge, legal protections, and smart travel habits ported directly from the SheGuard safety handbook.',
                    style: GoogleFonts.inter(fontSize: 13, color: SafetyTheme.textGrey, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: SafetyTheme.cardShadow,
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: cat.color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(cat.icon, color: cat.color, size: 26),
                            ),
                            title: Text(
                              cat.title,
                              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: SafetyTheme.textDark),
                            ),
                            subtitle: Text(
                              cat.subtitle,
                              style: GoogleFonts.inter(fontSize: 12, color: SafetyTheme.textGrey),
                            ),
                            children: cat.tips.map((tip) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.check_circle, color: cat.color, size: 18),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        tip,
                                        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF334155), height: 1.4),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
