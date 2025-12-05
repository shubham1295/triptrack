class Entry {
  final String id;
  final double amount;
  final String currency;
  final double exchangeRate;
  final Map<String, dynamic> category;
  final DateTime date;
  final DateTime? endDate;
  final String? notes;
  final String paymentMode;
  final String? location;
  final List<String>? photos;
  final bool isExcludedFromMetrics;
  final bool isRefund;

  Entry({
    required this.id,
    required this.amount,
    required this.currency,
    required this.exchangeRate,
    required this.category,
    required this.date,
    this.endDate,
    this.notes,
    required this.paymentMode,
    this.location,
    this.photos,
    this.isExcludedFromMetrics = false,
    this.isRefund = false,
  });
}
