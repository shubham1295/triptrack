import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triptrack/models/trip.dart';
import 'package:triptrack/providers/trip_provider.dart';

class SummaryScreen extends ConsumerWidget {
  final String name;
  final String homeCurrency;
  final DateTime? startDate;
  final DateTime? endDate;
  final double totalBudget;
  final double dailyBudget;
  final String? imagePath;

  const SummaryScreen({
    super.key,
    required this.name,
    required this.homeCurrency,
    this.startDate,
    this.endDate,
    required this.totalBudget,
    required this.dailyBudget,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currencySymbol = NumberFormat.simpleCurrency(
      name: homeCurrency,
    ).currencySymbol;

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
                onPressed: () async {
                  final tripsAsync = ref.read(tripProvider);
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);

                  bool alreadyHasActive = false;
                  tripsAsync.whenData((trips) {
                    alreadyHasActive = trips.any(
                      (trip) =>
                          trip.endDate != null &&
                          !trip.endDate!.isBefore(today),
                    );
                  });

                  if (alreadyHasActive) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: theme.colorScheme.error,
                            ),
                            const SizedBox(width: 10),
                            const Text('Active Trip Detected'),
                          ],
                        ),
                        content: const Text(
                          'You currently have an ongoing trip active. To maintain accurate tracking, please ensure your previous trip has ended before starting a new one.',
                          style: TextStyle(fontSize: 15),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(
                              'Got it',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  final newTrip = Trip(
                    name: name,
                    homeCurrency: homeCurrency,
                    startDate: startDate,
                    endDate: endDate,
                    totalBudget: totalBudget,
                    dailyBudget: dailyBudget,
                    imagePath: imagePath,
                    lastModified: DateTime.now(),
                  );
                  await ref.read(tripProvider.notifier).addTrip(newTrip);
                  if (context.mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
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
