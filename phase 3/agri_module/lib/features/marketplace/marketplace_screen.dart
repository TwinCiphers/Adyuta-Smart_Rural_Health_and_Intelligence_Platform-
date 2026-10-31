import 'package:bhashini_core/bhashini_core.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/agri_theme.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _selectedTab = 'All';
  int _cartCount = 0;
  List<dynamic> _products = [];
  bool _isLoading = true;

  final List<String> _tabs = ['All', 'Seeds & Grains', 'Fertilizers', 'Farm Tools', 'Organic'];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final res = await http.get(Uri.parse('http://127.0.0.1:3000/api/agri/marketplace/products')).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _products = jsonDecode(res.body)['products'];
          _isLoading = false;
        });
        return;
      }
    } catch (_) {
      // Proceed to offline fallback
    }
    
    // ── Offline seed data ──────
    if (!mounted) return;
    setState(() {
      _products = [
        {'id': '1', 'category': 'Seeds & Grains', 'brand': 'Kisan Seeds', 'title': 'High Yield Wheat Seeds (Sharbati)', 'price': 850, 'oldPrice': 1000, 'imageIcon': 'grass'},
        {'id': '2', 'category': 'Fertilizers', 'brand': 'AgriGold', 'title': 'Organic NPK Compost - 50kg', 'price': 1200, 'oldPrice': 1500, 'imageIcon': 'compost'},
        {'id': '3', 'category': 'Farm Tools', 'brand': 'FarmEquip', 'title': 'Heavy Duty Sickle & Spade Set', 'price': 450, 'oldPrice': null, 'imageIcon': 'home_repair_service'},
        {'id': '4', 'category': 'Seeds & Grains', 'brand': 'GreenAgri', 'title': 'Basmati Rice Paddy Seeds', 'price': 1400, 'oldPrice': 1600, 'imageIcon': 'rice_bowl'},
        {'id': '5', 'category': 'Organic', 'brand': 'BioGrow', 'title': 'Neem Extract Bio-Pesticide (1L)', 'price': 350, 'oldPrice': 450, 'imageIcon': 'science'},
        {'id': '6', 'category': 'Farm Tools', 'brand': 'AgroTech', 'title': 'Drip Irrigation Starter Kit', 'price': 2500, 'oldPrice': 3000, 'imageIcon': 'water_drop'},
      ];
      _isLoading = false;
    });
  }

  void _addToCart(String productId) {
    setState(() => _cartCount++);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: GlobalBhashiniText('Added to Cart!')));
  }

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'grass': return Icons.grass;
      case 'compost': return Icons.compost;
      case 'water_drop': return Icons.water_drop;
      case 'science': return Icons.science;
      case 'home_repair_service': return Icons.home_repair_service;
      case 'rice_bowl': return Icons.rice_bowl;
      default: return Icons.shopping_bag;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedTab == 'All' ? _products : _products.where((p) => p['category'] == _selectedTab).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GlobalBhashiniText('Farmer Marketplace', style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: AgriTheme.textDark)),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: AgriTheme.textDark),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GlobalBhashiniText('Cart Screen Opening... ($_cartCount items)')));
                },
              ),
              if (_cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: GlobalBhashiniText('$_cartCount', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                )
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: _tabs.map((tab) {
                final isSelected = _selectedTab == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: GlobalBhashiniText(tab, style: GoogleFonts.outfit(color: isSelected ? Colors.white : AgriTheme.textDark)),
                    selected: isSelected,
                    selectedColor: AgriTheme.primaryGreen,
                    backgroundColor: Colors.grey.shade100,
                    onSelected: (v) => setState(() => _selectedTab = tab),
                  ),
                );
              }).toList(),
            ),
          ),

          // Products Grid
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : filtered.isEmpty 
                ? const Center(child: GlobalBhashiniText('No products found'))
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.58,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final p = filtered[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5EE),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Icon(_getIconData(p['imageIcon']), size: 50, color: const Color(0xFF1E6B3B)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GlobalBhashiniText(p['brand'] ?? '', style: GoogleFonts.outfit(fontSize: 10, color: AgriTheme.textMuted)),
                            const SizedBox(height: 4),
                            GlobalBhashiniText(p['title'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 13, color: AgriTheme.textDark)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                GlobalBhashiniText('₹${p['price']}', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: AgriTheme.primaryGreen)),
                                const SizedBox(width: 6),
                                if (p['oldPrice'] != null)
                                  GlobalBhashiniText('₹${p['oldPrice']}', style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _addToCart(p['id']),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AgriTheme.primaryGreen,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: GlobalBhashiniText('Add to Cart', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

