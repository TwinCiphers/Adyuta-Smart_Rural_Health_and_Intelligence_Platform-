import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/gov_theme.dart';
import '../../models/models.dart';
import '../../services/gov_storage_service.dart';

class DocVaultScreen extends StatefulWidget {
  const DocVaultScreen({super.key});

  @override
  State<DocVaultScreen> createState() => _DocVaultScreenState();
}

class _DocVaultScreenState extends State<DocVaultScreen> {
  List<CitizenDocument> _documents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDocs();
  }

  Future<void> _loadDocs() async {
    setState(() => _isLoading = true);
    final docs = await GovStorageService.loadDocumentsWithStatus();
    if (mounted) {
      setState(() {
        _documents = docs;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleDoc(CitizenDocument doc) async {
    final newState = !doc.isReady;
    setState(() {
      doc.isReady = newState;
    });
    await GovStorageService.toggleDocumentReady(doc.id, newState);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newState ? '✅ Checked! Marked ${doc.docName} as ready in your vault.' : 'Unmarked ${doc.docName}',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: newState ? GovTheme.emeraldGreen : GovTheme.textGrey,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final readyCount = _documents.where((d) => d.isReady).length;
    final totalCount = _documents.length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: GovTheme.accentBlue))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Status Banner
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: GovTheme.navyGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: GovTheme.elevationShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'MY CITIZEN DOCUMENT VAULT',
                              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 11, color: GovTheme.saffronGold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: GovTheme.emeraldGreen, borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                '$readyCount / $totalCount READY',
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'SchemeSaathi Eligibility Checklist',
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Check off the documents you currently possess. When you view government schemes, SchemeSaathi automatically alerts you whether you have all required proofs ready!',
                          style: GoogleFonts.inter(fontSize: 13, color: Colors.white70, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text('Essential Documents Checklist', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: GovTheme.textDark)),
                  const SizedBox(height: 4),
                  Text('Tap any document card to toggle readiness status.', style: GoogleFonts.inter(fontSize: 13, color: GovTheme.textGrey)),
                  const SizedBox(height: 16),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _documents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final doc = _documents[index];
                      return InkWell(
                        onTap: () => _toggleDoc(doc),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: doc.isReady ? const Color(0xFF86EFAC) : GovTheme.borderLight, width: doc.isReady ? 1.5 : 1),
                            boxShadow: GovTheme.cardShadow,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: doc.isReady ? GovTheme.emeraldGreen : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: doc.isReady ? GovTheme.emeraldGreen : GovTheme.textGrey, width: 2),
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 16,
                                  color: doc.isReady ? Colors.white : Colors.transparent,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            doc.docName,
                                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: doc.isReady ? const Color(0xFF166534) : GovTheme.textDark),
                                          ),
                                        ),
                                        if (doc.isReady)
                                          Text('READY', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 11, color: GovTheme.emeraldGreen)),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(doc.issuer, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: GovTheme.accentBlue)),
                                    const SizedBox(height: 6),
                                    Text(doc.description, style: GoogleFonts.inter(fontSize: 13, color: GovTheme.textGrey, height: 1.4)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}
