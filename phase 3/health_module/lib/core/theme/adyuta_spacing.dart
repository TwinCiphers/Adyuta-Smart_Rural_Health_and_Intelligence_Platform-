import 'package:flutter/material.dart';

class AdyutaSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const EdgeInsets cardPadding = EdgeInsets.all(20);
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  static const SizedBox sectionGap = SizedBox(height: 24);
  static const SizedBox itemGap = SizedBox(height: 12);

  static final BorderRadius borderRadiusSm = BorderRadius.circular(10);
  static final BorderRadius borderRadiusMd = BorderRadius.circular(14);
  static final BorderRadius borderRadiusLg = BorderRadius.circular(20);
  static final BorderRadius borderRadiusXl = BorderRadius.circular(28);
  static final BorderRadius borderRadiusFull = BorderRadius.circular(999);
}

class AdyutaShadows {
  static const List<BoxShadow> shadowSm = [
    BoxShadow(color: Color(0x0A1A6B4A), blurRadius: 8, offset: Offset(0, 2))
  ];
  static const List<BoxShadow> shadowMd = [
    BoxShadow(color: Color(0x0D1A6B4A), blurRadius: 16, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x061A6B4A), blurRadius: 4, offset: Offset(0, 1))
  ];
  static const List<BoxShadow> shadowLg = [
    BoxShadow(color: Color(0x141A6B4A), blurRadius: 32, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x0A1A6B4A), blurRadius: 8, offset: Offset(0, 2))
  ];
  static const List<BoxShadow> shadowEmergency = [
    BoxShadow(color: Color(0x33B00020), blurRadius: 20, offset: Offset(0, 4))
  ];
}

class AdyutaMotion {
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);
  static const Duration durationPulse = Duration(milliseconds: 1200);

  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveSpring = Curves.elasticOut;
  static const Curve curveEnter = Curves.easeOutCubic;
  static const Curve curveExit = Curves.easeInCubic;
}
