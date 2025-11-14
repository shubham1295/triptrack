import 'package:flutter/material.dart';
import 'package:triptrack/models/entry.dart';
import 'package:triptrack/widgets/entry_item.dart';
import 'package:triptrack/widgets/summary_card.dart';
import 'package:intl/intl.dart';

class EntriesScreen extends StatefulWidget {
  const EntriesScreen({super.key});

  @override
  State<EntriesScreen> createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
  double _parseAmount(String amountString) {
    final cleanedAmount = amountString
        .replaceAll('Rs ', '')
        .replaceAll(',', '');
    return double.tryParse(cleanedAmount) ?? 0.0;
  }

  final List<Entry> _entries = [
    Entry(
      imagePath: 'assets/images/google_logo.png',
      name: 'Flight Ticket',
      description: 'Tokyo Flight',
      amount: 'Rs 12,500',
      convertedAmount: '¥ 21,250',
      date: DateTime.now(),
    ),
    Entry(
      imagePath: 'assets/images/google_logo.png',
      name: 'Hotel Booking',
      description: 'Shinjuku Hotel',
      amount: 'Rs 8,000',
      convertedAmount: '¥ 13,600',
      date: DateTime.now(),
    ),
    Entry(
      imagePath: 'assets/images/google_logo.png',
      name: 'Restaurant',
      description: 'Dinner at Senso-ji',
      amount: 'Rs 2,500',
      convertedAmount: '¥ 4,250',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Entry(
      imagePath: 'assets/images/google_logo.png',
      name: 'Transport',
      description: 'Taxi to Airport',
      amount: 'Rs 1,200',
      convertedAmount: '¥ 2,040',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Entry(
      imagePath: 'assets/images/google_logo.png',
      name: 'Shopping',
      description: 'Souvenirs',
      amount: 'Rs 3,000',
      convertedAmount: '¥ 5,100',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Entry(
      imagePath: 'assets/images/google_logo.png',
      name: 'Shopping',
      description: 'Souvenirs',
      amount: 'Rs 3,000',
      convertedAmount: '¥ 5,100',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Entry(
      imagePath: 'assets/images/google_logo.png',
      name: 'Shopping',
      description: 'Souvenirs',
      amount: 'Rs 3,000',
      convertedAmount: '¥ 5,100',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  Map<DateTime, List<Entry>> _groupedEntries = {};
  Map<DateTime, double> _dailyTotals = {};

  @override
  void initState() {
    super.initState();
    _groupEntriesByDate();
  }

  void _groupEntriesByDate() {
    _groupedEntries.clear();
    _dailyTotals.clear();

    for (var entry in _entries) {
      // Normalize date to remove time component for grouping
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);

      _groupedEntries.putIfAbsent(date, () => []).add(entry);
      _dailyTotals.update(
        date,
        (value) => value + _parseAmount(entry.amount),
        ifAbsent: () => _parseAmount(entry.amount),
      );
    }

    // Sort dates in descending order
    _groupedEntries = Map.fromEntries(
      _groupedEntries.entries.toList()
        ..sort((e1, e2) => e2.key.compareTo(e1.key)),
    );
  }

  void _showDetailOptionsSheet(BuildContext context) {
    const options = [
      'View Detailed Breakdown',
      'Change Date Range',
      'Export Data',
    ];

    String currentSelection = options[0];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Select an Option',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  ...options.map((optionText) {
                    final isSelected = currentSelection == optionText;

                    return ListTile(
                      title: Text(optionText),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        setState(() {
                          currentSelection = optionText;
                        });
                      },
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Total',
                  amount: 'Rs. 19,000',
                  budget: '9000/2,00,000',
                  progressValue: 0.45,
                  onMoreTap: () => _showDetailOptionsSheet(context),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SummaryCard(
                  title: 'Today',
                  amount: 'Rs. 5000',
                  budget: '9000/2,00,000',
                  progressValue: 0.45,
                  onMoreTap: () => _showDetailOptionsSheet(context),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8.0),
          ),
          // padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: Center(
            child: Text(
              'Trip Ended',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 0, bottom: 96),
            itemCount: _groupedEntries.keys.length,
            itemBuilder: (BuildContext context, int index) {
              final date = _groupedEntries.keys.elementAt(index);
              final entriesForDate = _groupedEntries[date]!;
              final totalAmount = _dailyTotals[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ), // Example radius
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('EEEE, MMM d, yyyy').format(date),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        Text(
                          'Rs ${totalAmount.toStringAsFixed(0)}', // Format as needed
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ),
                  ...entriesForDate.asMap().entries.map((mapEntry) {
                    final entryIndex = mapEntry.key;
                    final entry = mapEntry.value;
                    final isLastItem = entryIndex == entriesForDate.length - 1;
                    return EntryItem(
                      imagePath: entry.imagePath,
                      name: entry.name,
                      description: entry.description,
                      amount: entry.amount,
                      convertedAmount: entry.convertedAmount,
                      isLastItem: isLastItem,
                    );
                  }),
                  // const Divider(
                  //   indent: 16.0,
                  //   endIndent: 16.0,
                  // ), // Separator between dates
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
