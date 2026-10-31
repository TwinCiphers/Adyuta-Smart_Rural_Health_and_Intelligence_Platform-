import 'package:bhashini_core/bhashini_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/agri_theme.dart';
import '../../core/db/agri_database.dart';
import '../../core/services/mandi_service.dart';

/// Mandi Prices Screen — live commodity prices from Agmarknet via data.gov.in.
///
/// Online: fetches real prices from the OGD API and caches them locally.
/// Offline: shows cached prices with a "Cached" badge and last-sync timestamp.
/// No key: shows a registration prompt instead of an empty list.
class MandiPricesScreen extends StatefulWidget {
  const MandiPricesScreen({super.key});

  @override
  State<MandiPricesScreen> createState() => _MandiPricesScreenState();
}

class _MandiPricesScreenState extends State<MandiPricesScreen> {
  String _selectedState = 'Karnataka';
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _states = [
    'Karnataka', 'Maharashtra', 'Madhya Pradesh',
    'Punjab', 'Haryana', 'Uttar Pradesh',
    'Rajasthan', 'Gujarat', 'Andhra Pradesh',
    'Tamil Nadu', 'All India',
  ];
  final List<String> _categories = [
    'All', 'Grains', 'Vegetables', 'Fruits', 'Cash Crops', 'Other'
  ];

  bool _isLoading = true;
  MandiServiceResult? _result;

  @override
  void initState() {
    super.initState();
    _fetchPrices();
  }

  Future<void> _fetchPrices() async {
    setState(() => _isLoading = true);
    final result = await MandiService.fetchMandiPrices(
      stateFilter: _selectedState == 'All India' ? null : _selectedState,
    );
    if (mounted) {
      setState(() {
        _result = result;
        _isLoading = false;
      });
    }
  }

