import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/gov_theme.dart';
import '../../models/models.dart';
import '../../services/gov_storage_service.dart';

class SchemeDetailScreen extends StatefulWidget {
  final GovernmentScheme scheme;

  const SchemeDetailScreen({super.key, required this.scheme});

  @override
  State<SchemeDetailScreen> createState() => _SchemeDetailScreenState();
}

class _SchemeDetailScreenState extends State<SchemeDetailScreen> {
  late bool _isBookmarked;
  List<String> _readyDocNames = [];

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.scheme.isBookmarked;
    _checkReadyDocuments();
  }

  Future<void> _checkReadyDocuments() async {
    final docs = await GovStorageService.loadDocumentsWithStatus();
    if (mounted) {
      setState(() {
        _readyDocNames = docs.where((d) => d.isReady).map((d) => d.docName.toLowerCase()).toList();
      });
    }
  }

  Future<void> _toggleBookmark() async {
    final newState = !_isBookmarked;
    setState(() {
      _isBookmarked = newState;
      widget.scheme.isBookmarked = newState;
    });
    await GovStorageService.toggleSchemeBookmark(widget.scheme.id, newState);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newState ? '📌 Scheme bookmarked to your saved folder' : 'Removed from saved schemes',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: newState ? GovTheme.emeraldGreen : GovTheme.textGrey,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _launchPortal() async {
    final uri = Uri.parse(widget.scheme.officialWebsite);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        await launchUrl(uri);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open website: $e')));
      }
    }
  }

  bool _isDocReady(String reqDoc) {
    final reqLower = reqDoc.toLowerCase();
    for (var ready in _readyDocNames) {
      if (reqLower.contains('aadhaar') && ready.contains('aadhaar')) return true;
      if (reqLower.contains('pan') && ready.contains('pan')) return true;
      if (reqLower.contains('land') && ready.contains('land')) return true;
      if (reqLower.contains('bank') && ready.contains('bank')) return true;
      if (reqLower.contains('caste') && ready.contains('caste')) return true;
      if (reqLower.contains('income') && ready.contains('income')) return true;
      if (reqLower.contains('mgnrega') && ready.contains('mgnrega')) return true;
      if (reqLower.contains('job card') && ready.contains('job card')) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('SchemeSaathi Detail', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          IconButton(
            icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: _isBookmarked ? GovTheme.saffronGold : Colors.white),
            onPressed: _toggleBookmark,
          ),
        ],
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
                      widget.scheme.category.toUpperCase(),
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.scheme.title,
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.account_balance, size: 16, color: Colors.white70),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.scheme.ministry,
                          style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Benefits Box
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
                      boxShadow: GovTheme.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.stars, color: GovTheme.emeraldGreen, size: 22),
                            const SizedBox(width: 8),
                            Text('Statutory Scheme Benefits', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF14532D))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.scheme.benefits,
                          style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF166534), height: 1.5, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Target Beneficiaries
                  Text('Target Beneficiaries', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 17, color: GovTheme.textDark)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: GovTheme.borderLight),
                      boxShadow: GovTheme.cardShadow,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.groups, color: GovTheme.accentBlue, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.scheme.beneficiaries,
                            style: GoogleFonts.inter(fontSize: 14, color: GovTheme.textDark, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Eligibility Criteria
                  Text('Eligibility Criteria', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 17, color: GovTheme.textDark)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: GovTheme.borderLight),
                      boxShadow: GovTheme.cardShadow,
                    ),
                    child: Column(
                      children: widget.scheme.eligibilityCriteria.map((crit) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline, color: GovTheme.accentBlue, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(crit, style: GoogleFonts.inter(fontSize: 14, color: GovTheme.textDark, height: 1.4)),
                            ),
                          ],
                        ),
                      )).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Required Documents with Vault Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Required Documents', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 17, color: GovTheme.textDark)),
                      Text('Checked vs. Vault', style: GoogleFonts.inter(fontSize: 12, color: GovTheme.textGrey, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.scheme.requiredDocuments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final doc = widget.scheme.requiredDocuments[index];
                      final isReady = _isDocReady(doc);
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isReady ? const Color(0xFFF0FDF4) : const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isReady ? const Color(0xFF86EFAC) : const Color(0xFFFED7AA)),
                        ),
                        child: Row(
                          children: [
                            Icon(isReady ? Icons.verified : Icons.error_outline, color: isReady ? GovTheme.emeraldGreen : GovTheme.saffronGold, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                doc,
                                style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: isReady ? const Color(0xFF166534) : const Color(0xFF9A3412)),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isReady ? const Color(0xFFDCFCE7) : const Color(0xFFFFEDD5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isReady ? 'READY' : 'NEEDED',
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 11, color: isReady ? GovTheme.emeraldGreen : const Color(0xFFC2410C)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Apply Portal Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _launchPortal,
                      icon: const Icon(Icons.open_in_new),
                      label: Text('Apply Online / Official Portal', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GovTheme.accentBlue,
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
