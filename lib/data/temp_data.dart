import 'package:triptrack/models/entry.dart';
import 'package:triptrack/models/trip.dart';
import 'package:triptrack/theme/app_constants.dart';

/// Temporary data file for simulating database entries and trip data
/// TODO: Replace this with actual database calls when implementing persistence

class TempData {
  // ==================== TRIP DATA MANAGEMENT ====================

  /// Mutable list of trips - simulates database storage
  static final List<Trip> _trips = [
    Trip(
      id: '1',
      name: 'Japan',
      imagePath: 'assets/images/world-icon.jpg',
      homeCurrency: 'INR',
      startDate: DateTime(2025, 11, 10),
      endDate: DateTime(2025, 11, 20),
      totalBudget: 200000,
      dailyBudget: 1200,
    ),
    Trip(
      id: '2',
      name: 'EuropeEuropeEuropeEuropeEuropeEuropeEuropeEurope',
      imagePath: 'assets/images/world-icon.jpg',
      homeCurrency: 'INR',
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 1, 15),
      totalBudget: 350000,
      dailyBudget: 2000,
    ),
    Trip(
      id: '3',
      name: 'USA',
      imagePath: 'assets/images/world-icon.jpg',
      homeCurrency: 'INR',
      startDate: DateTime(2026, 3, 1),
      endDate: DateTime(2026, 3, 10),
      totalBudget: 250000,
      dailyBudget: 1500,
    ),
  ];

  /// Returns all trips
  static List<Trip> getTrips() {
    return List.unmodifiable(_trips);
  }

  /// Returns the active trip (first trip in the list)
  static Trip? getActiveTrip() {
    return _trips.isNotEmpty ? _trips.first : null;
  }

  /// Returns all previous trips (all trips except the first)
  static List<Trip> getPreviousTrips() {
    return _trips.length > 1 ? List.unmodifiable(_trips.sublist(1)) : [];
  }

  /// Adds a new trip to the list
  static void addTrip(Trip trip) {
    _trips.add(trip);
  }

  /// Updates an existing trip by ID
  static void updateTrip(String id, Trip updatedTrip) {
    final index = _trips.indexWhere((trip) => trip.id == id);
    if (index != -1) {
      _trips[index] = updatedTrip;
    }
  }

  /// Deletes a trip by ID
  static void deleteTrip(String id) {
    _trips.removeWhere((trip) => trip.id == id);
  }

  // ==================== ENTRY DATA MANAGEMENT ====================

  /// Creates a dummy entry with the given parameters
  static Entry createDummyEntry({
    required String id,
    required String categoryName,
    required double amount,
    required DateTime date,
    String? notes,
    String? groupId,
    DateTime? endDate,
  }) {
    final category = AppConstants.categories.firstWhere(
      (c) => c['name'] == categoryName,
      orElse: () => AppConstants.categories.first,
    );

    return Entry(
      id: id,
      amount: amount,
      currency: 'INR',
      exchangeRate: 1.7,
      category: category,
      date: date,
      endDate: endDate,
      notes: notes,
      paymentMode: 'Cash',
      groupId: groupId,
    );
  }

  /// Returns a list of dummy entries for testing
  static List<Entry> getDummyEntries() {
    return [
      createDummyEntry(
        id: '1',
        categoryName: 'Flight',
        amount: 12500,
        date: DateTime.now(),
        notes: 'Tokyo Flight',
      ),
      createDummyEntry(
        id: '2',
        categoryName: 'Accomodation',
        amount: 8000,
        date: DateTime.now(),
        notes: 'Shinjuku Hotel',
      ),
      createDummyEntry(
        id: '3',
        categoryName: 'Restaurant',
        amount: 2500,
        date: DateTime.now().subtract(const Duration(days: 1)),
        notes: 'Dinner at Senso-ji',
      ),
      createDummyEntry(
        id: '4',
        categoryName: 'Transportation',
        amount: 1200,
        date: DateTime.now().subtract(const Duration(days: 1)),
        notes: 'Taxi to Airport',
      ),
      createDummyEntry(
        id: '5',
        categoryName: 'Shopping',
        amount: 3000,
        date: DateTime.now().subtract(const Duration(days: 2)),
        notes: 'Souvenirs',
      ),
      createDummyEntry(
        id: '6',
        categoryName: 'Shopping',
        amount: 3000,
        date: DateTime.now().subtract(const Duration(days: 2)),
        notes: 'Souvenirs',
      ),
      createDummyEntry(
        id: '7',
        categoryName: 'Shopping',
        amount: 3000,
        date: DateTime.now().subtract(const Duration(days: 2)),
        notes: 'Souvenirs',
      ),
    ];
  }
}