  List<MandiPrice> get _filteredPrices {
    if (_result == null) return [];
    var list = _result!.prices;

    // Category filter
    if (_selectedCategory != 'All') {
      list = list
          .where((p) => MandiService.categoryFor(p.commodity) == _selectedCategory)
          .toList();
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((p) =>
              p.commodity.toLowerCase().contains(q) ||
              p.market.toLowerCase().contains(q) ||
              p.district.toLowerCase().contains(q))
          .toList();
    }

    return list;
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgriTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AgriTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlobalBhashiniText(
              'Mandi Prices',
              style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: AgriTheme.textDark,
                  fontSize: 18),
            ),
            if (_result != null)
              GlobalBhashiniText(
                _result!.isLive
                    ? '🟠 Live · Agmarknet'
                    : _result!.requiresApiKey
                        ? '🔑 API key required'
                        : '⚫ Cached · ${_formatDate(_result!.fetchedAt)}',
                style: GoogleFonts.inter(
                    fontSize: 10, color: AgriTheme.textMuted),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AgriTheme.primaryGreen),
            onPressed: _fetchPrices,
            tooltip: 'Refresh',
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AgriTheme.primaryGreen))
          : _result!.requiresApiKey
              ? _buildApiKeyPrompt()
              : Column(
                  children: [
                    _buildFilters(),
                    _buildSourceBar(),
                    Expanded(
                      child: _filteredPrices.isEmpty
                          ? _buildEmptyState()
                          : RefreshIndicator(
                              onRefresh: _fetchPrices,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: _filteredPrices.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, i) =>
                                    _buildPriceCard(_filteredPrices[i]),
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }

  // ─── API Key Prompt ──────────────────────────────────────────────────────────

  Widget _buildApiKeyPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AgriTheme.amberLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.vpn_key_rounded,
                  size: 48, color: AgriTheme.accentGold),
            ),
            const SizedBox(height: 24),
            GlobalBhashiniText(
              'Live Mandi Prices',
              style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AgriTheme.textDark),
            ),
            const SizedBox(height: 12),
            GlobalBhashiniText(
              'Register for a free API key at data.gov.in to see live Agmarknet commodity prices from markets across India.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 14, color: AgriTheme.textMuted, height: 1.5),
            ),
            const SizedBox(height: 8),
            GlobalBhashiniText(
              'Once you have a key, add it to MandiService._apiKey in the code.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AgriTheme.textMuted,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  launchUrl(Uri.parse('https://data.gov.in/user/register')),
              icon: const Icon(Icons.open_in_new, size: 16),
              label: GlobalBhashiniText('Register at data.gov.in',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AgriTheme.primaryGreen,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            GlobalBhashiniText(
              'Free · No credit card · Instant access',
              style: GoogleFonts.inter(
                  fontSize: 11, color: Colors.green.shade700),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Filters ────────────────────────────────────────────────────────────────

  Widget _buildFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          // Search
          TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Search commodity, market or district…',
              hintStyle: GoogleFonts.inter(
                  fontSize: 13, color: AgriTheme.textMuted),
              prefixIcon: const Icon(Icons.search,
                  size: 18, color: AgriTheme.textMuted),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AgriTheme.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AgriTheme.primaryGreen),
              ),
              filled: true,
              fillColor: AgriTheme.background,
            ),
          ),
          const SizedBox(height: 10),
          // State + Category dropdowns
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  value: _selectedState,
                  items: _states,
                  onChanged: (v) {
                    setState(() => _selectedState = v!);
                    _fetchPrices();
                  },
                  icon: Icons.location_on_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdown(
                  value: _selectedCategory,
                  items: _categories,
                  onChanged: (v) => setState(() => _selectedCategory = v!),
                  icon: Icons.category_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AgriTheme.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AgriTheme.borderLight),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down,
            size: 18, color: AgriTheme.textMuted),
        style: GoogleFonts.inter(fontSize: 12, color: AgriTheme.textDark),
        items: items
            .map((s) => DropdownMenuItem(
                  value: s,
                  child: Row(
                    children: [
                      Icon(icon, size: 14, color: AgriTheme.primaryGreen),
                      const SizedBox(width: 6),
                      Expanded(
                          child: GlobalBhashiniText(s,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(fontSize: 12))),
                    ],
                  ),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  // ─── Source bar ──────────────────────────────────────────────────────────────

  Widget _buildSourceBar() {
    if (_result == null) return const SizedBox();
    return Container(
      color: _result!.isLive ? Colors.green.shade50 : Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(
            _result!.isLive ? Icons.cloud_done : Icons.cloud_off,
            size: 13,
            color: _result!.isLive ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 6),
          GlobalBhashiniText(
            _result!.isLive
                ? 'Live · ${_result!.source} · ${_filteredPrices.length} records'
                : 'Cached · ${_result!.source} · ${_filteredPrices.length} records',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: _result!.isLive ? Colors.green.shade800 : Colors.grey.shade600,
            ),
          ),
          const Spacer(),
          GlobalBhashiniText(
            _formatDate(_result!.fetchedAt),
            style: GoogleFonts.inter(
                fontSize: 10, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // ─── Price card ───────────────────────────────────────────────────────────────

  Widget _buildPriceCard(MandiPrice price) {
    final observedAt = price.observedAt > 0
        ? DateTime.fromMillisecondsSinceEpoch(price.observedAt)
        : null;
    final category = MandiService.categoryFor(price.commodity);
    final categoryColor = _categoryColor(category);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AgriTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AgriTheme.cardShadow,
        border: Border.all(color: AgriTheme.borderLight, width: 0.8),
      ),
      child: Row(
        children: [
          // ── Category dot ───────────────────────────────────────────────
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: GlobalBhashiniText(
                _categoryEmoji(category),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // ── Name + location ────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalBhashiniText(
                  price.commodity,
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AgriTheme.textDark),
                ),
                if (price.variety.isNotEmpty)
                  GlobalBhashiniText(
                    price.variety,
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AgriTheme.textMuted),
                  ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 10, color: AgriTheme.textMuted),
                    const SizedBox(width: 2),
                    Expanded(
                      child: GlobalBhashiniText(
                        '${price.market}, ${price.district}',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AgriTheme.textMuted),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // ── Freshness badge ──────────────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _result!.isLive
                            ? const Color(0xFFF97316)
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GlobalBhashiniText(
                      observedAt != null
                          ? '${price.source} · ${_formatDate(observedAt)}'
                          : price.source,
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AgriTheme.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ── Modal price ────────────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GlobalBhashiniText(
                MandiService.formatPrice(price.modalPrice),
                style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: AgriTheme.primaryGreen),
              ),
              GlobalBhashiniText(
                price.priceUnit,
                style: GoogleFonts.inter(
                    fontSize: 9, color: AgriTheme.textMuted),
              ),
              if (price.minPrice > 0 && price.maxPrice > 0)
                GlobalBhashiniText(
                  '${MandiService.formatPrice(price.minPrice)}–${MandiService.formatPrice(price.maxPrice)}',
                  style: GoogleFonts.inter(
                      fontSize: 9, color: AgriTheme.textMuted),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          GlobalBhashiniText(
            'No prices found',
            style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AgriTheme.textMuted),
          ),
          const SizedBox(height: 4),
          GlobalBhashiniText(
            'Try a different state or category',
            style: GoogleFonts.inter(fontSize: 13, color: AgriTheme.textMuted),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────────

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Grains':
        return const Color(0xFFF59E0B);
      case 'Vegetables':
        return const Color(0xFF10B981);
      case 'Fruits':
        return const Color(0xFFEC4899);
      case 'Cash Crops':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF64748B);
    }
  }

  String _categoryEmoji(String cat) {
    switch (cat) {
      case 'Grains':
        return '🌾';
      case 'Vegetables':
        return '🥦';
      case 'Fruits':
        return '🍎';
      case 'Cash Crops':
        return '🌿';
      default:
        return '📦';
    }
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
