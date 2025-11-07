import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography styles using Poppins (primary) and Inter (fallback)
class AppTextStyles {
  AppTextStyles._(); // Private constructor to prevent instantiation

  // Base text style with Poppins font
  static TextStyle _baseStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.text,
    );
  }

  // Display styles
  static TextStyle displayLarge = _baseStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
  );

  static TextStyle displayMedium = _baseStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
  );

  static TextStyle displaySmall = _baseStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
  );

  // Headline styles
  static TextStyle headlineLarge = _baseStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headlineMedium = _baseStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headlineSmall = _baseStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  // Title styles
  static TextStyle titleLarge = _baseStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );

  static TextStyle titleMedium = _baseStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle titleSmall = _baseStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // Body styles
  static TextStyle bodyLarge = _baseStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle bodyMedium = _baseStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle bodySmall = _baseStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  // Label styles
  static TextStyle labelLarge = _baseStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelMedium = _baseStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelSmall = _baseStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
}

