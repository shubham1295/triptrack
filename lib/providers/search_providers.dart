import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triptrack/data/temp_data.dart';
import 'package:triptrack/models/entry.dart';

// Entries provider - uses real data from TempData
final entriesProvider = Provider<List<Entry>>((ref) {
  return TempData.getDummyEntries();
});

// Search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

// Selected category filter
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Selected country filter
final selectedCountryProvider = StateProvider<String?>((ref) => null);

// Selected payment mode filter
final selectedPaymentModeProvider = StateProvider<String?>((ref) => null);

// Selected date range
final selectedDateRangeProvider = StateProvider<(DateTime?, DateTime?)>(
  (ref) => (null, null),
);

// Get all unique categories
final categoriesProvider = Provider<List<String>>((ref) {
  final entries = ref.watch(entriesProvider);
  final categories = <String>{};
  for (var entry in entries) {
    categories.add(entry.category['name'] ?? '');
  }
  return categories.toList()..sort();
});

// Get all unique countries/locations
final countriesProvider = Provider<List<String>>((ref) {
  final entries = ref.watch(entriesProvider);
  final countries = <String>{};
  for (var entry in entries) {
    if (entry.location != null) {
      countries.add(entry.location!);
    }
  }
  return countries.toList()..sort();
});

// Get all unique payment modes
final paymentModesProvider = Provider<List<String>>((ref) {
  final entries = ref.watch(entriesProvider);
  final paymentModes = <String>{};
  for (var entry in entries) {
    paymentModes.add(entry.paymentMode);
  }
  return paymentModes.toList()..sort();
});

// Filtered entries based on search and filters
final filteredEntriesProvider = Provider<List<Entry>>((ref) {
  final entries = ref.watch(entriesProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final selectedCountry = ref.watch(selectedCountryProvider);
  final selectedPaymentMode = ref.watch(selectedPaymentModeProvider);
  final dateRange = ref.watch(selectedDateRangeProvider);

  return entries.where((entry) {
    // Search by notes, location, or category name
    final matchesSearch =
        searchQuery.isEmpty ||
        (entry.notes?.toLowerCase().contains(searchQuery) ?? false) ||
        (entry.location?.toLowerCase().contains(searchQuery) ?? false) ||
        entry.category['name'].toString().toLowerCase().contains(searchQuery);

    // Filter by category
    final matchesCategory =
        selectedCategory == null || entry.category['name'] == selectedCategory;

    // Filter by country/location
    final matchesCountry =
        selectedCountry == null || entry.location == selectedCountry;

    // Filter by payment mode
    final matchesPaymentMode =
        selectedPaymentMode == null || entry.paymentMode == selectedPaymentMode;

    // Filter by date range
    bool matchesDateRange = true;
    if (dateRange.$1 != null || dateRange.$2 != null) {
      final startDate = dateRange.$1;
      final endDate = dateRange.$2;
      if (startDate != null && entry.date.isBefore(startDate)) {
        matchesDateRange = false;
      }
      if (endDate != null &&
          entry.date.isAfter(endDate.add(Duration(days: 1)))) {
        matchesDateRange = false;
      }
    }

    return matchesSearch &&
        matchesCategory &&
        matchesCountry &&
        matchesPaymentMode &&
        matchesDateRange;
  }).toList();
});

// Clear all filters
final clearFiltersProvider = Provider<void Function()>((ref) {
  return () {
    ref.read(searchQueryProvider.notifier).state = '';
    ref.read(selectedCategoryProvider.notifier).state = null;
    ref.read(selectedCountryProvider.notifier).state = null;
    ref.read(selectedPaymentModeProvider.notifier).state = null;
    ref.read(selectedDateRangeProvider.notifier).state = (null, null);
  };
});
