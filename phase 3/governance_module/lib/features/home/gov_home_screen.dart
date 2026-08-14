import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/gov_theme.dart';
import '../../models/models.dart';
import '../../data/gov_data.dart';
import '../../services/gov_storage_service.dart';
import '../schemes/scheme_detail_screen.dart';
import '../laws/law_detail_screen.dart';
import '../vault/doc_vault_screen.dart';

class GovHomeScreen extends StatefulWidget {
  const GovHomeScreen({super.key});

  @override
  State<GovHomeScreen> createState() => _GovHomeScreenState();
}

class _GovHomeScreenState extends State<GovHomeScreen> {
  int _currentTabIndex = 0;

  // Schemes tab state
  List<GovernmentScheme> _allSchemes = [];
  String _selectedSchemeCategory = 'All';
  String _schemeSearchQuery = '';
  final List<String> _schemeCategories = ['All', 'Agri & Rural', 'Finance', 'Welfare', 'Health', 'Skills', 'Women & Child', 'Saved Only'];

  // Laws tab state
  List<StatutoryLaw> _allLaws = [];
  String _selectedLawDomain = 'All';
  String _lawSearchQuery = '';
  final List<String> _lawDomains = ['All', 'Constitution', 'RBI & Finance', 'Police & FIR', 'Cyberlaws', 'Farmer Rights', 'Labor & MGNREGA'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final schemes = await GovStorageService.loadSchemesWithStatus();
    setState(() {
      _allSchemes = schemes;
      _allLaws = GovCatalog.laws;
    });
  }

