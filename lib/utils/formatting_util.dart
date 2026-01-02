import 'package:intl/intl.dart';
import 'package:triptrack/theme/app_constants.dart';

/// Utility class for formatting numbers and dates
class FormattingUtil {
  /// Formats a number with commas (Indian numbering system: 3, 2, 2 format)
  ///
  /// * [number] - The number to format
  /// * [currencyCode] - The currency code (e.g., 'USD', 'INR', 'EUR')
  /// * [decimalDigits] - Number of decimal digits to display (default: 2)
  ///
  /// Example usage:
  /// ```dart
  /// // Default 2 decimal digits
  /// FormattingUtil.formatCurrency(1234.56, 'USD'); // Returns: $1,234.56
  ///
  /// // No decimal digits
  /// FormattingUtil.formatCurrency(1234.56, 'USD', decimalDigits: 0); // Returns: $1,235
  ///```
  static String formatCurrency(
    double number,
    String currencyCode, {
    int decimalDigits = 2,
  }) {
    // Normalize currency code to uppercase for consistent mapping
    final normalizedCode = currencyCode.toUpperCase();

    // Get locale from centralized mapping in AppConstants
    // This will be replaced with API data in the future
    String locale = AppConstants.currencyLocaleMap[normalizedCode] ?? 'en_US';

    // Initialize the formatter
    final formatter = NumberFormat.simpleCurrency(
      locale: locale,
      name: normalizedCode,
      decimalDigits: decimalDigits,
    );

    // Format the number
    return formatter.format(number);
  }
}
