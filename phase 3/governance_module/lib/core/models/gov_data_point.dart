/// Frequency at which a data indicator is updated by its source.
enum UpdateFrequency { realTime, hourly, daily, weekly, annual, historical, unknown }

/// Represents a single live or cached data point fetched from an external
/// authoritative source (e.g. World Bank Indicators API).
class GovDataPoint {
  final String indicator;
  final String value;
  final String unit;
  final String source;

  /// The reference year for annual data (e.g. '2022'). Null for real-time data.
  final String? year;

  /// When this data point was last ingested / fetched.
  final DateTime ingestedAt;

  final UpdateFrequency updateFrequency;

  const GovDataPoint({
    required this.indicator,
    required this.value,
    required this.unit,
    required this.source,
    this.year,
    required this.ingestedAt,
    required this.updateFrequency,
  });

  /// Human-readable label for the freshness badge.
  String get freshnessLabel {
    if (year != null) return '$source · $year';
    final age = DateTime.now().difference(ingestedAt);
    if (age.inDays > 0) return '${age.inDays}d ago';
    if (age.inHours > 0) return '${age.inHours}h ago';
    return '${age.inMinutes}m ago';
  }
}
