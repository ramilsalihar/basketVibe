import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 48.0;

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: 20.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardPaddingLG = EdgeInsets.all(20.0);

  static const SizedBox gapXS = SizedBox(height: 4);
  static const SizedBox gapSM = SizedBox(height: 8);
  static const SizedBox gapMD = SizedBox(height: 12);
  static const SizedBox gapLG = SizedBox(height: 16);
  static const SizedBox gapXL = SizedBox(height: 24);
  static const SizedBox gapXXL = SizedBox(height: 32);

  static const SizedBox rowGapSM = SizedBox(width: 8);
  static const SizedBox rowGapMD = SizedBox(width: 12);
  static const SizedBox rowGapLG = SizedBox(width: 16);
}
