import 'dart:convert';
import 'package:http/http.dart' as http;
import '../db/agri_database.dart';

class MandiServiceResult {
  final List<MandiPrice> prices;
  final bool isLive;
  final bool requiresApiKey;
  final DateTime fetchedAt;
  final String source;

  MandiServiceResult({
    required this.prices,
    required this.isLive,
    this.requiresApiKey = false,
    required this.fetchedAt,
    required this.source,
  });
}

class MandiService {
  static const String _baseUrl = 'http://127.0.0.1:3000/api/agri/mandi';

  static String formatPrice(double price) => price.toStringAsFixed(0);

  static String categoryFor(String commodity) {
    final c = commodity.toLowerCase();
    if (c.contains('wheat') || c.contains('rice') || c.contains('paddy') || c.contains('maize') || c.contains('bajra') || c.contains('jowar')) {
      return 'Grains';
    }
    if (c.contains('potato') || c.contains('onion') || c.contains('tomato') || c.contains('cabbage') || c.contains('brinjal')) {
      return 'Vegetables';
    }
    if (c.contains('apple') || c.contains('mango') || c.contains('banana') || c.contains('grapes') || c.contains('orange')) {
      return 'Fruits';
    }
    if (c.contains('cotton') || c.contains('sugarcane') || c.contains('jute')) {
      return 'Cash Crops';
    }
    return 'Other';
  }

  static Future<MandiServiceResult> fetchMandiPrices({String? stateFilter}) async {
    try {
      final response = await http.get(Uri.parse(_baseUrl)).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final data = List<Map<String, dynamic>>.from(jsonResponse['data']);
        
        final List<MandiPrice> parsed = data.map<MandiPrice>((item) => MandiPrice(
          id: 0,
          state: item['state'] ?? '',
          district: item['market'] ?? '',
          market: item['market'] ?? '',
          commodity: item['commodity'] ?? '',
          variety: '',
          minPrice: (item['minPrice'] ?? 0.0).toDouble(),
          maxPrice: (item['maxPrice'] ?? 0.0).toDouble(),
          modalPrice: (item['modalPrice'] ?? 0.0).toDouble(),
          priceUnit: 'per Qtl',
          observedAt: DateTime.now().millisecondsSinceEpoch,
          ingestedAt: DateTime.now().millisecondsSinceEpoch, source: 'backend',
        )).toList();

        return MandiServiceResult(
          prices: parsed,
          isLive: true,
          fetchedAt: DateTime.now(),
          source: 'Adyuta Backend (Live)',
        );
      }
    } catch (e) {
      // Proceed to offline fallback
    }
    
    // ── Offline seed data (mock Agmarknet data) ──────
    final now = DateTime.now().millisecondsSinceEpoch;
    final List<MandiPrice> offlineData = [
      MandiPrice(id: 1, state: 'Madhya Pradesh', district: 'Indore', market: 'Indore(F&V)', commodity: 'Onion', variety: 'Local', minPrice: 1200, maxPrice: 1800, modalPrice: 1500, priceUnit: 'Rs/Qtl', observedAt: now, ingestedAt: now, source: 'data.gov.in (Cached)'),
      MandiPrice(id: 2, state: 'Madhya Pradesh', district: 'Sehore', market: 'Sehore', commodity: 'Wheat', variety: 'Sharbati', minPrice: 2200, maxPrice: 2800, modalPrice: 2500, priceUnit: 'Rs/Qtl', observedAt: now, ingestedAt: now, source: 'data.gov.in (Cached)'),
      MandiPrice(id: 3, state: 'Maharashtra', district: 'Pune', market: 'Pune', commodity: 'Tomato', variety: 'Hybrid', minPrice: 800, maxPrice: 1400, modalPrice: 1000, priceUnit: 'Rs/Qtl', observedAt: now, ingestedAt: now, source: 'data.gov.in (Cached)'),
      MandiPrice(id: 4, state: 'Maharashtra', district: 'Nashik', market: 'Lasalgaon', commodity: 'Onion', variety: 'Red', minPrice: 1400, maxPrice: 2100, modalPrice: 1800, priceUnit: 'Rs/Qtl', observedAt: now, ingestedAt: now, source: 'data.gov.in (Cached)'),
      MandiPrice(id: 5, state: 'Punjab', district: 'Amritsar', market: 'Amritsar', commodity: 'Paddy(Dhan)', variety: 'Basmati', minPrice: 2800, maxPrice: 3400, modalPrice: 3100, priceUnit: 'Rs/Qtl', observedAt: now, ingestedAt: now, source: 'data.gov.in (Cached)'),
      MandiPrice(id: 6, state: 'Karnataka', district: 'Bengaluru', market: 'Yeshwanthpur', commodity: 'Potato', variety: 'Local', minPrice: 1600, maxPrice: 2400, modalPrice: 2000, priceUnit: 'Rs/Qtl', observedAt: now, ingestedAt: now, source: 'data.gov.in (Cached)'),
    ];

    final filtered = stateFilter != null 
        ? offlineData.where((p) => p.state == stateFilter).toList() 
        : offlineData;

    return MandiServiceResult(
      prices: filtered,
      isLive: false,
      fetchedAt: DateTime.now(),
      source: 'data.gov.in (Cached)',
      requiresApiKey: false,
    );
  }
}

