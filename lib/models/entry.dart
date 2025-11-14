class Entry {
  final String imagePath;
  final String name;
  final String description;
  final String amount;
  final String convertedAmount;
  final DateTime date;

  const Entry({
    required this.imagePath,
    required this.name,
    required this.description,
    required this.amount,
    required this.convertedAmount,
    required this.date,
  });
}
