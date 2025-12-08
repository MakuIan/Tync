import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  // --- 1. Font Weights (Gewichte) ---
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight bold = FontWeight.w700;

  // --- 2. Die riesige Timer-Anzeige ---
  static const TextStyle timerBig = TextStyle(
    fontSize: 72.0,
    fontWeight: bold,
    letterSpacing: -1.0, // Macht große Zahlen kompakter
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // --- 3. Überschriften (für Session Namen) ---
  static const TextStyle h1 = TextStyle(
    fontSize: 24.0,
    fontWeight: bold,
    color: Colors.black,
  );

  static const TextStyle h2 = TextStyle(fontSize: 20.0, fontWeight: medium);

  // --- 4. Kleine Labels (für "Sekunden",) ---
  static const TextStyle label = TextStyle(
    fontSize: 12.0,
    fontWeight: medium,
    color: Colors.grey,
    letterSpacing: 0.5,
  );

  // --- 5. Button Text ---
  static const TextStyle button = TextStyle(
    fontSize: 16.0,
    fontWeight: bold,
    letterSpacing: 0.5,
  );
}
