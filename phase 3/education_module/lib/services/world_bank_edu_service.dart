import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/models/edu_data_point.dart';

class WorldBankEduService {
  static const String _baseUrl = 'https://api.worldbank.org/v2/';

  static Future<List<EduDataPoint>> getIndiaIndicators() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check cache first (valid for 24 hours)
    final cacheKey = 'wb_cache_edu_indicators';
    final cachedStr = prefs.getString(cacheKey);
    final cacheTimeMs = prefs.getInt('${cacheKey}_time') ?? 0;
    
    if (cachedStr != null && cacheTimeMs > 0) {
      final cacheAge = DateTime.now().millisecondsSinceEpoch - cacheTimeMs;
      if (cacheAge < const Duration(hours: 24).inMilliseconds) {
        try {
          final list = jsonDecode(cachedStr) as List;
          return list.map((e) => EduDataPoint(
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
      ('SE.PRM.ENRR', 'Primary Enrollment', '%'),
      ('SE.SEC.ENRR', 'Secondary Enrollment', '%'),
      ('SE.ADT.LITR.ZS', 'Adult Literacy Rate', '%'),
      ('SE.TER.ENRR', 'Tertiary Enrollment', '%'),
    ];
    
    final results = await Future.wait(
      indicators.map((ind) => _fetchIndicator(ind.$1, ind.$2, ind.$3))
    );
    
    final validResults = results.whereType<EduDataPoint>().toList();
    
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
    
    return validResults;
  }

  static Future<EduDataPoint?> _fetchIndicator(String code, String name, String unit) async {
    try {
      final uri = Uri.parse('${_baseUrl}country/IND/indicator/$code?format=json&mrv=5'); // Fetch up to 5 most recent years to ensure we get a non-null value
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        if (data.length > 1) {
          final records = data[1] as List? ?? [];
          for (final r in records) {
            if (r['value'] != null) {
              final val = (r['value'] as num).toDouble();
              // Clamp percentages that exceed 100% due to statistical anomalies (e.g., gross enrollment)
              final finalVal = (unit == '%' && val > 100) ? 100.0 : val;
              return EduDataPoint(
                indicator: name,
                value: finalVal.toStringAsFixed(1),
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
      debugPrint('WorldBankEduService: $code failed: $e');
    }
    return null;
  }
}
