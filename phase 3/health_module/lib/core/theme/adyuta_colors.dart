import 'package:flutter/material.dart';

/// Semantic colors for ADYUTA Health app
class AdyutaColors extends ThemeExtension<AdyutaColors> {
  // Severity scale
  final Color emergencyRed;
  final Color urgentAmber;
  final Color moderateYellow;
  final Color safeGreen;

  final Color maternalPink;
  final Color childBlue;
  final Color vitalsTeal;
  final Color medicineOrange;
  final Color fitnessPurple;

  // Neutral surfaces
  final Color surfaceWarm;
  final Color cardSurface;
  final Color cardBorder;
  final Color divider;

  // Text hierarchy
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color textOnEmergency;
  final Color textInverse;

  const AdyutaColors({
    required this.emergencyRed,
    required this.urgentAmber,
    required this.moderateYellow,
    required this.safeGreen,
    required this.maternalPink,
    required this.childBlue,
    required this.vitalsTeal,
    required this.medicineOrange,
    required this.fitnessPurple,
    required this.surfaceWarm,
    required this.cardSurface,
    required this.cardBorder,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.textOnEmergency,
    required this.textInverse,
  });

  @override
  AdyutaColors copyWith({
    Color? emergencyRed,
    Color? urgentAmber,
    Color? moderateYellow,
    Color? safeGreen,
    Color? maternalPink,
    Color? childBlue,
    Color? vitalsTeal,
    Color? medicineOrange,
    Color? fitnessPurple,
    Color? surfaceWarm,
    Color? cardSurface,
    Color? cardBorder,
    Color? divider,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? textOnEmergency,
    Color? textInverse,
  }) {
    return AdyutaColors(
      emergencyRed: emergencyRed ?? this.emergencyRed,
      urgentAmber: urgentAmber ?? this.urgentAmber,
      moderateYellow: moderateYellow ?? this.moderateYellow,
      safeGreen: safeGreen ?? this.safeGreen,
      maternalPink: maternalPink ?? this.maternalPink,
      childBlue: childBlue ?? this.childBlue,
      vitalsTeal: vitalsTeal ?? this.vitalsTeal,
      medicineOrange: medicineOrange ?? this.medicineOrange,
      fitnessPurple: fitnessPurple ?? this.fitnessPurple,
      surfaceWarm: surfaceWarm ?? this.surfaceWarm,
      cardSurface: cardSurface ?? this.cardSurface,
      cardBorder: cardBorder ?? this.cardBorder,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      textOnEmergency: textOnEmergency ?? this.textOnEmergency,
      textInverse: textInverse ?? this.textInverse,
    );
  }

  @override
  AdyutaColors lerp(ThemeExtension<AdyutaColors>? other, double t) {
    if (other is! AdyutaColors) {
      return this;
    }
    return AdyutaColors(
      emergencyRed: Color.lerp(emergencyRed, other.emergencyRed, t)!,
      urgentAmber: Color.lerp(urgentAmber, other.urgentAmber, t)!,
      moderateYellow: Color.lerp(moderateYellow, other.moderateYellow, t)!,
      safeGreen: Color.lerp(safeGreen, other.safeGreen, t)!,
      maternalPink: Color.lerp(maternalPink, other.maternalPink, t)!,
      childBlue: Color.lerp(childBlue, other.childBlue, t)!,
      vitalsTeal: Color.lerp(vitalsTeal, other.vitalsTeal, t)!,
      medicineOrange: Color.lerp(medicineOrange, other.medicineOrange, t)!,
      fitnessPurple: Color.lerp(fitnessPurple, other.fitnessPurple, t)!,
      surfaceWarm: Color.lerp(surfaceWarm, other.surfaceWarm, t)!,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textOnEmergency: Color.lerp(textOnEmergency, other.textOnEmergency, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
    );
  }

  static AdyutaColors of(BuildContext context) {
    return Theme.of(context).extension<AdyutaColors>()!;
  }

  static const light = AdyutaColors(
    emergencyRed: Color(0xFFB00020),
    urgentAmber: Color(0xFFE65100),
    moderateYellow: Color(0xFFF9A825),
    safeGreen: Color(0xFF1B5E20),
    maternalPink: Color(0xFFAD1457),
    childBlue: Color(0xFF0277BD),
    vitalsTeal: Color(0xFF00695C),
    medicineOrange: Color(0xFFBF360C),
    fitnessPurple: Color(0xFF673AB7),
    surfaceWarm: Color(0xFFF7F9F6),
    cardSurface: Color(0xFFFFFFFF),
    cardBorder: Color(0xFFE8F0EB),
    divider: Color(0xFFDAE5DC),
    textPrimary: Color(0xFF0D1F14),
    textSecondary: Color(0xFF4A6155),
    textDisabled: Color(0xFF8FA896),
    textOnEmergency: Color(0xFFFFFFFF),
    textInverse: Color(0xFFF7F9F6),
  );

  static const dark = AdyutaColors(
    emergencyRed: Color(0xFFCF6679),
    urgentAmber: Color(0xFFFF9800),
    moderateYellow: Color(0xFFFFEB3B),
    safeGreen: Color(0xFF4CAF50),
    maternalPink: Color(0xFFF06292),
    childBlue: Color(0xFF29B6F6),
    vitalsTeal: Color(0xFF26A69A),
    medicineOrange: Color(0xFFFF7043),
    fitnessPurple: Color(0xFF9575CD),
    surfaceWarm: Color(0xFF0D1512),
    cardSurface: Color(0xFF162019),
    cardBorder: Color(0xFF2A3D2E),
    divider: Color(0xFF2A3D2E),
    textPrimary: Color(0xFFF7F9F6),
    textSecondary: Color(0xFF8FA896),
    textDisabled: Color(0xFF4A6155),
    textOnEmergency: Color(0xFFFFFFFF),
    textInverse: Color(0xFF0D1F14),
  );
}
