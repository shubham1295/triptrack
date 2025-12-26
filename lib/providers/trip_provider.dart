import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trip.dart';
import '../services/isar_service.dart';

class TripNotifier extends AsyncNotifier<List<Trip>> {
  @override
  Future<List<Trip>> build() async {
    final isarService = ref.read(isarServiceProvider);
    return isarService.getAllTrips();
  }

  Future<void> addTrip(Trip trip) async {
    state = const AsyncLoading();
    final isarService = ref.read(isarServiceProvider);
    state = await AsyncValue.guard(() async {
      await isarService.saveTrip(trip);
      return isarService.getAllTrips();
    });
  }

  Future<void> deleteTrip(int id) async {
    state = const AsyncLoading();
    final isarService = ref.read(isarServiceProvider);
    state = await AsyncValue.guard(() async {
      await isarService.deleteTrip(id);
      return isarService.getAllTrips();
    });
  }

  Future<void> refreshTrips() async {
    state = const AsyncLoading();
    final isarService = ref.read(isarServiceProvider);
    state = await AsyncValue.guard(() async {
      return isarService.getAllTrips();
    });
  }
}

final tripProvider = AsyncNotifierProvider<TripNotifier, List<Trip>>(() {
  return TripNotifier();
});

/// Provider for the single latest trip shown in the "Active Trip" section of the drawer.
final currentActiveTripProvider = Provider<AsyncValue<Trip?>>((ref) {
  final tripsAsync = ref.watch(tripProvider);
  return tripsAsync.whenData((trips) {
    if (trips.isEmpty) return null;
    // Return the latest trip by ID (Isar auto-increment)
    final sortedTrips = List<Trip>.from(trips)
      ..sort((a, b) => b.id.compareTo(a.id));
    return sortedTrips.first;
  });
});

/// Provider for all trips except the latest one, shown in the "Previous Trips" section.
final previousTripsProvider = Provider<AsyncValue<List<Trip>>>((ref) {
  final tripsAsync = ref.watch(tripProvider);
  final currentActiveAsync = ref.watch(currentActiveTripProvider);

  return tripsAsync.whenData((trips) {
    final currentActive = currentActiveAsync.asData?.value;
    if (currentActive == null) return [];

    return trips.where((trip) => trip.id != currentActive.id).toList()
      ..sort((a, b) => b.id.compareTo(a.id));
  });
});
