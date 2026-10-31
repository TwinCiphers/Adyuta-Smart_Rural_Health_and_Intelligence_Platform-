import 'package:bhashini_core/bhashini_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/safety_data_point.dart';

/// Displays a source + freshness chip under every live safety data value.
///
/// Rule: the UI layer is contractually forbidden from rendering a value
/// without this badge. "AQI: 142" is a bug. "AQI: 142 · OpenAQ · 3 min ago"
/// is the only acceptable form.
///
/// Color coding:
///   🔴 red dot  — REAL_TIME source (USGS, NDMA CAP, OpenAQ)
///   🟠 orange   — HOURLY
///   🔵 blue     — DAILY / WEEKLY
///   ⚫ grey     — CACHED / OFFLINE / STALE
class FreshnessBadge extends StatelessWidget {
  final String source;
  final DateTime observedAt;
  final UpdateFrequency frequency;
  final bool isOffline;

  const FreshnessBadge({
    super.key,
    required this.source,
    required this.observedAt,
    required this.frequency,
    this.isOffline = false,
  });

  /// Convenience constructor from a [SafetyDataPoint].
  factory FreshnessBadge.fromDataPoint(SafetyDataPoint dp, {bool isOffline = false}) {
    return FreshnessBadge(
      source: dp.source,
      observedAt: dp.observedAt,
      frequency: dp.updateFrequency,
      isOffline: isOffline,
    );
  }

  String get _label {
    final age = DateTime.now().difference(observedAt);
    final ageStr = age.inSeconds < 60
        ? 'just now'
        : age.inMinutes < 60
            ? '${age.inMinutes} min ago'
            : age.inHours < 24
                ? '${age.inHours}h ago'
                : '${age.inDays}d ago';
    return '$source · $ageStr';
  }

  Color get _dotColor {
    if (isOffline) return Colors.grey;
    switch (frequency) {
      case UpdateFrequency.realTime:
        return const Color(0xFFEF4444); // red
      case UpdateFrequency.hourly:
        return const Color(0xFFF97316); // orange
      case UpdateFrequency.daily:
      case UpdateFrequency.weekly:
        return const Color(0xFF3B82F6); // blue
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: _dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        GlobalBhashiniText(
          isOffline ? 'Cached · $_label' : _label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: isOffline ? Colors.grey.shade500 : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
