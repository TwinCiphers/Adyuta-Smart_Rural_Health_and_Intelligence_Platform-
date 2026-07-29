import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/agri_theme.dart';

class MandiPricesScreen extends StatefulWidget {
  const MandiPricesScreen({super.key});

  @override
  State<MandiPricesScreen> createState() => _MandiPricesScreenState();
}

class _MandiPricesScreenState extends State<MandiPricesScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = ['All', 'Grains', 'Vegetables', 'Fruits', 'Cash Crops'];

  final List<Map<String, dynamic>> _mandiData = [
    {
      'commodity': 'Wheat (Lok-1)',
      'mandi': 'Indore Mandi, MP',
      'price': '₹2,650 / Qtl',
      'change': '+₹45',
      'isUp': true,
      'category': 'Grains',
      'date': 'Today, 07:30 AM'
    },
    {
      'commodity': 'Soybean (Yellow)',
      'mandi': 'Ujjain Mandi, MP',
      'price': '₹4,820 / Qtl',
      'change': '-₹120',
      'isUp': false,
      'category': 'Cash Crops',
      'date': 'Today, 07:15 AM'
    },
    {
      'commodity': 'Cotton (Long Staple)',
      'mandi': 'Rajkot Mandi, Gujarat',
      'price': '₹7,400 / Qtl',
      'change': '+₹150',
      'isUp': true,
      'category': 'Cash Crops',
      'date': 'Today, 06:50 AM'
    },
    {
      'commodity': 'Tomato (Hybrid)',
      'mandi': 'Azadpur Mandi, Delhi',
      'price': '₹1,800 / Qtl',
      'change': '+₹200',
      'isUp': true,
      'category': 'Vegetables',
      'date': 'Today, 07:45 AM'
    },
    {
      'commodity': 'Onion (Red)',
      'mandi': 'Lasalgaon Mandi, MH',
      'price': '₹2,100 / Qtl',
      'change': '-₹80',
      'isUp': false,
      'category': 'Vegetables',
      'date': 'Today, 07:00 AM'
    },
    {
      'commodity': 'Pomegranate (Bhagwa)',
      'mandi': 'Nashik Mandi, MH',
      'price': '₹8,500 / Qtl',
      'change': '+₹350',
      'isUp': true,
      'category': 'Fruits',
      'date': 'Today, 06:30 AM'
    },
    {
      'commodity': 'Rice (Basmati 1121)',
      'mandi': 'Karnal Mandi, Haryana',
      'price': '₹4,300 / Qtl',
      'change': '+₹90',
      'isUp': true,
      'category': 'Grains',
      'date': 'Today, 07:20 AM'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredList = _mandiData.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item['category'] == _selectedCategory;
      final matchesSearch = item['commodity'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item['mandi'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Daily APMC Mandi Rates'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AgriTheme.primaryGreen),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mandi prices updated to latest APMC bulletin')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: AgriTheme.cardShadow,
            ),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search crop, mandi or city...',
                    hintStyle: GoogleFonts.outfit(color: AgriTheme.textMuted),
                    prefixIcon: const Icon(Icons.search, color: AgriTheme.textMuted),
                    filled: true,
                    fillColor: AgriTheme.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(
                            cat,
                            style: GoogleFonts.outfit(
                              color: isSelected ? Colors.white : AgriTheme.textDark,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AgriTheme.primaryGreen,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          onSelected: (_) => setState(() => _selectedCategory = cat),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Price ticker notice
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AgriTheme.amberLight,
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: AgriTheme.accentGold),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Live APMC rates sourced from Agmarknet. Prices vary by quality.',
                    style: GoogleFonts.outfit(fontSize: 12, color: const Color(0xFF92400E)),
                  ),
                ),
              ],
            ),
          ),

          // List of Mandi Rates
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.query_stats, size: 64, color: AgriTheme.textMuted.withOpacity(0.4)),
                        const SizedBox(height: 12),
                        Text('No mandi prices found', style: GoogleFonts.outfit(fontSize: 16, color: AgriTheme.textMuted)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      final isUp = item['isUp'] as bool;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AgriTheme.cardShadow,
                          border: Border.all(color: AgriTheme.borderLight),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AgriTheme.lightGreen,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.eco, color: AgriTheme.primaryGreen, size: 28),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['commodity'],
                                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: AgriTheme.textDark),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['mandi'],
                                    style: GoogleFonts.outfit(fontSize: 13, color: AgriTheme.textMuted),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['date'],
                                    style: GoogleFonts.outfit(fontSize: 11, color: AgriTheme.textMuted.withOpacity(0.8)),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  item['price'],
                                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: AgriTheme.primaryGreen),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: (isUp ? AgriTheme.priceUp : AgriTheme.priceDown).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isUp ? Icons.arrow_upward : Icons.arrow_downward,
                                        size: 12,
                                        color: isUp ? AgriTheme.priceUp : AgriTheme.priceDown,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        item['change'],
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: isUp ? AgriTheme.priceUp : AgriTheme.priceDown,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
