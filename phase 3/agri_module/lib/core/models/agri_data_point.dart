/// Represents a single piece of agriculture data with provenance metadata.
/// Every value shown to the user must be wrapped in an [AgriDataPoint] so
/// the [FreshnessBadge] widget can display its source and age correctly.
enum UpdateFrequency {
  realTime,
  hourly,
  daily,
  weekly,
  historical,
  forecast,
  unknown,
}

class AgriDataPoint {
  final String value;
  final String unit;
  final String source;
  final DateTime observedAt;
  final UpdateFrequency updateFrequency;

  const AgriDataPoint({
    required this.value,
    required this.unit,
    required this.source,
    required this.observedAt,
    this.updateFrequency = UpdateFrequency.unknown,
  });

  /// Human-readable age label for display in [FreshnessBadge].
  String get freshnessLabel {
    final age = DateTime.now().difference(observedAt);
    if (age.inMinutes < 1) return 'just now';
    if (age.inMinutes < 60) return '${age.inMinutes} min ago';
    if (age.inHours < 24) return '${age.inHours}h ago';
    return '${age.inDays}d ago';
  }

  /// Returns true when the data is considered too old for its [updateFrequency].
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
