import 'package:flutter/material.dart';

/// App color constants following the design system
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary color - blue accent
  static const Color primary = Color(0xFF0066CC);

  // Secondary color - warm orange
  static const Color secondary = Color(0xFF00BFFF);

  // Background color
  static const Color background = Color(0xFFF8F9FA);

  // Text color
  static const Color text = Color(0xFF333333);

  // Additional utility colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFE0E0E0);
}

/// Dark theme color constants
class AppColorsDark {
  AppColorsDark._(); // Private constructor to prevent instantiation

  // Primary color - a slightly lighter blue for dark mode
  static const Color primary = Color(0xFF336DF2);

  // Secondary color - a softer orange for dark mode
  static const Color secondary = Color(0xFF336DF2);

  // Background color - a dark grey
  static const Color background = Color(0xFF181B28);

  // Text color - a light grey for readability on dark backgrounds
  static const Color text = Color(0xFFE0E0E0);

  // Additional utility colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF616161);
  static const Color lightGrey = Color(0xFF424242);
}
