import 'package:flutter/material.dart';

class SafetyTheme {
  static const Color primaryRed = Color(0xFFDC2626); // Alert Crimson
  static const Color darkRed = Color(0xFF991B1B);
  static const Color warningOrange = Color(0xFFEA580C);
  static const Color accentRose = Color(0xFFE11D48);
  static const Color background = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textGrey = Color(0xFF64748B);
  static const Color cardBg = Colors.white;

  static const LinearGradient sosGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient shieldGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF312E81)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 15,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get glowShadow => [
        BoxShadow(
          color: primaryRed.withOpacity(0.35),
          blurRadius: 25,
          spreadRadius: 2,
        ),
      ];
}
