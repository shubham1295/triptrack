import 'package:isar/isar.dart';

part 'entry.g.dart';

@Collection()
class Entry {
  Id id = Isar.autoIncrement;

  double amount = 0;
  String currency = 'USD';
  double exchangeRate = 1.0;

  Category? category;

  DateTime date = DateTime.now();
  DateTime? endDate;
  String? notes;
  String? location;
  String paymentMode = 'Cash';
  bool isExcludedFromMetrics = false;
  bool isRefund = false;
  String? groupId;
  bool isSynced = false;
  DateTime lastModified = DateTime.now();

  Entry({
    this.id = Isar.autoIncrement,
    this.amount = 0,
    this.currency = 'USD',
    this.exchangeRate = 1.0,
    this.category,
    required this.date,
    this.endDate,
    this.notes,
    this.location,
    this.paymentMode = 'Cash',
    this.isExcludedFromMetrics = false,
    this.isRefund = false,
    this.groupId,
    this.isSynced = false,
  });
}

@embedded
class Category {
  String? name;
  int? icon;
  int? color;

  Category({this.name, this.icon, this.color});
}
