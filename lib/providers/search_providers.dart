import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triptrack/data/temp_data.dart';
import 'package:triptrack/models/entry.dart';

// Search Filter State Class
class SearchFilters {
  final String query;
  final String? category;
  final String? country;
  final String? paymentMode;
  final DateTime? startDate;
  final DateTime? endDate;

  const SearchFilters({
    this.query = '',
    this.category,
    this.country,
    this.paymentMode,
    this.startDate,
    this.endDate,
  });

  SearchFilters copyWith({
    String? query,
    String? category,
    String? country,
    String? paymentMode,
    DateTime? startDate,
    DateTime? endDate,
    bool clearCategory = false,
    bool clearCountry = false,
    bool clearPaymentMode = false,
    bool clearDateRange = false,
  }) {
    return SearchFilters(
      query: query ?? this.query,
      category: clearCategory ? null : (category ?? this.category),
      country: clearCountry ? null : (country ?? this.country),
      paymentMode: clearPaymentMode ? null : (paymentMode ?? this.paymentMode),
      startDate: clearDateRange ? null : (startDate ?? this.startDate),
      endDate: clearDateRange ? null : (endDate ?? this.endDate),
    );
  }

  bool get hasFilters =>
      category != null ||
      country != null ||
      paymentMode != null ||
      startDate != null ||
      endDate != null;
}

// Search Filters Notifier
class SearchFiltersNotifier extends AutoDisposeNotifier<SearchFilters> {
  @override
  SearchFilters build() {
    return const SearchFilters();
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setCategory(String? category) {
    state = state.copyWith(category: category, clearCategory: category == null);
  }

  void setCountry(String? country) {
    state = state.copyWith(country: country, clearCountry: country == null);
  }

  void setPaymentMode(String? mode) {
    state = state.copyWith(paymentMode: mode, clearPaymentMode: mode == null);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(
      startDate: start,
      endDate: end,
      clearDateRange: start == null && end == null,
    );
  }

  void clearAll() {
    state = const SearchFilters();
  }
}

final searchFiltersProvider =
    NotifierProvider.autoDispose<SearchFiltersNotifier, SearchFilters>(
      SearchFiltersNotifier.new,
    );

// Filter Options Providers (Derived from TempData)
final availableCategoriesProvider = Provider.autoDispose<List<String>>((ref) {
  final entries = TempData.getDummyEntries();
  final categories = <String>{};
  for (var entry in entries) {
    categories.add(entry.category?.name ?? '');
  }
  return categories.toList()..sort();
});

final availableCountriesProvider = Provider.autoDispose<List<String>>((ref) {
  final entries = TempData.getDummyEntries();
  final countries = <String>{};
  for (var entry in entries) {
    if (entry.location != null) {
      countries.add(entry.location!);
    }
  }
  return countries.toList()..sort();
});

final availablePaymentModesProvider = Provider.autoDispose<List<String>>((ref) {
  final entries = TempData.getDummyEntries();
  final modes = <String>{};
  for (var entry in entries) {
    modes.add(entry.paymentMode);
  }
  return modes.toList()..sort();
});

// Filtered Entries Provider
final searchResultsProvider = Provider.autoDispose<List<Entry>>((ref) {
  final filters = ref.watch(searchFiltersProvider);
  final allEntries = TempData.getDummyEntries();

  if (filters.query.isEmpty && !filters.hasFilters) {
    return allEntries;
  }

  final queryLower = filters.query.toLowerCase();

  return allEntries.where((entry) {
    // 1. Keyword Search
    bool matchesQuery = true;
    if (filters.query.isNotEmpty) {
      final categoryMatches =
          entry.category?.name != null &&
          entry.category!.name!.toLowerCase().contains(queryLower);
      matchesQuery =
          (entry.notes?.toLowerCase().contains(queryLower) ?? false) ||
          (entry.location?.toLowerCase().contains(queryLower) ?? false) ||
          categoryMatches;
    }

    // 2. Exact Match Filters
    if (filters.category != null &&
        (entry.category?.name == null ||
            entry.category!.name != filters.category)) {
      return false;
    }
    if (filters.country != null && entry.location != filters.country) {
      return false;
    }
    if (filters.paymentMode != null &&
        entry.paymentMode != filters.paymentMode) {
      return false;
    }

    // 3. Date Range
    if (filters.startDate != null) {
      if (entry.date.isBefore(filters.startDate!)) return false;
    }
    if (filters.endDate != null) {
      // Add one day to include the end date fully
      if (entry.date.isAfter(filters.endDate!.add(const Duration(days: 1)))) {
        return false;
      }
    }

    return matchesQuery;
  }).toList();
});
