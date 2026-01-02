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
  static const Color appBarBackgroundColorLight = Color(0xFFE8EAED);
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
      'icon': Icons.downhill_skiing,
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

  // Currency to locale mapping
  // TODO: Replace with API data on app load
  static const Map<String, String> currencyLocaleMap = {
    'USD': 'en_US', // US Dollar
    'CAD': 'en_CA', // Canadian Dollar
    'EUR': 'de_DE', // Euro (using German locale)
    'GBP': 'en_GB', // British Pound
    'CHF': 'de_CH', // Swiss Franc
    'SEK': 'sv_SE', // Swedish Krona
    'NOK': 'nb_NO', // Norwegian Krone
    'DKK': 'da_DK', // Danish Krone
    'JPY': 'ja_JP', // Japanese Yen
    'AUD': 'en_AU', // Australian Dollar
    'NZD': 'en_NZ', // New Zealand Dollar
    'SGD': 'en_SG', // Singapore Dollar
    'HKD': 'zh_HK', // Hong Kong Dollar
    'CNY': 'zh_CN', // Chinese Yuan
    'INR': 'en_IN', // Indian Rupee
  };
}
