/// Canonical freshness tier for every Safety data value.
/// Determines how the FreshnessBadge displays and when data is considered stale.
enum UpdateFrequency {
  realTime,   // seconds–minutes: USGS, NDMA CAP, OpenAQ live
  hourly,     // hours: aggregated feeds
  daily,      // once a day: batch summaries
  weekly,     // weekly reports
  historical, // static reference data
  forecast,   // explicitly labeled predictions
  unknown,    // unclassified — always shown as grey badge
}

/// Every piece of safety data shown to the user must be wrapped in a
/// [SafetyDataPoint]. This is the contract that prevents stale data from
/// being displayed without a freshness label.
class SafetyDataPoint {
  final String value;
  final String unit;

  /// Human-readable source name, e.g. 'USGS', 'NDMA SACHET', 'OpenAQ'.
  final String source;

  /// Type of organisation providing this data.
  final String sourceType; // 'government' | 'scientific' | 'ngo' | 'commercial'

  /// When the underlying observation was made (NOT when we ingested it).
  final DateTime observedAt;

  /// When we fetched/ingested this value into the local DB.
  final DateTime ingestedAt;

  final UpdateFrequency updateFrequency;

  /// 0.0–1.0 trust score (authority × freshness × agreement).
  final double confidence;

  const SafetyDataPoint({
    required this.value,
    required this.unit,
    required this.source,
    this.sourceType = 'scientific',
    required this.observedAt,
    required this.ingestedAt,
    required this.updateFrequency,
    this.confidence = 0.9,
  });

  /// Human-readable age of this data point relative to now.
  String get freshnessLabel {
    final age = DateTime.now().difference(observedAt);
    if (age.inSeconds < 60) return 'just now';
    if (age.inMinutes < 60) return '${age.inMinutes} min ago';
    if (age.inHours < 24) return '${age.inHours}h ago';
    return '${age.inDays}d ago';
  }

  /// True when this data is older than its expected freshness window.
  bool get isStale {
    final age = DateTime.now().difference(observedAt);
    switch (updateFrequency) {
      case UpdateFrequency.realTime:
        return age.inMinutes > 15;
      case UpdateFrequency.hourly:
        return age.inHours > 3;
      case UpdateFrequency.daily:
        return age.inHours > 36;
      default:
        return false;
    }
  }
}
