import 'package:bhashini_core/bhashini_core.dart';
import 'package:flutter/material.dart';

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
