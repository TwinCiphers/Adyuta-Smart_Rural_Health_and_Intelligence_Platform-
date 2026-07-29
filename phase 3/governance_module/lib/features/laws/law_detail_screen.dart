import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/gov_theme.dart';
import '../../models/models.dart';

class LawDetailScreen extends StatelessWidget {
  final StatutoryLaw law;

  const LawDetailScreen({super.key, required this.law});

  Future<void> _launchOfficialUrl(BuildContext context) async {
    final uri = Uri.parse(law.officialUrl);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        await launchUrl(uri);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open portal: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Statutory Law & Citizen Right', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(gradient: GovTheme.navyGradient),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: GovTheme.saffronGold, borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      law.domain.toUpperCase(),
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    law.title,
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    law.actCitation,
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.white70, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Citation Tag
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.gavel, color: Color(0xFF1D4ED8), size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Statutory Provision: ${law.sectionNumber}',
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF1E3A8A)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text('Legal Summary & Provision', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 17, color: GovTheme.textDark)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: GovTheme.borderLight),
                      boxShadow: GovTheme.cardShadow,
                    ),
                    child: Text(
                      law.plainExplanation,
                      style: GoogleFonts.inter(fontSize: 15, color: GovTheme.textDark, height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Citizen Rights & Action Steps Box
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFED7AA), width: 1.5),
                      boxShadow: GovTheme.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.shield_outlined, color: Color(0xFFC2410C), size: 22),
                            const SizedBox(width: 8),
                            Text('Your Statutory Rights & Action Steps', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF7C2D12))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: law.citizenRights.map((right) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle, color: Color(0xFFEA580C), size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    right,
                                    style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF9A3412), height: 1.4, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchOfficialUrl(context),
                      icon: const Icon(Icons.policy),
                      label: Text('Visit Official Government / Regulatory Portal', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GovTheme.saffronGold,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
