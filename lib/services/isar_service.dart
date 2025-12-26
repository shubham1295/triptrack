import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trip.dart';
import '../models/entry.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [TripSchema, EntrySchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> saveTrip(Trip trip) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.trips.put(trip);
    });
  }

  Future<List<Trip>> getAllTrips() async {
    final isar = await db;
    return await isar.trips.where().findAll();
  }

  Future<void> deleteTrip(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.trips.delete(id);
    });
  }

  Future<Trip?> getTrip(int id) async {
    final isar = await db;
    return await isar.trips.get(id);
  }

  // --- Entry Methods ---

  Future<void> saveEntry(Entry entry) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.entrys.put(entry);
    });
  }

  Future<void> saveEntries(List<Entry> entries) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.entrys.putAll(entries);
    });
  }

  Future<List<Entry>> getAllEntries() async {
    final isar = await db;
    return await isar.entrys.where().findAll();
  }

  Future<List<Entry>> getEntriesByGroupId(String groupId) async {
    final isar = await db;
    return await isar.entrys.filter().groupIdEqualTo(groupId).findAll();
  }

  Future<void> deleteEntry(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.entrys.delete(id);
    });
  }
}

final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService();
});
