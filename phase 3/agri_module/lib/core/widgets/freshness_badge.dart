import 'package:bhashini_core/bhashini_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/agri_data_point.dart';

/// A small colored [Chip] that shows the data source and how recent the data is.
///
/// Examples:
///   🟠 Agmarknet · today 8:00 AM   (daily, live)
///   🔵 Open-Meteo · 4h ago          (hourly, live)
///   ⚫ Cached · Yesterday            (offline / stale)
class FreshnessBadge extends StatelessWidget {
  final String source;
  final DateTime observedAt;
  final UpdateFrequency frequency;
  final bool isStale;

  const FreshnessBadge({
    super.key,
    required this.source,
    required this.observedAt,
    this.frequency = UpdateFrequency.unknown,
    this.isStale = false,
  });

  /// Convenience constructor from an [AgriDataPoint].
  factory FreshnessBadge.fromDataPoint(AgriDataPoint data, {Key? key}) {
    return FreshnessBadge(
      key: key,
      source: data.source,
      observedAt: data.observedAt,
      frequency: data.updateFrequency,
      isStale: data.isStale,
    );
  }

  Color get _dotColor {
    if (isStale) return Colors.black54;
    switch (frequency) {
      case UpdateFrequency.realTime:
        return const Color(0xFF10B981); // green
      case UpdateFrequency.hourly:
        return const Color(0xFF3B82F6); // blue
      case UpdateFrequency.daily:
        return const Color(0xFFF59E0B); // amber/orange
      case UpdateFrequency.weekly:
      case UpdateFrequency.historical:
        return const Color(0xFF8B5CF6); // purple
      case UpdateFrequency.forecast:
        return const Color(0xFF06B6D4); // cyan
      default:
        return Colors.grey;
    }
  }

  String get _dotEmoji {
    if (isStale) return '⚫';
    switch (frequency) {
      case UpdateFrequency.realTime:
        return '🟢';
      case UpdateFrequency.hourly:
        return '🔵';
      case UpdateFrequency.daily:
        return '🟠';
      case UpdateFrequency.weekly:
      case UpdateFrequency.historical:
        return '🟣';
      case UpdateFrequency.forecast:
        return '🔵';
      default:
        return '⚪';
    }
  }

  String get _freshnessLabel {
    final age = DateTime.now().difference(observedAt);
    if (age.inMinutes < 1) return 'just now';
    if (age.inMinutes < 60) return '${age.inMinutes} min ago';
    if (age.inHours < 24) return '${age.inHours}h ago';
    return '${age.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final displaySource = isStale ? 'Cached' : source;
    final label = '$_dotEmoji $displaySource · $_freshnessLabel';

    return Chip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 2),
      backgroundColor:
          isStale ? Colors.grey.shade100 : _dotColor.withOpacity(0.08),
      side: BorderSide(color: _dotColor.withOpacity(0.25), width: 0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      label: GlobalBhashiniText(
        label,
        style: GoogleFonts.outfit(
          fontSize: 11,
          color: isStale ? Colors.grey.shade600 : _dotColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Lightweight inline text version for use inside list tiles / table cells.
class FreshnessText extends StatelessWidget {
  final String source;
  final DateTime observedAt;
  final bool isLive;

  const FreshnessText({
    super.key,
    required this.source,
    required this.observedAt,
    this.isLive = true,
  });

  String get _label {
    final age = DateTime.now().difference(observedAt);
    String ago;
    if (age.inMinutes < 1) {
      ago = 'just now';
    } else if (age.inMinutes < 60) {
      ago = '${age.inMinutes}m ago';
    } else if (age.inHours < 24) {
      ago = '${age.inHours}h ago';
    } else {
      ago = '${age.inDays}d ago';
    }
    return isLive ? '$source · $ago' : 'Cached · $ago';
  }

  @override
  Widget build(BuildContext context) {
    return GlobalBhashiniText(
      _label,
      style: GoogleFonts.outfit(
        fontSize: 11,
        color: isLive ? const Color(0xFF3B82F6) : Colors.grey.shade500,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
