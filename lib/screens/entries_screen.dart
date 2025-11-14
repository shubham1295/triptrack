import 'package:flutter/material.dart';
import 'package:triptrack/models/entry.dart';
import 'package:triptrack/widgets/entry_item.dart';
import 'package:triptrack/widgets/summary_card.dart';

class EntriesScreen extends StatefulWidget {
  const EntriesScreen({super.key});

  @override
  State<EntriesScreen> createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
  final List<Entry> _entries = const [
    Entry(
      imagePath: 'assets/images/google_logo.png',
      name: 'Flight Ticket',
      description: 'Tokyo Flight',
      amount: 'Rs 12,500',
      convertedAmount: '¥ 21,250',
    ),
    Entry(
      imagePath: 'assets/images/google_logo.png',
      name: 'Hotel Booking',
      description: 'Shinjuku Hotel',
      amount: 'Rs 8,000',
      convertedAmount: '¥ 13,600',
    ),
    Entry(
      imagePath: 'assets/images/google_logo.png',
      name: 'Restaurant',
      description: 'Dinner at Senso-ji',
      amount: 'Rs 2,500',
      convertedAmount: '¥ 4,250',
    ),
    Entry(
      imagePath: 'assets/images/google_logo.png',
      name: 'Transport',
      description: 'Taxi to Airport',
      amount: 'Rs 1,200',
      convertedAmount: '¥ 2,040',
    ),
    Entry(
      imagePath: 'assets/images/google_logo.png',
      name: 'Shopping',
      description: 'Souvenirs',
      amount: 'Rs 3,000',
      convertedAmount: '¥ 5,100',
    ),
    Entry(
      imagePath: 'assets/images/google_logo.png',
      name: 'Shopping',
      description: 'Souvenirs',
      amount: 'Rs 3,000',
      convertedAmount: '¥ 5,100',
    ),
    Entry(
      imagePath: 'assets/images/google_logo.png',
      name: 'Shopping',
      description: 'Souvenirs',
      amount: 'Rs 3,000',
      convertedAmount: '¥ 5,100',
    ),
  ];

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
        const Divider(indent: 16.0, endIndent: 16.0, color: Colors.grey),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 0, bottom: 96),
            itemCount: _entries.length,
            itemBuilder: (BuildContext context, int index) {
              final entry = _entries[index];
              return EntryItem(
                imagePath: entry.imagePath,
                name: entry.name,
                description: entry.description,
                amount: entry.amount,
                convertedAmount: entry.convertedAmount,
              );
            },
          ),
        ),
      ],
    );
  }
}
