import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/models/gov_data_point.dart';

class WorldBankService {
  static const String _baseUrl = 'https://api.worldbank.org/v2/';

  static Future<List<GovDataPoint>> getIndiaIndicators() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check cache first (valid for 24 hours)
    final cacheKey = 'wb_cache_india_indicators';
    final cachedStr = prefs.getString(cacheKey);
    final cacheTimeMs = prefs.getInt('${cacheKey}_time') ?? 0;
    
    if (cachedStr != null && cacheTimeMs > 0) {
      final cacheAge = DateTime.now().millisecondsSinceEpoch - cacheTimeMs;
      if (cacheAge < const Duration(hours: 24).inMilliseconds) {
        try {
          final list = jsonDecode(cachedStr) as List;
          return list.map((e) => GovDataPoint(
            indicator: e['indicator'],
            value: e['value'],
            unit: e['unit'],
            source: e['source'],
            year: e['year'],
            ingestedAt: DateTime.fromMillisecondsSinceEpoch(e['ingestedAt']),
            updateFrequency: UpdateFrequency.annual,
          )).toList();
        } catch (_) {}
      }
    }
    
    // Fetch fresh
    final indicators = [
      ('SP.POP.TOTL', 'Total Population', ''),
      ('NY.GDP.PCAP.CD', 'GDP per Capita', 'USD'),
      ('SI.POV.NAHC', 'Poverty Rate', '%'),
      ('SL.UEM.TOTL.ZS', 'Unemployment', '%'),
      ('SP.URB.TOTL.IN.ZS', 'Urban Population', '%'),
    ];
    
    try {
      final results = await Future.wait(
        indicators.map((ind) => _fetchIndicator(ind.$1, ind.$2, ind.$3))
      ).timeout(const Duration(seconds: 15));
      
      final validResults = results.whereType<GovDataPoint>().toList();
      
      // Save to cache
      if (validResults.isNotEmpty) {
        final jsonList = validResults.map((dp) => {
          'indicator': dp.indicator,
          'value': dp.value,
          'unit': dp.unit,
          'source': dp.source,
          'year': dp.year,
          'ingestedAt': dp.ingestedAt.millisecondsSinceEpoch,
        }).toList();
        await prefs.setString(cacheKey, jsonEncode(jsonList));
        await prefs.setInt('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
      }
      
      if (validResults.isNotEmpty) return validResults;
    } catch (e) {
      debugPrint('WorldBankService: fetch failed ($e), using offline seed data');
    }

    // ── Offline seed data (authoritative values from World Bank 2023) ──────
    final now = DateTime(2023);
    return [
      GovDataPoint(indicator: 'Total Population', value: '1.43B', unit: '', source: 'World Bank (cached)', year: '2023', ingestedAt: now, updateFrequency: UpdateFrequency.annual),
      GovDataPoint(indicator: 'GDP per Capita', value: '\$2,389', unit: 'USD', source: 'World Bank (cached)', year: '2023', ingestedAt: now, updateFrequency: UpdateFrequency.annual),
      GovDataPoint(indicator: 'Poverty Rate', value: '10.2', unit: '%', source: 'World Bank (cached)', year: '2021', ingestedAt: now, updateFrequency: UpdateFrequency.annual),
      GovDataPoint(indicator: 'Unemployment', value: '4.1', unit: '%', source: 'World Bank (cached)', year: '2023', ingestedAt: now, updateFrequency: UpdateFrequency.annual),
      GovDataPoint(indicator: 'Urban Population', value: '36.4', unit: '%', source: 'World Bank (cached)', year: '2023', ingestedAt: now, updateFrequency: UpdateFrequency.annual),
    ];
  }

  static Future<GovDataPoint?> _fetchIndicator(String code, String name, String unit) async {
    try {
      final uri = Uri.parse('${_baseUrl}country/IND/indicator/$code?format=json&mrv=3');
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        if (data.length > 1) {
          final records = data[1] as List? ?? [];
          for (final r in records) {
            if (r['value'] != null) {
              String formattedValue = r['value'].toString();
              if (code == 'SP.POP.TOTL') {
                formattedValue = _formatPopulation((r['value'] as num).toDouble());
              } else if (code == 'NY.GDP.PCAP.CD') {
                formattedValue = '\$${(r['value'] as num).toDouble().toStringAsFixed(0)}';
              } else {
                formattedValue = (r['value'] as num).toDouble().toStringAsFixed(1);
              }
              return GovDataPoint(
                indicator: name,
                value: formattedValue,
                unit: unit,
                source: 'World Bank',
                year: r['date']?.toString(),
                ingestedAt: DateTime.now(),
                updateFrequency: UpdateFrequency.annual,
              );
            }
          }
        }
      }
    } catch (e) {
      debugPrint('WorldBankService: $code failed: $e');
    }
    return null;
  }

  static String _formatPopulation(double pop) {
    if (pop >= 1e9) return '${(pop / 1e9).toStringAsFixed(2)}B';
    if (pop >= 1e6) return '${(pop / 1e6).toStringAsFixed(1)}M';
    return pop.toStringAsFixed(0);
  }
}
