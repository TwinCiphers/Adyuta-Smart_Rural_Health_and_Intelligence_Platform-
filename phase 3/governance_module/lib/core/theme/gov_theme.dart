import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GovTheme {
  // Authoritative Governance Color Palette
  static const Color primaryNavy = Color(0xFF0F172A); // Deep Slate Navy
  static const Color accentBlue = Color(0xFF1E40AF); // Authoritative Royal Blue
  static const Color saffronGold = Color(0xFFD97706); // Indian Saffron Accent
  static const Color emeraldGreen = Color(0xFF15803D); // Eligible / Document Ready
  static const Color crimsonAlert = Color(0xFFDC2626); // Missing Doc / Violation Alert
  
  static const Color background = Color(0xFFF8FAFC); // Crisp Light Grey
  static const Color surface = Colors.white;
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Hero Gradients
  static const LinearGradient navyGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient saffronGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Box Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 14,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get elevationShadow => [
    BoxShadow(
      color: primaryNavy.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // ThemeData
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    primaryColor: accentBlue,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentBlue,
      primary: accentBlue,
      secondary: saffronGold,
      surface: surface,
      background: background,
    ),
    textTheme: GoogleFonts.interTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryNavy,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
