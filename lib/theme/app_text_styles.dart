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
    bool isDarkMode = false,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? (isDarkMode ? AppColorsDark.text : AppColors.text),
    );
  }

  // Display styles
  static TextStyle displayLarge({bool isDarkMode = false}) => _baseStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    isDarkMode: isDarkMode,
  );

  static TextStyle displayMedium({bool isDarkMode = false}) => _baseStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    isDarkMode: isDarkMode,
  );

  static TextStyle displaySmall({bool isDarkMode = false}) => _baseStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    isDarkMode: isDarkMode,
  );

  // Headline styles
  static TextStyle headlineLarge({bool isDarkMode = false}) => _baseStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    isDarkMode: isDarkMode,
  );

  static TextStyle headlineMedium({bool isDarkMode = false}) => _baseStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    isDarkMode: isDarkMode,
  );

  static TextStyle headlineSmall({bool isDarkMode = false}) => _baseStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    isDarkMode: isDarkMode,
  );

  // Title styles
  static TextStyle titleLarge({bool isDarkMode = false}) => _baseStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    isDarkMode: isDarkMode,
  );

  static TextStyle titleMedium({bool isDarkMode = false}) => _baseStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    isDarkMode: isDarkMode,
  );

  static TextStyle titleSmall({bool isDarkMode = false}) => _baseStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    isDarkMode: isDarkMode,
  );

  // Body styles
  static TextStyle bodyLarge({bool isDarkMode = false}) => _baseStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    isDarkMode: isDarkMode,
  );

  static TextStyle bodyMedium({bool isDarkMode = false}) => _baseStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    isDarkMode: isDarkMode,
  );

  static TextStyle bodySmall({bool isDarkMode = false}) => _baseStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    isDarkMode: isDarkMode,
  );

  // Label styles
  static TextStyle labelLarge({bool isDarkMode = false}) => _baseStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    isDarkMode: isDarkMode,
  );

  static TextStyle labelMedium({bool isDarkMode = false}) => _baseStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    isDarkMode: isDarkMode,
  );

  static TextStyle labelSmall({bool isDarkMode = false}) => _baseStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    isDarkMode: isDarkMode,
  );
}
