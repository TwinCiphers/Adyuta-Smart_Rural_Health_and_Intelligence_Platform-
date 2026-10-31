import 'package:bhashini_core/bhashini_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/safety_theme.dart';
import '../../core/services/helpline_service.dart';
import '../../core/db/safety_database.dart';

class HelplineScreen extends StatefulWidget {
  const HelplineScreen({super.key});

  @override
  State<HelplineScreen> createState() => _HelplineScreenState();
}

class _HelplineScreenState extends State<HelplineScreen> {
  List<Helpline> _helplines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    // Sync from GitHub/Gov first
    await HelplineService.syncHelplines();
    // Load from local Drift DB
    final data = await HelplineService.getHelplines();
    if (mounted) {
      setState(() {
        _helplines = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _callNumber(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
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
                  GlobalBhashiniText('Emergency Helplines', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: SafetyTheme.textDark)),
                  const SizedBox(height: 8),
                  GlobalBhashiniText('Tap any helpline button to immediately connect with verified emergency response centers. Synced from National Portal & Open Helplines.',
                      style: GoogleFonts.inter(fontSize: 14, color: SafetyTheme.textGrey, height: 1.4)),
                  const SizedBox(height: 24),
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
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: SafetyTheme.primaryRed.withOpacity(0.1), shape: BoxShape.circle),
                              child: const Icon(Icons.phone_in_talk, color: SafetyTheme.primaryRed),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GlobalBhashiniText(item.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: SafetyTheme.textDark)),
                                  if (item.description != null) ...[
                                    const SizedBox(height: 4),
                                    GlobalBhashiniText(item.description!, style: GoogleFonts.inter(fontSize: 12, color: SafetyTheme.textGrey)),
                                  ],
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
                                    child: GlobalBhashiniText(item.source, style: GoogleFonts.inter(fontSize: 9, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _callNumber(item.number),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: SafetyTheme.primaryRed,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                elevation: 0,
                              ),
                              child: GlobalBhashiniText(item.number, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
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
