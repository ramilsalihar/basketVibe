import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0; // Standard card
  static const double lg = 20.0; // Large card
  static const double xl = 24.0; // Bottom sheet
  static const double xxl = 32.0; // Hero card
  static const double pill = 100.0; // Chips, tags, pill buttons

  static const BorderRadius brXS = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius brSM = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMD = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLG = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXL = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius brXXL = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius brPill = BorderRadius.all(Radius.circular(pill));
}
