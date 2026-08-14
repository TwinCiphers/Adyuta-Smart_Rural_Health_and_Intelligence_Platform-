import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/agri_theme.dart';
import '../mandi/mandi_prices_screen.dart';
import '../yojna/yojna_screen.dart';
import '../weather/weather_screen.dart';
import '../marketplace/marketplace_screen.dart';
import '../community/community_screen.dart';

class AgriDashboardScreen extends StatelessWidget {
  const AgriDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AgriTheme.lightGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.agriculture, color: AgriTheme.primaryGreen, size: 24),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Adyuta Agriculture', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: AgriTheme.textDark)),
                Text('Smart Solutions for Farmers', style: GoogleFonts.outfit(fontSize: 11, color: AgriTheme.textMuted)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AgriTheme.textDark),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AgriTheme.heroGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AgriTheme.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '👨‍🌾 Kisan Shakti Hub',
                      style: GoogleFonts.outfit(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Empowering Farmers with\nTechnology & Intelligence',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Live APMC Mandi rates, weather advisories, government schemes, and organic marketplace.',
                    style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MandiPricesScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AgriTheme.accentGold,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    icon: const Icon(Icons.trending_up, size: 18),
                    label: Text('Check Today\'s Mandi Rates', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Live Mandi Ticker Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AgriTheme.cardShadow,
                border: Border.all(color: AgriTheme.borderLight),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AgriTheme.amberLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.storefront, color: AgriTheme.accentGold, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Wheat (Lok-1)', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15, color: AgriTheme.textDark)),
                            Text('₹2,650 / Qtl', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15, color: AgriTheme.primaryGreen)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Indore Mandi • Today', style: GoogleFonts.outfit(fontSize: 12, color: AgriTheme.textMuted)),
                            Text('+₹45 Today', style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 12, color: AgriTheme.priceUp)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Services Grid
            Text('Farmer Services & Tools', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AgriTheme.textDark)),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.92,
              children: [
                _AgriServiceCard(
                  title: 'APMC Rates',
                  subtitle: 'Daily Crop Mandi Prices',
                  icon: Icons.analytics,
                  color: const Color(0xFFE8F5EE),
                  iconColor: AgriTheme.primaryGreen,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MandiPricesScreen())),
                ),
                _AgriServiceCard(
                  title: 'Kisan Yojnas',
                  subtitle: 'Government Schemes & Support',
                  icon: Icons.account_balance,
                  color: const Color(0xFFFEF3C7),
                  iconColor: AgriTheme.accentGold,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const YojnaScreen())),
                ),
                _AgriServiceCard(
                  title: 'Weather Advisory',
                  subtitle: 'Live Forecast & Crop Advice',
                  icon: Icons.wb_sunny,
                  color: const Color(0xFFE0F2FE),
                  iconColor: const Color(0xFF0284C7),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WeatherScreen())),
                ),
                _AgriServiceCard(
                  title: 'Marketplace',
                  subtitle: 'Seeds, Tools & Fertilizers',
                  icon: Icons.shopping_cart,
                  color: const Color(0xFFF3E8FF),
                  iconColor: const Color(0xFF9333EA),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketplaceScreen())),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Featured Knowledge Banner
            InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CommunityScreen())),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AgriTheme.cardShadow,
                  border: Border.all(color: AgriTheme.borderLight),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.menu_book, color: Color(0xFFEA580C), size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kisan Knowledge Hub (XML Edition)', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: AgriTheme.textDark)),
                          const SizedBox(height: 4),
                          Text('Explore 16+ interactive XML knowledge base manuals, PM-KISAN studies, crop protocols & FAOSTAT datasets with offline keyword search.', style: GoogleFonts.outfit(fontSize: 12, color: AgriTheme.textMuted)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: AgriTheme.textMuted),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _AgriServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _AgriServiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AgriTheme.cardShadow,
          border: Border.all(color: AgriTheme.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: AgriTheme.textDark)),
                const SizedBox(height: 2),
                Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.outfit(fontSize: 11, color: AgriTheme.textMuted, height: 1.2)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
