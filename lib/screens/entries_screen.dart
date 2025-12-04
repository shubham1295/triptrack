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
  final Map<DateTime, double> _dailyTotals = {};

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
      showDragHandle: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final colorScheme = Theme.of(context).colorScheme;
            final textTheme = Theme.of(context).textTheme;

            return Container(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Select an Option',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...options.map((optionText) {
                    final isSelected = currentSelection == optionText;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12.0),
                        border: isSelected
                            ? Border.all(color: colorScheme.primary, width: 1)
                            : null,
                      ),
                      child: ListTile(
                        title: Text(
                          optionText,
                          style: textTheme.bodyLarge?.copyWith(
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: colorScheme.primary,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            currentSelection = optionText;
                          });
                          // Add logic to handle selection if needed
                          // Navigator.pop(context); // Optional: close on select
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 12.0),
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
              const SizedBox(width: 12),
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
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.surfaceContainerHighest
                : colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isDark
                  ? Colors.transparent
                  : colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Trip Ended',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 8, bottom: 96),
            itemCount: _groupedEntries.keys.length,
            itemBuilder: (BuildContext context, int index) {
              final date = _groupedEntries.keys.elementAt(index);
              final entriesForDate = _groupedEntries[date]!;
              final totalAmount = _dailyTotals[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6.0,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? colorScheme.surfaceContainerHighest
                                : colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            DateFormat('EEEE, MMM d').format(date),
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          'Rs ${totalAmount.toStringAsFixed(0)}',
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.normal,
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
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