  List<GovernmentScheme> get _filteredSchemes {
    return _allSchemes.where((s) {
      final matchesCategory = _selectedSchemeCategory == 'All' ||
          (_selectedSchemeCategory == 'Saved Only' ? s.isBookmarked : s.category.toLowerCase() == _selectedSchemeCategory.toLowerCase());
      final matchesSearch = _schemeSearchQuery.isEmpty ||
          s.title.toLowerCase().contains(_schemeSearchQuery.toLowerCase()) ||
          s.ministry.toLowerCase().contains(_schemeSearchQuery.toLowerCase()) ||
          s.benefits.toLowerCase().contains(_schemeSearchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<StatutoryLaw> get _filteredLaws {
    return _allLaws.where((l) {
      final matchesDomain = _selectedLawDomain == 'All' || l.domain.toLowerCase() == _selectedLawDomain.toLowerCase();
      final matchesSearch = _lawSearchQuery.isEmpty ||
          l.title.toLowerCase().contains(_lawSearchQuery.toLowerCase()) ||
          l.actCitation.toLowerCase().contains(_lawSearchQuery.toLowerCase()) ||
          l.plainExplanation.toLowerCase().contains(_lawSearchQuery.toLowerCase());
      return matchesDomain && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.account_balance, color: GovTheme.saffronGold),
            const SizedBox(width: 10),
            Text('Adyuta SchemeSaathi & Citizen Rights', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          _buildSchemesTab(),
          _buildLawsTab(),
          const DocVaultScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentTabIndex,
          onTap: (index) {
            setState(() {
              _currentTabIndex = index;
              if (index == 0) _loadData(); // Refresh saved status
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: GovTheme.accentBlue,
          unselectedItemColor: GovTheme.textGrey,
          selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: 'Schemes'),
            BottomNavigationBarItem(icon: Icon(Icons.gavel_outlined), activeIcon: Icon(Icons.gavel), label: 'Citizen Rights'),
            BottomNavigationBarItem(icon: Icon(Icons.folder_shared_outlined), activeIcon: Icon(Icons.folder_shared), label: 'Doc Vault'),
          ],
        ),
      ),
    );
  }

  Widget _buildSchemesTab() {
    final schemes = _filteredSchemes;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Banner
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: GovTheme.saffronGold, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    'AI SCHEME EXPLORER',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Empowering Rural Citizens with Entitlements',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Explore over 1,800+ national and state schemes. Check eligibility and verify your document readiness instantly.',
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search schemes by keyword, crop, loan, benefits...',
              hintStyle: GoogleFonts.inter(color: GovTheme.textGrey, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: GovTheme.accentBlue),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: GovTheme.borderLight)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: GovTheme.borderLight)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: GovTheme.accentBlue, width: 2)),
            ),
            onChanged: (val) => setState(() => _schemeSearchQuery = val),
          ),
          const SizedBox(height: 16),

          // Category Pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _schemeCategories.map((cat) {
                final isSelected = _selectedSchemeCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat, style: GoogleFonts.inter(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedSchemeCategory = cat),
                    selectedColor: GovTheme.accentBlue,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : GovTheme.textDark),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? GovTheme.accentBlue : GovTheme.borderLight)),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          if (schemes.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Icon(Icons.search_off, size: 48, color: GovTheme.textGrey),
                    const SizedBox(height: 12),
                    Text('No schemes found matching criteria.', style: GoogleFonts.inter(fontSize: 15, color: GovTheme.textGrey)),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: schemes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final scheme = schemes[index];
                return InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SchemeDetailScreen(scheme: scheme)),
                    );
                    _loadData();
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: GovTheme.borderLight),
                      boxShadow: GovTheme.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
                              child: Text(scheme.category, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 11, color: GovTheme.accentBlue)),
                            ),
                            Icon(scheme.isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: scheme.isBookmarked ? GovTheme.saffronGold : GovTheme.textGrey, size: 20),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(scheme.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: GovTheme.textDark)),
                        const SizedBox(height: 4),
                        Text(scheme.ministry, style: GoogleFonts.inter(fontSize: 12, color: GovTheme.textGrey, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        Text(
                          scheme.benefits,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(fontSize: 13, color: GovTheme.textDark, height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('View Eligibility & Apply', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: GovTheme.accentBlue)),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_ios, size: 12, color: GovTheme.accentBlue),
                          ],
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
    );
  }

  Widget _buildLawsTab() {
    final laws = _filteredLaws;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C2D12), Color(0xFFC2410C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: GovTheme.elevationShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    'AUTHENTIC STATUTORY RIGHTS',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 10, color: const Color(0xFF9A3412)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Know Your Constitutional & Legal Rights',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Strictly zero mock data. Explore verbatim Indian statutes on KCC interest subvention, Zero FIR rights, RBI banking fraud protections, and MGNREGA unemployment allowance.',
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search laws by Article, Section, RBI, FIR, Cyber...',
              hintStyle: GoogleFonts.inter(color: GovTheme.textGrey, fontSize: 14),
              prefixIcon: const Icon(Icons.gavel, color: Color(0xFFC2410C)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: GovTheme.borderLight)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: GovTheme.borderLight)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFC2410C), width: 2)),
            ),
            onChanged: (val) => setState(() => _lawSearchQuery = val),
          ),
          const SizedBox(height: 16),

          // Domain Pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _lawDomains.map((dom) {
                final isSelected = _selectedLawDomain == dom;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(dom, style: GoogleFonts.inter(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedLawDomain = dom),
                    selectedColor: const Color(0xFFEA580C),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : GovTheme.textDark),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? const Color(0xFFEA580C) : GovTheme.borderLight)),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          if (laws.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Icon(Icons.search_off, size: 48, color: GovTheme.textGrey),
                    const SizedBox(height: 12),
                    Text('No statutory provisions found matching query.', style: GoogleFonts.inter(fontSize: 15, color: GovTheme.textGrey)),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: laws.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final law = laws[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LawDetailScreen(law: law)),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: GovTheme.borderLight),
                      boxShadow: GovTheme.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(8)),
                              child: Text(law.domain, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 11, color: const Color(0xFFC2410C))),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                law.sectionNumber,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: GovTheme.accentBlue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(law.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: GovTheme.textDark)),
                        const SizedBox(height: 4),
                        Text(law.actCitation, style: GoogleFonts.inter(fontSize: 12, color: GovTheme.textGrey, fontStyle: FontStyle.italic)),
                        const SizedBox(height: 10),
                        Text(
                          law.plainExplanation,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(fontSize: 13, color: GovTheme.textDark, height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Read Legal Rights & Actions', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFFC2410C))),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFFC2410C)),
                          ],
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
    );
  }
}
