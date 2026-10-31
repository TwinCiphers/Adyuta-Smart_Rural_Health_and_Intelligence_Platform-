import 'package:bhashini_core/bhashini_core.dart';
import 'package:flutter/material.dart';

enum UpdateFrequency { realTime, hourly, daily, weekly, annual, historical, unknown }

class EduDataPoint {
  final String indicator;
  final String value;
  final String unit;
  final String source;
  final String? year;
  final DateTime ingestedAt;
  final UpdateFrequency updateFrequency;
  
  EduDataPoint({
    required this.indicator,
    required this.value,
    required this.unit,
    required this.source,
    this.year,
    required this.ingestedAt,
    required this.updateFrequency,
  });

  String get freshnessLabel {
    if (year != null) return '$source · $year';
    final age = DateTime.now().difference(ingestedAt);
    if (age.inDays > 0) return '${age.inDays}d ago';
    return '${age.inHours}h ago';
  }
}

class FreshnessBadge extends StatelessWidget {
  final String label;
  final bool isLive;

  const FreshnessBadge({
    super.key,
    required this.label,
    this.isLive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: isLive ? Colors.blue : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: GlobalBhashiniText(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
