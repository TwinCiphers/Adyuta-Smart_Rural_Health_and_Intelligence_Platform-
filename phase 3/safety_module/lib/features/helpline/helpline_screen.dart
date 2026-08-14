import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/safety_theme.dart';

class HelplineItem {
  final String title;
  final String number;
  final String description;
  final IconData icon;
  final Color color;
  const HelplineItem({
    required this.title,
    required this.number,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class HelplineScreen extends StatelessWidget {
  const HelplineScreen({super.key});

  final List<HelplineItem> _helplines = const [
    HelplineItem(
      title: 'National Emergency Number',
      number: '112',
      description: 'All-in-one emergency dispatch for Police, Fire, and Ambulance.',
      icon: Icons.emergency,
      color: Color(0xFFDC2626),
    ),
    HelplineItem(
      title: 'Women Helpline (All India)',
      number: '1091',
      description: '24/7 immediate assistance and counseling for women in distress.',
      icon: Icons.support_agent,
      color: Color(0xFFE11D48),
    ),
    HelplineItem(
      title: 'Police Control Room',
      number: '100',
      description: 'Direct connection to local law enforcement and patrol units.',
      icon: Icons.local_police,
      color: Color(0xFF2563EB),
    ),
    HelplineItem(
      title: 'Domestic Abuse & Violence',
      number: '181',
      description: 'Abhayam women helpline for crisis intervention and shelter support.',
      icon: Icons.shield,
      color: Color(0xFF9333EA),
    ),
    HelplineItem(
      title: 'National Cyber Crime Helpline',
      number: '1930',
      description: 'Report online harassment, cyberstalking, and financial fraud.',
      icon: Icons.security,
      color: Color(0xFF0D9488),
    ),
    HelplineItem(
      title: 'Ambulance & Medical Emergency',
      number: '102',
      description: 'Emergency medical transport and hospital admission assistance.',
      icon: Icons.medical_services,
      color: Color(0xFF16A34A),
    ),
    HelplineItem(
      title: 'Childline India',
      number: '1098',
      description: 'Free emergency helpline for children and minors in need of aid.',
      icon: Icons.child_care,
      color: Color(0xFFEA580C),
    ),
    HelplineItem(
      title: 'National Commission for Women',
      number: '7827170170',
      description: 'WhatsApp & Helpline for legal rights complaints and grievance redressal.',
      icon: Icons.gavel,
      color: Color(0xFF4F46E5),
    ),
  ];

  Future<void> _makeCall(BuildContext context, String number) async {
    final cleanNum = number.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanNum');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        await launchUrl(uri);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open dialer for $cleanNum: $e')),
        );
      }
    }
  }

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
            title: Text('Emergency Helplines', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: SafetyTheme.textDark)),
            centerTitle: false,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFECACA)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: SafetyTheme.primaryRed, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tap any helpline button to immediately connect with verified 24/7 emergency response centers across India.',
                            style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF7F1D1D), height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _helplines.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _helplines[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: SafetyTheme.cardShadow,
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: item.color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(item.icon, color: item.color, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: SafetyTheme.textDark),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.description,
                                    style: GoogleFonts.inter(fontSize: 12, color: SafetyTheme.textGrey, height: 1.3),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: () => _makeCall(context, item.number),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: item.color,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              ),
                              icon: const Icon(Icons.call, size: 16),
                              label: Text(item.number, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ],
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
