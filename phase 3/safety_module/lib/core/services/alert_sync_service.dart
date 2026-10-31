import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../db/safety_database.dart';
import 'dart:math' as math;

class AlertSyncService {
  static const String _usgsUrl = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson';
  static const String _ndmaCapUrl = 'https://sachet.ndma.gov.in/cap_public_website/cap/all/CAP.xml';

  static Future<void> sync({double userLat = 0, double userLon = 0}) async {
    debugPrint('AlertSyncService: starting background sync');
    await Future.wait([
      _syncUsgsEarthquakes(userLat, userLon),
      _syncNdmaSachet(),
      _syncOpenMeteoAq(userLat, userLon),
    ], eagerError: false);
    debugPrint('AlertSyncService: sync complete');
  }

  static Future<List<Broadcast>> getAlerts() async {
    final db = SafetyDatabase();
    final since = DateTime.now().subtract(const Duration(hours: 72));
    final alerts = await db.getAlertsSince(since);
    await db.close();
    return alerts;
  }

  static Future<DateTime?> getLastSyncTime() async {
    final db = SafetyDatabase();
    final time = await db.getLastSyncTime();
    await db.close();
    return time;
  }

  static Future<void> _syncUsgsEarthquakes(double userLat, double userLon) async {
    try {
      final response = await http.get(Uri.parse(_usgsUrl)).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) return;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final features = (data['features'] as List? ?? []);
      final db = SafetyDatabase();
      int inserted = 0;
      for (final feature in features) {
        final props = feature['properties'] as Map<String, dynamic>? ?? {};
        final geom = feature['geometry'] as Map<String, dynamic>? ?? {};
        final coords = (geom['coordinates'] as List?) ?? [];
        final double mag = (props['mag'] as num? ?? 0).toDouble();
        final String place = props['place']?.toString() ?? 'Unknown location';
        final int timeMs = (props['time'] as num? ?? 0).toInt();
        final double eqLon = coords.isNotEmpty ? (coords[0] as num).toDouble() : 0.0;
        final double eqLat = coords.length > 1 ? (coords[1] as num).toDouble() : 0.0;

        final lat = (userLat == 0 && userLon == 0) ? 20.5937 : userLat;
        final lon = (userLat == 0 && userLon == 0) ? 78.9629 : userLon;
        if (_haversineKm(lat, lon, eqLat, eqLon) > 5000) continue;

        final severity = mag >= 6.0 ? 'CRITICAL' : mag >= 4.5 ? 'WARNING' : 'ADVISORY';
        await db.insertBroadcast(BroadcastsCompanion(
          title: drift.Value('Earthquake M'),
          message: drift.Value('A magnitude  earthquake occurred near .'),
          severity: drift.Value(severity),
          timestamp: drift.Value(DateTime.fromMillisecondsSinceEpoch(timeMs)),
          source: const drift.Value('USGS'),
          sourceUrl: const drift.Value('https://earthquake.usgs.gov/'),
          observedAt: drift.Value(timeMs),
          latitude: drift.Value(eqLat),
          longitude: drift.Value(eqLon),
        ));
        inserted++;
      }
      await db.close();
    } catch (e) {}
  }

  static Future<void> _syncNdmaSachet() async {
    try {
      final response = await http.get(Uri.parse(_ndmaCapUrl)).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) return;
      final document = XmlDocument.parse(response.body);
      final alerts = document.findAllElements('alert');
      final db = SafetyDatabase();
      for (final alertEl in alerts) {
        final info = alertEl.findElements('info').firstOrNull;
        if (info == null) continue;
        final headline = _xmlText(info, 'headline') ?? 'NDMA Alert';
        final description = _xmlText(info, 'description') ?? 'No details available.';
        final severity = _capSeverityToLocal(_xmlText(info, 'severity'));
        final areaDesc = _xmlText(info.findElements('area').firstOrNull, 'areaDesc') ?? 'India';
        await db.insertBroadcast(BroadcastsCompanion(
          title: drift.Value(headline),
          message: drift.Value('\\n\nAffected area: \. Source: NDMA SACHET.'),
          severity: drift.Value(severity),
          timestamp: drift.Value(DateTime.now()),
          source: const drift.Value('NDMA SACHET'),
          observedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
        ));
      }
      await db.close();
    } catch (e) {}
  }

  static Future<void> _syncOpenMeteoAq(double userLat, double userLon) async {
    if (userLat == 0 && userLon == 0) {
      userLat = 28.6139; userLon = 77.2090; // Default Delhi
    }
    try {
      final locUri = Uri.parse('https://air-quality-api.open-meteo.com/v1/air-quality?latitude=\&longitude=\&current=pm2_5');
      final locResp = await http.get(locUri).timeout(const Duration(seconds: 10));
      if (locResp.statusCode != 200) return;
      final data = jsonDecode(locResp.body) as Map<String, dynamic>;
      final pm25 = (data['current']?['pm2_5'] as num?)?.toDouble() ?? 0.0;
      if (pm25 > 60) {
        final severity = pm25 > 150 ? 'CRITICAL' : 'WARNING';
        final db = SafetyDatabase();
        await db.insertBroadcast(BroadcastsCompanion(
          title: drift.Value('Poor Air Quality (PM2.5: \)'),
          message: drift.Value('Air quality is poor in your area. Sensitive groups should reduce outdoor exercise.'),
          severity: drift.Value(severity),
          timestamp: drift.Value(DateTime.now()),
          source: const drift.Value('Open-Meteo'),
          observedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
        ));
        await db.close();
      }
    } catch (e) {}
  }

  static double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = (lat2 - lat1) * math.pi / 180.0;
    final dLon = (lon2 - lon1) * math.pi / 180.0;
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) + math.cos(lat1 * math.pi / 180.0) * math.cos(lat2 * math.pi / 180.0) * math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }

  static String? _xmlText(XmlElement? element, String tag) {
    if (element == null) return null;
    final child = element.findElements(tag).firstOrNull;
    return child?.innerText.trim();
  }

  static String _capSeverityToLocal(String? capSeverity) {
    switch (capSeverity?.toUpperCase()) {
      case 'EXTREME': case 'SEVERE': return 'CRITICAL';
      case 'MODERATE': return 'WARNING';
      default: return 'ADVISORY';
    }
  }
}
