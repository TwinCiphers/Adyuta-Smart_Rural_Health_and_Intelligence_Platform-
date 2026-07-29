import 'package:flutter/material.dart';

class AdyutaTextStyles {
  static TextTheme getTextTheme(Color primaryTextColor, Color secondaryTextColor) {
    return TextTheme(
      displayLarge: TextStyle(
          fontWeight: FontWeight.w700, fontSize: 36, height: 1.1, color: primaryTextColor),
      displayMedium: TextStyle(
          fontWeight: FontWeight.w700, fontSize: 28, height: 1.2, color: primaryTextColor),
      headlineLarge: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 24, height: 1.2, color: primaryTextColor),
      headlineMedium: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 20, height: 1.2, color: primaryTextColor),
      headlineSmall: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 18, height: 1.2, color: primaryTextColor),
      titleLarge: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 16, height: 1.2, color: primaryTextColor),
      titleMedium: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 14, height: 1.5, color: secondaryTextColor),
      titleSmall: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 12, height: 1.5, color: secondaryTextColor),
      bodyLarge: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 16, height: 1.5, color: primaryTextColor),
      bodyMedium: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 14, height: 1.5, color: primaryTextColor),
      bodySmall: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 12, height: 1.5, color: secondaryTextColor),
      labelLarge: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 14, height: 1.2, color: primaryTextColor),
      labelMedium: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 12, height: 1.2, color: primaryTextColor),
      labelSmall: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 10, height: 1.2, color: secondaryTextColor),
    );
  }
}
