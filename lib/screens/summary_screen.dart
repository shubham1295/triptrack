import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:triptrack/theme/app_constants.dart';

class SummaryScreen extends StatelessWidget {
  final String name;
  final String homeCurrency;
  final DateTime? startDate;
  final DateTime? endDate;
  final double totalBudget;
  final double dailyBudget;

  const SummaryScreen({
    super.key,
    required this.name,
    required this.homeCurrency,
    this.startDate,
    this.endDate,
    required this.totalBudget,
    required this.dailyBudget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencySymbol =
        AppConstants.currencyData[homeCurrency]?['symbol'] ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Trip Summary',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Here are the details of your trip.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSummaryItem('Trip Name:', name),
                      const Divider(),
                      _buildSummaryItem(
                          'Home Currency:', '$homeCurrency ($currencySymbol)'),
                      if (startDate != null && endDate != null) ...[
                        const Divider(),
                        _buildSummaryItem('Date Range:',
                            '${DateFormat('dd/MMM/yyyy').format(startDate!)} - ${DateFormat('dd/MMM/yyyy').format(endDate!)}'),
                      ],
                      if (totalBudget > 0) ...[
                        const Divider(),
                        _buildSummaryItem(
                            'Total Budget:', totalBudget.toStringAsFixed(2)),
                      ],
                      if (dailyBudget > 0) ...[
                        const Divider(),
                        _buildSummaryItem(
                            'Daily Budget:', dailyBudget.toStringAsFixed(2)),
                      ],
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Finish', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
