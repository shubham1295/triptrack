import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Default corner radius for components (12px)
const double kDefaultBorderRadius = 12.0;

/// Border radius constant
const BorderRadius kBorderRadius = BorderRadius.all(
  Radius.circular(kDefaultBorderRadius),
);

/// App theme configuration
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.white,
        error: Colors.red,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.text,
        onError: AppColors.white,
        onSurfaceVariant: AppColors.grey,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _buildTextTheme(isDarkMode: false),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge(
          isDarkMode: false,
        ).copyWith(color: AppColors.white),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 4,
          shadowColor: AppColors.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: AppTextStyles.labelLarge(isDarkMode: false),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: kBorderRadius,
          borderSide: BorderSide(color: AppColors.lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: kBorderRadius,
          borderSide: BorderSide(color: AppColors.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: kBorderRadius,
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: kBorderRadius,
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColorsDark.primary,
        secondary: AppColorsDark.secondary,
        surface: AppColorsDark.lightGrey,
        error: Colors.red,
        onPrimary: AppColorsDark.white,
        onSecondary: AppColorsDark.white,
        onSurface: AppColorsDark.text,
        onError: AppColorsDark.white,
        onSurfaceVariant: AppColorsDark.text.withOpacity(0.7),
      ),
      scaffoldBackgroundColor: AppColorsDark.background,
      textTheme: _buildTextTheme(isDarkMode: true),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorsDark.background,
        foregroundColor: AppColorsDark.primary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge(
          isDarkMode: true,
        ).copyWith(color: AppColorsDark.primary),
      ),
      cardTheme: CardThemeData(
        color: AppColorsDark.lightGrey,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsDark.primary,
          foregroundColor: AppColorsDark.white,
          elevation: 4,
          shadowColor: AppColorsDark.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: AppTextStyles.labelLarge(isDarkMode: true),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorsDark.lightGrey,
        border: OutlineInputBorder(
          borderRadius: kBorderRadius,
          borderSide: BorderSide(color: AppColorsDark.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: kBorderRadius,
          borderSide: BorderSide(color: AppColorsDark.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: kBorderRadius,
          borderSide: BorderSide(color: AppColorsDark.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: kBorderRadius,
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColorsDark.secondary,
        foregroundColor: AppColorsDark.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
      ),
    );
  }

  /// Build text theme using Poppins
  static TextTheme _buildTextTheme({bool isDarkMode = false}) {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();

    return baseTextTheme.copyWith(
      displayLarge: AppTextStyles.displayLarge(isDarkMode: isDarkMode),
      displayMedium: AppTextStyles.displayMedium(isDarkMode: isDarkMode),
      displaySmall: AppTextStyles.displaySmall(isDarkMode: isDarkMode),
      headlineLarge: AppTextStyles.headlineLarge(isDarkMode: isDarkMode),
      headlineMedium: AppTextStyles.headlineMedium(isDarkMode: isDarkMode),
      headlineSmall: AppTextStyles.headlineSmall(isDarkMode: isDarkMode),
      titleLarge: AppTextStyles.titleLarge(isDarkMode: isDarkMode),
      titleMedium: AppTextStyles.titleMedium(isDarkMode: isDarkMode),
      titleSmall: AppTextStyles.titleSmall(isDarkMode: isDarkMode),
      bodyLarge: AppTextStyles.bodyLarge(isDarkMode: isDarkMode),
      bodyMedium: AppTextStyles.bodyMedium(isDarkMode: isDarkMode),
      bodySmall: AppTextStyles.bodySmall(isDarkMode: isDarkMode),
      labelLarge: AppTextStyles.labelLarge(isDarkMode: isDarkMode),
      labelMedium: AppTextStyles.labelMedium(isDarkMode: isDarkMode),
      labelSmall: AppTextStyles.labelSmall(isDarkMode: isDarkMode),
    );
  }
}
