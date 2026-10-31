import 'package:bhashini_core/bhashini_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/agri_theme.dart';

class YojnaScreen extends StatelessWidget {
  const YojnaScreen({super.key});

  final List<Map<String, String>> _yojnas = const [
    {
      'title': 'PM-Kisan Samman Nidhi',
      'subtitle': 'Financial support of ₹6,000 per year for all landholding farmer families across the country.',
      'benefit': '₹6,000 / Year in 3 equal installments',
      'eligibility': 'All landholding farming families with cultivable land.',
      'status': 'Active Scheme',
      'tag': 'Direct Benefit Transfer',
      'url': 'https://pmkisan.gov.in/'
    },
    {
      'title': 'PM Fasal Bima Yojana (PMFBY)',
      'subtitle': 'Comprehensive crop insurance coverage against non-preventable natural risks from pre-sowing to post-harvest.',
      'benefit': 'Full insurance claim against yield losses',
      'eligibility': 'Farmers growing notified crops in notified areas.',
      'status': 'Open for Kharif/Rabi',
      'tag': 'Crop Insurance',
      'url': 'https://pmfby.gov.in/'
    },
    {
      'title': 'Soil Health Card Scheme',
      'subtitle': 'Provides soil health cards to farmers with crop-wise nutrient recommendations and fertilizer advisories.',
      'benefit': 'Free soil testing & nutrient mapping report',
      'eligibility': 'Available to all Indian farmers.',
      'status': 'Ongoing',
      'tag': 'Soil Advisory',
      'url': 'https://soilhealth.dac.gov.in/'
    },
    {
      'title': 'Kisan Credit Card (KCC)',
      'subtitle': 'Institutional credit to farmers for agricultural requirements at subsidized interest rates (2% to 4%).',
      'benefit': 'Subsidized loan up to ₹3 Lakhs',
      'eligibility': 'Individual/joint borrowers who are owner cultivators.',
      'status': 'Bank Apply',
      'tag': 'Subsidized Loan',
      'url': 'https://sbi.co.in/web/agri-rural/agriculture-banking/crop-loan/kisan-credit-card'
    },
    {
      'title': 'Paramparagat Krishi Vikas Yojana',
      'subtitle': 'Promotes organic farming clusters and provides assistance for certification and marketing.',
      'benefit': '₹50,000 per hectare for 3 years',
      'eligibility': 'Farmers forming organic clusters of 20 ha or more.',
      'status': 'Cluster Based',
      'tag': 'Organic Farming',
      'url': 'https://pgsindia-ncof.gov.in/'
    },
  ];

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: GlobalBhashiniText('Could not open link. Please check your internet connection.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const GlobalBhashiniText('Government Kisan Schemes'),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _yojnas.length,
        itemBuilder: (context, index) {
          final y = _yojnas[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AgriTheme.cardShadow,
              border: Border.all(color: AgriTheme.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AgriTheme.lightGreen,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AgriTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: GlobalBhashiniText(
                          y['tag']!,
                          style: GoogleFonts.outfit(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.verified, color: AgriTheme.primaryGreen, size: 16),
                          const SizedBox(width: 4),
                          GlobalBhashiniText(
                            y['status']!,
                            style: GoogleFonts.outfit(color: AgriTheme.primaryGreen, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlobalBhashiniText(
                        y['title']!,
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: AgriTheme.textDark),
                      ),
                      const SizedBox(height: 6),
                      GlobalBhashiniText(
                        y['subtitle']!,
                        style: GoogleFonts.outfit(fontSize: 14, color: AgriTheme.textMuted, height: 1.4),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AgriTheme.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AgriTheme.borderLight),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.monetization_on, color: AgriTheme.accentGold, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: GlobalBhashiniText(
                                    'Benefit: ${y['benefit']!}',
                                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 13, color: AgriTheme.textDark),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.people_alt, color: AgriTheme.primaryGreen, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: GlobalBhashiniText(
                                    'Eligibility: ${y['eligibility']!}',
                                    style: GoogleFonts.outfit(fontSize: 12, color: AgriTheme.textMuted),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _launchUrl(context, y['url']!),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AgriTheme.primaryGreen,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.launch, size: 16),
                              label: GlobalBhashiniText('Apply / Know More', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: GlobalBhashiniText('Saved "${y['title']}" to your bookmarks')),
                              );
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: AgriTheme.lightGreen,
                              foregroundColor: AgriTheme.primaryGreen,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.bookmark_border),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
