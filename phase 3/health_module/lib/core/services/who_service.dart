import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import '../models/health_data_point.dart';
import '../db/who_indicators_db.dart';

/// Fetches real health indicators from WHO Global Health Observatory OData API.
/// Free, no auth required.
class WhoService {
  static const String _baseUrl = 'https://ghoapi.azureedge.net/api/';

  /// Get the key indicators for India, returning cached versions if offline or
  /// if the data was fetched recently (WHO reference data only updates yearly).
  static Future<List<HealthDataPoint>> getIndiaIndicators() async {
    final db = WhoIndicatorsDatabase();
    
    try {
      // 1. Check local DB first
      final cached = await db.getAllIndicators();
      
      // If we have cached data and it's less than 7 days old, use it.
      // WHO data updates very infrequently, so a 7-day cache is perfectly safe.
      if (cached.isNotEmpty) {
        final oldestIngest = cached
            .map((c) => c.ingestedAt)
            .reduce((a, b) => a < b ? a : b);
            
        final age = DateTime.now().millisecondsSinceEpoch - oldestIngest;
        if (age < const Duration(days: 7).inMilliseconds) {
          final results = cached.map(_companionToDisplay).toList();
          await db.close();
          return results;
        }
      }

      // 2. Data is missing or stale, fetch from WHO
      final indicators = [
        ('WHOSIS_000001', 'Life Expectancy at Birth', 'years'),
        ('NUTRITION_ANAEMIA_CHILDREN_PREV', 'Child Anaemia Prevalence', '%'),
        ('WHS4_100', 'Skilled Birth Attendance', '%'),
      ];
      
      final results = await Future.wait(
        indicators.map((ind) => _fetchIndicator(ind.$1, ind.$2, ind.$3))
      );
      
      final validResults = results.whereType<HealthDataPoint>().toList();
      
      // Save to DB if we got real results
      if (validResults.isNotEmpty) {
        final companions = validResults.map((dp) => WhoIndicatorCompanion(
          indicatorCode: drift.Value('TODO_MAP_CODE'), // Simplification for demo
          indicatorName: drift.Value(dp.indicator),
          value: drift.Value(double.tryParse(dp.value) ?? 0.0),
          unit: drift.Value(dp.unit),
          year: drift.Value(int.tryParse(dp.year ?? '') ?? 0),
          ingestedAt: drift.Value(dp.ingestedAt.millisecondsSinceEpoch),
        )).toList();
        
        await db.upsertIndicators(companions);
      }
      
      await db.close();
      
      // Even if API fails partially, return what we got.
      // If nothing came back, serve the hardcoded offline seed data.
      if (validResults.isNotEmpty) {
        return validResults;
      }
      final stale = cached.map(_companionToDisplay).toList();
      return stale.isNotEmpty ? stale : _offlineSeed();
          
    } catch (e) {
      debugPrint('WhoService error: $e');
      // Fallback to cache on error
      final cached = await db.getAllIndicators();
      await db.close();
      final stale = cached.map(_companionToDisplay).toList();
      return stale.isNotEmpty ? stale : _offlineSeed();
    }
  }

  /// Hardcoded India health indicators from WHO 2022 data.
  /// Used when network is unavailable and no DB cache exists.
  static List<HealthDataPoint> _offlineSeed() => [
    HealthDataPoint(
      indicator: 'Life Expectancy at Birth',
      value: '67.2',
      unit: 'years',
      source: 'WHO GHO (offline seed)',
      year: '2022',
      ingestedAt: DateTime(2022),
      updateFrequency: UpdateFrequency.historical,
    ),
    HealthDataPoint(
      indicator: 'Child Anaemia Prevalence',
      value: '52.9',
      unit: '%',
      source: 'WHO GHO (offline seed)',
      year: '2022',
      ingestedAt: DateTime(2022),
      updateFrequency: UpdateFrequency.historical,
    ),
    HealthDataPoint(
      indicator: 'Skilled Birth Attendance',
      value: '88.6',
      unit: '%',
      source: 'WHO GHO (offline seed)',
      year: '2022',
      ingestedAt: DateTime(2022),
      updateFrequency: UpdateFrequency.historical,
    ),
  ];

  static Future<HealthDataPoint?> _fetchIndicator(String code, String name, String unit) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl$code?\$filter=SpatialDim eq \'IND\'&\$top=5&\$orderby=TimeDim desc'
      );
      
      final response = await http.get(uri, headers: {
        'Accept': 'application/json'
      }).timeout(const Duration(seconds: 25));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final values = (data['value'] as List? ?? []);
        
        // Get the most recent non-null numeric value
        for (final v in values) {
          final numVal = v['NumericValue'];
          if (numVal != null) {
            final year = v['TimeDim']?.toString() ?? '';
            return HealthDataPoint(
              indicator: name,
              value: numVal is double ? numVal.toStringAsFixed(1) : numVal.toString(),
              unit: unit,
              source: 'WHO GHO',
              year: year,
              ingestedAt: DateTime.now(),
              updateFrequency: UpdateFrequency.historical,
            );
          }
        }
      }
    } catch (e) {
      debugPrint('WhoService: $code failed: $e');
    }
    return null;
  }
  
  static HealthDataPoint _companionToDisplay(WhoIndicatorData c) {
    return HealthDataPoint(
      indicator: c.indicatorName,
      value: c.value.toStringAsFixed(1),
      unit: c.unit,
      source: 'WHO GHO (cached)',
      year: c.year > 0 ? c.year.toString() : null,
      ingestedAt: DateTime.fromMillisecondsSinceEpoch(c.ingestedAt),
      updateFrequency: UpdateFrequency.historical,
    );
  }
}
