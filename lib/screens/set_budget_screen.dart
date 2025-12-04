import 'package:flutter/material.dart';
import 'package:triptrack/screens/summary_screen.dart';
import 'package:triptrack/theme/app_constants.dart';

class SetBudgetScreen extends StatefulWidget {
  final String name;
  final String homeCurrency;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? imagePath;

  const SetBudgetScreen({
    super.key,
    required this.name,
    required this.homeCurrency,
    this.startDate,
    this.endDate,
    this.imagePath,
  });

  @override
  _SetBudgetScreenState createState() => _SetBudgetScreenState();
}

class _SetBudgetScreenState extends State<SetBudgetScreen> {
  final TextEditingController _totalBudgetController = TextEditingController();
  final TextEditingController _dailyBudgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _totalBudgetController.addListener(_calculateDailyBudget);
  }

  @override
  void dispose() {
    _totalBudgetController.removeListener(_calculateDailyBudget);
    _totalBudgetController.dispose();
    _dailyBudgetController.dispose();
    super.dispose();
  }

  void _calculateDailyBudget() {
    final totalBudget = double.tryParse(_totalBudgetController.text);
    if (totalBudget != null &&
        widget.startDate != null &&
        widget.endDate != null) {
      final difference =
          widget.endDate!.difference(widget.startDate!).inDays + 1;
      if (difference > 0) {
        final dailyBudget = totalBudget / difference;
        _dailyBudgetController.text = dailyBudget.toStringAsFixed(2);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencySymbol =
        AppConstants.currencyData[widget.homeCurrency]?['symbol'] ?? '';
    final bool showDailyBudget = widget.startDate != null;

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
                'Set Your Budget',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'How much are you planning to spend on this trip?',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              TextField(
                controller: _totalBudgetController,
                decoration: InputDecoration(
                  labelText: 'Total Budget',
                  prefixText: '$currencySymbol ',
                  filled: true,
                  fillColor: theme.colorScheme.onSurface.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              if (showDailyBudget) ...[
                const SizedBox(height: 20),
                TextField(
                  controller: _dailyBudgetController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Daily Budget (Auto-calculated)',
                    prefixText: '$currencySymbol ',
                    filled: true,
                    fillColor: theme.colorScheme.onSurface.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        showDailyBudget
                            ? 'Enter your total budget, and the daily budget will be calculated for you (Total Budget / number of days).'
                            : 'You can set a total budget for your trip.',
                        style: TextStyle(color: Colors.blue[900], fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SummaryScreen(
                        name: widget.name,
                        homeCurrency: widget.homeCurrency,
                        startDate: widget.startDate,
                        endDate: widget.endDate,
                        totalBudget:
                            double.tryParse(_totalBudgetController.text) ?? 0.0,
                        dailyBudget:
                            double.tryParse(_dailyBudgetController.text) ?? 0.0,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Continue', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SummaryScreen(
                        name: widget.name,
                        homeCurrency: widget.homeCurrency,
                        startDate: widget.startDate,
                        endDate: widget.endDate,
                        totalBudget: 0.0,
                        dailyBudget: 0.0,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
