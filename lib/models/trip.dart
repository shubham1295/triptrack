class Trip {
  final String id;
  final String name;
  final String? imagePath;
  final String homeCurrency;
  final DateTime? startDate;
  final DateTime? endDate;
  final double totalBudget;
  final double dailyBudget;

  Trip({
    required this.id,
    required this.name,
    this.imagePath,
    required this.homeCurrency,
    this.startDate,
    this.endDate,
    required this.totalBudget,
    required this.dailyBudget,
  });

  Trip copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? homeCurrency,
    DateTime? startDate,
    DateTime? endDate,
    double? totalBudget,
    double? dailyBudget,
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
    };
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
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
    );
  }
}
