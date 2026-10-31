import 'package:drift/drift.dart';

enum UpdateFrequency {
  realTime,
  hourly,
  daily,
  weekly,
  historical,
  forecast,
  unknown
}

class HealthDataPoint {
  final String indicator;
  final String value;
  final String unit;
  final String source;
  final String? year;
  final DateTime ingestedAt;
  final UpdateFrequency updateFrequency;
  
  const HealthDataPoint({
    required this.indicator,
    required this.value,
    required this.unit,
    required this.source,
    this.year,
    required this.ingestedAt,
    required this.updateFrequency,
  });
  
  String get freshnessLabel {
    if (updateFrequency == UpdateFrequency.historical || year != null) {
      return year ?? '—';
    }
    final age = DateTime.now().difference(ingestedAt);
    if (age.inHours < 24) return '${age.inHours}h ago';
    return '${age.inDays}d ago';
  }
}
