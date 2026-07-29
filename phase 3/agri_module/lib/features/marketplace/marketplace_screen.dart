import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/agri_theme.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _selectedTab = 'All';
  int _cartCount = 2;

  final List<String> _tabs = ['All', 'Seeds & Grains', 'Fertilizers', 'Farm Tools', 'Organic'];

  final List<Map<String, dynamic>> _products = [
    {
      'title': 'Hybrid Yellow Maize Seeds (5 kg)',
      'brand': 'Syngenta Seeds',
      'price': '₹850',
      'oldPrice': '₹1,050',
      'discount': '19% OFF',
      'rating': '4.8',
      'reviews': '142',
      'category': 'Seeds & Grains',
      'icon': Icons.grass,
      'color': Color(0xFFFEF3C7),
      'iconColor': Color(0xFFD97706)
    },
    {
      'title': 'Organic Neem Cake Fertilizer (10 kg)',
      'brand': 'IFFCO Kisan',
      'price': '₹450',
      'oldPrice': '₹550',
      'discount': '18% OFF',
      'rating': '4.9',
      'reviews': '310',
      'category': 'Organic',
      'icon': Icons.compost,
      'color': Color(0xFFE8F5EE),
      'iconColor': Color(0xFF1E6B3B)
    },
    {
      'title': 'Battery Operated Knapsack Sprayer (16L)',
      'brand': 'KisanKraft Modern Tools',
      'price': '₹2,400',
      'oldPrice': '₹3,200',
      'discount': '25% OFF',
      'rating': '4.7',
      'reviews': '89',
      'category': 'Farm Tools',
      'icon': Icons.water_drop,
      'color': Color(0xFFE0F2FE),
      'iconColor': Color(0xFF0284C7)
    },
    {
      'title': 'Bio-Potash Liquid Nutrient (1 L)',
      'brand': 'Coromandel International',
      'price': '₹320',
      'oldPrice': '₹400',
      'discount': '20% OFF',
      'rating': '4.6',
      'reviews': '64',
      'category': 'Fertilizers',
      'icon': Icons.science,
      'color': Color(0xFFF3E8FF),
      'iconColor': Color(0xFF9333EA)
    },
    {
      'title': 'Heavy Duty Hand Weeder Tool',
      'brand': 'Falcon Garden Tools',
      'price': '₹280',
      'oldPrice': '₹350',
      'discount': '20% OFF',
      'rating': '4.5',
      'reviews': '215',
      'category': 'Farm Tools',
      'icon': Icons.home_repair_service,
      'color': Color(0xFFFFEDD5),
      'iconColor': Color(0xFFEA580C)
    },
    {
      'title': 'Certified Basmati Rice Seeds (10 kg)',
      'brand': 'Pusa Agri Seeds',
      'price': '₹1,250',
      'oldPrice': '₹1,500',
      'discount': '16% OFF',
      'rating': '4.9',
      'reviews': '520',
      'category': 'Seeds & Grains',
      'icon': Icons.rice_bowl,
      'color': Color(0xFFFEF3C7),
      'iconColor': Color(0xFFD97706)
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _products.where((p) => _selectedTab == 'All' || p['category'] == _selectedTab).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Kisan Agri Marketplace'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: AgriTheme.textDark),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Your Cart has $_cartCount items. Proceeding to checkout...')),
                  );
                },
              ),
              if (_cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AgriTheme.accentGold, shape: BoxShape.circle),
                    child: Text(
                      '$_cartCount',
                      style: GoogleFonts.outfit(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Category tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _tabs.map((tab) {
                  final isSel = _selectedTab == tab;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        tab,
                        style: GoogleFonts.outfit(
                          color: isSel ? Colors.white : AgriTheme.textDark,
                          fontWeight: isSel ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      selected: isSel,
                      selectedColor: AgriTheme.primaryGreen,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      onSelected: (_) => setState(() => _selectedTab = tab),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Product Grid
          Expanded(
            child: GridView.builder(
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
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AgriTheme.cardShadow,
                    border: Border.all(color: AgriTheme.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Icon Box
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: p['color'] as Color,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(p['icon'] as IconData, size: 54, color: p['iconColor'] as Color),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AgriTheme.priceDown,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    p['discount'],
                                    style: GoogleFonts.outfit(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Details
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p['brand'],
                              style: GoogleFonts.outfit(fontSize: 11, color: AgriTheme.textMuted, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              p['title'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: AgriTheme.textDark, height: 1.2),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.star, color: AgriTheme.accentGold, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  p['rating'],
                                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 12, color: AgriTheme.textDark),
                                ),
                                Text(
                                  ' (${p['reviews']})',
                                  style: GoogleFonts.outfit(fontSize: 11, color: AgriTheme.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p['price'],
                                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: AgriTheme.primaryGreen),
                                    ),
                                    Text(
                                      p['oldPrice'],
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        color: AgriTheme.textMuted,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() => _cartCount++);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Added "${p['title']}" to Cart!')),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AgriTheme.primaryGreen,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                                  ),
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
          ),
        ],
      ),
    );
  }
}
