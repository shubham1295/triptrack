import 'package:isar/isar.dart';
import 'entry.dart';

part 'trip.g.dart';

@collection
class Trip {
  Id id = Isar.autoIncrement;
  final String name;
  final String? imagePath;
  final String homeCurrency;
  final DateTime? startDate;
  final DateTime? endDate;
  final double totalBudget;
  final double dailyBudget;
  final bool isSynced;
  final DateTime lastModified;

  final expenses = IsarLinks<Entry>();

  Trip({
    this.id = Isar.autoIncrement,
    required this.name,
    this.imagePath,
    required this.homeCurrency,
    this.startDate,
    this.endDate,
    required this.totalBudget,
    required this.dailyBudget,
    this.isSynced = false,
    required this.lastModified,
  });

  Trip copyWith({
    Id? id,
    String? name,
    String? imagePath,
    String? homeCurrency,
    DateTime? startDate,
    DateTime? endDate,
    double? totalBudget,
    double? dailyBudget,
    bool? isSynced,
    DateTime? lastModified,
  }) {
    return Trip(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      homeCurrency: homeCurrency ?? this.homeCurrency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalBudget: totalBudget ?? this.totalBudget,
      dailyBudget: dailyBudget ?? this.dailyBudget,
      isSynced: isSynced ?? this.isSynced,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'homeCurrency': homeCurrency,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'totalBudget': totalBudget,
      'dailyBudget': dailyBudget,
      'isSynced': isSynced,
      'lastModified': lastModified.toIso8601String(),
    };
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as int? ?? Isar.autoIncrement,
      name: json['name'] as String,
      imagePath: json['imagePath'] as String?,
      homeCurrency: json['homeCurrency'] as String,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      totalBudget: (json['totalBudget'] as num).toDouble(),
      dailyBudget: (json['dailyBudget'] as num).toDouble(),
      isSynced: json['isSynced'] as bool? ?? false,
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'] as String)
          : DateTime.now(),
    );
  }
}
