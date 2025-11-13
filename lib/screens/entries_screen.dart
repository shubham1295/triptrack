import 'package:flutter/material.dart';

class EntriesScreen extends StatefulWidget {
  const EntriesScreen({super.key});

  @override
  State<EntriesScreen> createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
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

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required String amount,
    required String budget,
    required double progressValue,
  }) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showDetailOptionsSheet(context),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Center(
              child: Builder(
                builder: (context) {
                  final baseStyle = Theme.of(context).textTheme.bodyLarge;
                  return RichText(
                    text: TextSpan(
                      style: baseStyle,
                      children: <TextSpan>[
                        TextSpan(
                          text: amount,
                          style: baseStyle?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '.55',
                          style: baseStyle?.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: (baseStyle.fontSize ?? 24.0) * 0.75,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Text(
                budget,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 4.0,
                backgroundColor: Colors.grey,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ],
        ),
      ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    _buildSummaryCard(
                      context: context,
                      title: 'Total',
                      amount: 'Rs 19,000',
                      budget: '9000/2,00,000',
                      progressValue: 0.45,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    _buildSummaryCard(
                      context: context,
                      title: 'Today',
                      amount: 'Rs 5000',
                      budget: '9000/2,00,000',
                      progressValue: 0.45,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(indent: 16.0, endIndent: 16.0, color: Colors.grey),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: const [
              ListTile(
                title: Text('Entry 1'),
                subtitle: Text('Description goes here'),
              ),
              ListTile(
                title: Text('Entry 2'),
                subtitle: Text('Description goes here'),
              ),
              ListTile(
                title: Text('Entry 3'),
                subtitle: Text('Description goes here'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
