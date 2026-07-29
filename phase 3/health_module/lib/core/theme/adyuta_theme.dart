import 'package:flutter/material.dart';
import 'adyuta_colors.dart';
import 'adyuta_text_styles.dart';
import 'adyuta_spacing.dart';

class AdyutaTheme {
  static const Color seedColor = Color(0xFF1A6B4A);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );
    final semanticColors = AdyutaColors.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: [semanticColors],
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: AdyutaTextStyles.getTextTheme(semanticColors.textPrimary, semanticColors.textSecondary),
      
      // Component Overrides
      appBarTheme: AppBarTheme(
        backgroundColor: semanticColors.surfaceWarm,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black.withOpacity(0.08),
        centerTitle: false,
        toolbarHeight: 64,
        iconTheme: IconThemeData(color: semanticColors.textPrimary, size: 24),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AdyutaSpacing.borderRadiusMd),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(0, 52),
          textStyle: AdyutaTextStyles.getTextTheme(semanticColors.textPrimary, semanticColors.textSecondary).labelLarge,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: AdyutaSpacing.borderRadiusMd),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(0, 52),
        ),
      ),

      cardTheme: CardTheme(
        color: semanticColors.cardSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: AdyutaSpacing.borderRadiusLg,
          side: BorderSide(color: semanticColors.cardBorder, width: 1),
        ),
      ),

      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: AdyutaSpacing.borderRadiusMd),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        tileColor: Colors.transparent,
        selectedTileColor: colorScheme.primaryContainer.withOpacity(0.3),
        minLeadingWidth: 0,
        visualDensity: VisualDensity.comfortable,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: semanticColors.surfaceWarm,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: AdyutaSpacing.borderRadiusMd,
          borderSide: BorderSide(color: semanticColors.cardBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AdyutaSpacing.borderRadiusMd,
          borderSide: BorderSide(color: semanticColors.cardBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AdyutaSpacing.borderRadiusMd,
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AdyutaSpacing.borderRadiusMd,
          borderSide: BorderSide(color: semanticColors.emergencyRed, width: 1.5),
        ),
      ),
      
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: colorScheme.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
    final semanticColors = AdyutaColors.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: [semanticColors],
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: AdyutaTextStyles.getTextTheme(semanticColors.textPrimary, semanticColors.textSecondary),
      
      appBarTheme: AppBarTheme(
        backgroundColor: semanticColors.surfaceWarm,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black.withOpacity(0.08),
        centerTitle: false,
        toolbarHeight: 64,
        iconTheme: IconThemeData(color: semanticColors.textPrimary, size: 24),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AdyutaSpacing.borderRadiusMd),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(0, 52),
          textStyle: AdyutaTextStyles.getTextTheme(semanticColors.textPrimary, semanticColors.textSecondary).labelLarge,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: AdyutaSpacing.borderRadiusMd),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(0, 52),
        ),
      ),

      cardTheme: CardTheme(
        color: semanticColors.cardSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: AdyutaSpacing.borderRadiusLg,
          side: BorderSide(color: semanticColors.cardBorder, width: 1),
        ),
      ),

      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: AdyutaSpacing.borderRadiusMd),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        tileColor: Colors.transparent,
        selectedTileColor: colorScheme.primaryContainer.withOpacity(0.3),
        minLeadingWidth: 0,
        visualDensity: VisualDensity.comfortable,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: semanticColors.cardSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: AdyutaSpacing.borderRadiusMd,
          borderSide: BorderSide(color: semanticColors.cardBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AdyutaSpacing.borderRadiusMd,
          borderSide: BorderSide(color: semanticColors.cardBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AdyutaSpacing.borderRadiusMd,
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AdyutaSpacing.borderRadiusMd,
          borderSide: BorderSide(color: semanticColors.emergencyRed, width: 1.5),
        ),
      ),
      
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: semanticColors.surfaceWarm,
        indicatorColor: colorScheme.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: 0,
      ),
    );
  }
}
