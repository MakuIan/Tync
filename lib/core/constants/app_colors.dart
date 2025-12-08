import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Color
  static const Color primary = Color(0xFF2196F3);
  static const Color accent = Color(0xFF00BCD4);

  // Status Farben (Timer)
  static const Color success = Color(0xFF4CAF50);
  static const Color danger = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);

  // Neutral
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;

  // For labels or unselected Tabs
  static const Color textSecondary = _grey600;

  // Für inaktive Buttons (z.B. Reset, wenn Stopwatch auf 0 ist)
  static const Color buttonNeutral = _grey300;

  // Fuer Icons in neutralen Buttons
  static const Color iconNeutral = _grey800;

  // For borders
  static const Color border = _grey300;

  // For text hints
  static const Color textHint = _grey400;

  // For dividing list elements
  static const Color divider = _grey200;

  static const Color surfaceVariant = _grey50;

  static const Color _grey50 = Color(0xFFFAFAFA);
  static const Color _grey200 = Color(0xFFEEEEEE);
  static const Color _grey300 = Color(0xFFE0E0E0);
  static const Color _grey400 = Color(0xFFBDBDBD);
  static const Color _grey600 = Color(0xFF757575);
  static const Color _grey800 = Color(0xFF424242);
}
