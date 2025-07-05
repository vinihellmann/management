import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final _base = GoogleFonts.poppins();

  static final headlineLarge = _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static final headlineMedium = _base.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  static final headlineSmall = _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static final bodyLarge = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  static final bodyMedium = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  static final bodySmall = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );

  static final button = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  static final input = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static TextTheme getTextTheme(Color color) {
    return TextTheme(
      headlineLarge: headlineLarge.copyWith(color: color),
      headlineMedium: headlineMedium.copyWith(color: color),
      headlineSmall: headlineSmall.copyWith(color: color),
      bodyLarge: bodyLarge.copyWith(color: color),
      bodyMedium: bodyMedium.copyWith(color: color),
      bodySmall: bodySmall.copyWith(color: color),
      labelLarge: button.copyWith(color: color),
      titleMedium: input.copyWith(color: color),
    );
  }
}
