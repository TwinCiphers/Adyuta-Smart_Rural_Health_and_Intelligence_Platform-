import 'package:bhashini_core/bhashini_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/safety_theme.dart';
import '../../core/services/safety_guide_service.dart';
import '../../core/db/safety_database.dart';

class SafetyTipsScreen extends StatefulWidget {
  const SafetyTipsScreen({super.key});

  @override
  State<SafetyTipsScreen> createState() => _SafetyTipsScreenState();
}

class _SafetyTipsScreenState extends State<SafetyTipsScreen> {
  List<SafetyGuide> _guides = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await SafetyGuideService.syncGuides();
    final data = await SafetyGuideService.getGuides();
    if (mounted) {
      setState(() {
        _guides = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: SafetyTheme.primaryRed))
        : CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalBhashiniText('Safety Guide & Legal Rights', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: SafetyTheme.textDark)),
                  const SizedBox(height: 8),
                  GlobalBhashiniText('Empower yourself with actionable knowledge and legal protections offline. Synced from NDMA and IndiaCode.',
                      style: GoogleFonts.inter(fontSize: 14, color: SafetyTheme.textGrey, height: 1.4)),
                  const SizedBox(height: 24),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _guides.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final guide = _guides[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GlobalBhashiniText(guide.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: SafetyTheme.textDark)),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.orange.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                                  child: GlobalBhashiniText(guide.category, style: GoogleFonts.inter(fontSize: 10, color: Colors.orange.shade800, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            GlobalBhashiniText(guide.content, style: GoogleFonts.inter(fontSize: 14, color: SafetyTheme.textGrey, height: 1.5)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.verified_user, size: 14, color: SafetyTheme.primaryRed),
                                const SizedBox(width: 4),
                                GlobalBhashiniText('Source: ${guide.source}', style: GoogleFonts.inter(fontSize: 11, color: SafetyTheme.primaryRed, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
