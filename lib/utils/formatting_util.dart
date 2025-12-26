/// Utility class for formatting numbers and dates
class FormattingUtil {
  /// Formats a number with commas (Indian numbering system: 3, 2, 2 format)
  static String formatNumber(double number) {
    final str = number.toStringAsFixed(0);
    final parts = <String>[];
    var remaining = str;

    if (remaining.length > 3) {
      parts.insert(0, remaining.substring(remaining.length - 3));
      remaining = remaining.substring(0, remaining.length - 3);

      while (remaining.length > 2) {
        parts.insert(0, remaining.substring(remaining.length - 2));
        remaining = remaining.substring(0, remaining.length - 2);
      }

      if (remaining.isNotEmpty) {
        parts.insert(0, remaining);
      }
    } else {
      return str;
    }

    return parts.join(',');
  }
}
