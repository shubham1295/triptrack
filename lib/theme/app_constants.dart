import 'package:flutter/material.dart';

class AppConstants {
  static const BorderRadius cardBorderRadius = BorderRadius.all(
    Radius.circular(10),
  );
  static const double avatarRadius = 25;
  static const double popupMenuIconSize = 20;
  static const double calendarIconSize = 12;
  static const Color greyColor = Colors.grey;
  static const double drawerWidthFactor = 0.85;
  static const double myTripsFontSize = 18;
  static const double addIconSize = 16;
  static const double addTextFontSize = 14;
  static const double previousTripFontSize = 14;
  static const double tripCardHeight = 10;
  static const double sizedBoxHeight = 20;
  static const double sizedBoxWidth = 4;
  static const double bottomNavBarSelectedItemAlpha = 0.6;
  static final List<Map<String, dynamic>> categories = [
    {
      'name': 'Transportation',
      'icon': Icons.directions_car,
      'color': Colors.blue.shade400,
    },
    {
      'name': 'Restaurant',
      'icon': Icons.restaurant,
      'color': Colors.orange.shade400,
    },
    {
      'name': 'Accomodation',
      'icon': Icons.hotel,
      'color': Colors.green.shade400,
    },
    {
      'name': 'Groceries',
      'icon': Icons.local_grocery_store,
      'color': Colors.purple.shade400,
    },
    {
      'name': 'Shopping',
      'icon': Icons.shopping_bag,
      'color': Colors.teal.shade400,
    },
    {
      'name': 'Activities',
      'icon': Icons.local_activity,
      'color': Colors.pink.shade400,
    },
    {'name': 'Drinks', 'icon': Icons.local_bar, 'color': Colors.amber.shade400},
    {'name': 'Coffee', 'icon': Icons.coffee, 'color': Colors.brown.shade400},
    {'name': 'Flight', 'icon': Icons.flight, 'color': Colors.cyan.shade400},
    {
      'name': 'General',
      'icon': Icons.category,
      'color': Colors.indigo.shade400,
    },
    {
      'name': 'Fees & charges',
      'icon': Icons.attach_money,
      'color': Colors.red.shade400,
    },
    {
      'name': 'Sightseeing',
      'icon': Icons.camera_alt,
      'color': Colors.lime.shade700,
    },
    {
      'name': 'Entertainment',
      'icon': Icons.movie,
      'color': Colors.lightGreen.shade400,
    },
    {
      'name': 'Exchange Fees',
      'icon': Icons.currency_exchange,
      'color': Colors.deepOrange.shade400,
    },
  ];

  static const Map<String, Map<String, String>> currencyData = {
    // --- The World's Major Currencies ---

    // North America
    'USD': {'name': 'US Dollar', 'symbol': '\$'},
    'CAD': {'name': 'Canadian Dollar', 'symbol': 'CA\$'},

    // Europe
    'EUR': {'name': 'Euro', 'symbol': '€'},
    'GBP': {'name': 'British Pound', 'symbol': '£'},
    'CHF': {'name': 'Swiss Franc', 'symbol': 'CHF'},
    'SEK': {'name': 'Swedish Krona', 'symbol': 'kr'},
    'NOK': {'name': 'Norwegian Krone', 'symbol': 'kr'},
    'DKK': {'name': 'Danish Krone', 'symbol': 'kr'},

    // Asia/Pacific
    'JPY': {'name': 'Japanese Yen', 'symbol': '¥'},
    'AUD': {'name': 'Australian Dollar', 'symbol': 'A\$'},
    'NZD': {'name': 'New Zealand Dollar', 'symbol': 'NZ\$'},
    'SGD': {'name': 'Singapore Dollar', 'symbol': 'S\$'},
    'HKD': {'name': 'Hong Kong Dollar', 'symbol': 'HK\$'},

    // Key Emerging Market Currencies (High Volume/Geographic Importance)
    'CNY': {'name': 'Chinese Yuan', 'symbol': '¥'},
    'INR': {'name': 'Indian Rupee', 'symbol': '₹'},
  };
}
