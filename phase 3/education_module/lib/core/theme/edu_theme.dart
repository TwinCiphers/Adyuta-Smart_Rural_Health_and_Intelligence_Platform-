import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EduTheme {
  static const Color primaryIndigo = Color(0xFF311B92);
  static const Color primaryViolet = Color(0xFF512DA8);
  static const Color accentGold = Color(0xFFFFB300);
  static const Color accentTeal = Color(0xFF00897B);
  
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBg = Colors.white;
  static const Color textDark = Color(0xFF0F172A);
  static const Color textGrey = Color(0xFF64748B);

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF311B92), Color(0xFF673AB7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF512DA8), Color(0xFF7E57C2)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF311B92).withOpacity(0.08),
      blurRadius: 15,
      offset: const Offset(0, 6),
    ),
  ];

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.transparent,
      primaryColor: primaryIndigo,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryIndigo,
        primary: primaryIndigo,
        secondary: accentGold,
      ),
      textTheme: GoogleFonts.interTextTheme(),
    );
  }
}
