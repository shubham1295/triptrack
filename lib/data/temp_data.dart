import 'package:triptrack/models/entry.dart';
import 'package:flutter/material.dart';
import 'package:triptrack/theme/app_constants.dart';

/// Temporary data file for simulating database entries and trip data
/// TODO: Replace this with actual database calls when implementing persistence

class TempData {
  // ==================== ENTRY DATA MANAGEMENT ====================

  /// Mutable list of entries
  static final List<Entry> _entries = [
    createDummyEntry(
      id: 1,
      categoryName: 'Flight',
      amount: 12500,
      date: DateTime.now(),
      notes: 'Tokyo Flight',
      isExcludedFromMetrics: true,
      currency: 'JPY',
    ),
    createDummyEntry(
      id: 2,
      categoryName: 'Accomodation',
      amount: 8000,
      date: DateTime.now(),
      notes: 'Shinjuku Hotel',
    ),
    createDummyEntry(
      id: 3,
      categoryName: 'Restaurant',
      amount: 2500,
      date: DateTime.now().subtract(const Duration(days: 1)),
      notes: 'Dinner at Senso-ji',
    ),
    createDummyEntry(
      id: 4,
      categoryName: 'Transportation',
      amount: 1200,
      date: DateTime.now().subtract(const Duration(days: 1)),
      notes: 'Taxi to Airport',
    ),
    createDummyEntry(
      id: 5,
      categoryName: 'Shopping',
      amount: 3000,
      date: DateTime.now().subtract(const Duration(days: 2)),
      notes: 'Souvenirs',
    ),
    createDummyEntry(
      id: 6,
      categoryName: 'Shopping',
      amount: 3000,
      date: DateTime.now().subtract(const Duration(days: 2)),
      notes: 'Souvenirs',
    ),
    createDummyEntry(
      id: 7,
      categoryName: 'Shopping',
      amount: 3000,
      date: DateTime.now().subtract(const Duration(days: 2)),
      notes: 'Souvenirs',
    ),
  ];

  /// Creates a dummy entry with the given parameters
  static Entry createDummyEntry({
    required int id,
    required String categoryName,
    required double amount,
    required DateTime date,
    String currency = 'USD',
    String? notes,
    String? groupId,
    DateTime? endDate,
    bool isExcludedFromMetrics = false,
  }) {
    final categoryMap = AppConstants.categories.firstWhere(
      (c) => c['name'] == categoryName,
      orElse: () => AppConstants.categories.first,
    );

    final category = Category(
      name: categoryMap['name'] as String?,
      icon: (categoryMap['icon'] as IconData).codePoint,
      color: (categoryMap['color'] as Color).value,
    );

    return Entry(
      id: id,
      amount: amount,
      currency: currency,
      exchangeRate: 1.7,
      category: category,
      date: date,
      endDate: endDate,
      notes: notes,
      paymentMode: 'Cash',
      groupId: groupId,
      isExcludedFromMetrics: isExcludedFromMetrics,
    );
  }

  /// Returns a list of dummy entries for testing
  static List<Entry> getDummyEntries() {
    return List.unmodifiable(_entries);
  }
}
