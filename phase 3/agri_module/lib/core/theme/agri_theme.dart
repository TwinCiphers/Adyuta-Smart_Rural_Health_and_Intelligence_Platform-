import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AgriTheme {
  // Premium Curated Color Palette
  static const Color primaryGreen = Color(0xFF1E6B3B);
  static const Color darkGreen = Color(0xFF0D3B1E);
  static const Color lightGreen = Color(0xFFE8F5EE);
  static const Color accentGold = Color(0xFFF59E0B);
  static const Color amberLight = Color(0xFFFEF3C7);
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBg = Colors.white;
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color priceUp = Color(0xFF10B981);
  static const Color priceDown = Color(0xFFEF4444);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F4D2A), Color(0xFF1E8048)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient weatherGradient = LinearGradient(
    colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Box Shadows
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withOpacity(0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ];

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.transparent,
      primaryColor: primaryGreen,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: accentGold,
        background: background,
        surface: cardBg,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
            color: textDark, fontWeight: FontWeight.bold, fontSize: 32),
        displayMedium: GoogleFonts.outfit(
            color: textDark, fontWeight: FontWeight.bold, fontSize: 24),
        titleLarge: GoogleFonts.outfit(
            color: textDark, fontWeight: FontWeight.w600, fontSize: 20),
        titleMedium: GoogleFonts.outfit(
            color: textDark, fontWeight: FontWeight.w600, fontSize: 16),
        bodyLarge: GoogleFonts.outfit(
            color: textDark, fontWeight: FontWeight.normal, fontSize: 16),
        bodyMedium: GoogleFonts.outfit(
            color: textMuted, fontWeight: FontWeight.normal, fontSize: 14),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cardBg,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        iconTheme: const IconThemeData(color: textDark),
        titleTextStyle: GoogleFonts.outfit(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
