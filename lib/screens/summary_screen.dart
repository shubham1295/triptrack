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
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
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
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSummaryItem('Trip Name', name, theme),
                    const Divider(height: 32),
                    _buildSummaryItem(
                      'Home Currency',
                      '$homeCurrency ($currencySymbol)',
                      theme,
                    ),
                    if (startDate != null && endDate != null) ...[
                      const Divider(height: 32),
                      _buildSummaryItem(
                        'Date Range',
                        '${DateFormat('dd MMM yyyy').format(startDate!)} - ${DateFormat('dd MMM yyyy').format(endDate!)}',
                        theme,
                      ),
                    ],
                    if (totalBudget > 0) ...[
                      const Divider(height: 32),
                      _buildSummaryItem(
                        'Total Budget',
                        '$currencySymbol${totalBudget.toStringAsFixed(2)}',
                        theme,
                      ),
                    ],
                    if (dailyBudget > 0) ...[
                      const Divider(height: 32),
                      _buildSummaryItem(
                        'Daily Budget',
                        '$currencySymbol${dailyBudget.toStringAsFixed(2)}',
                        theme,
                      ),
                    ],
                  ],
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

  Widget _buildSummaryItem(String title, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
