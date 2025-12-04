import 'package:flutter/material.dart';
import 'package:triptrack/screens/set_budget_screen.dart';
import 'package:triptrack/theme/app_constants.dart';
import 'package:triptrack/screens/currency_list_screen.dart';

class CurrencySelectionScreen extends StatefulWidget {
  final String tripName;
  final String? imagePath;
  final DateTime? startDate;
  final DateTime? endDate;

  const CurrencySelectionScreen({
    super.key,
    required this.tripName,
    this.imagePath,
    this.startDate,
    this.endDate,
  });

  @override
  State<CurrencySelectionScreen> createState() =>
      _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState extends State<CurrencySelectionScreen> {
  String _selectedCurrency = 'USD'; // Set default to USD

  void _navigateToCurrencyList() async {
    final selectedCode = await Navigator.of(
      context,
    ).pushNamed(CurrencyListScreen.routeName);
    if (selectedCode != null && selectedCode is String) {
      setState(() {
        _selectedCurrency = selectedCode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedCurrencyData = AppConstants.currencyData[_selectedCurrency];

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
                'Select Your Home Currency',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'All amounts will automatically be converted to this currency.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              InkWell(
                onTap: _navigateToCurrencyList,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedCurrencyData != null
                            ? '${selectedCurrencyData['symbol']} ${selectedCurrencyData['name']} ($_selectedCurrency)'
                            : 'Select Currency',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
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
                        'This currency will be used as the base for all your trip expenses.',
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
                      builder: (context) => SetBudgetScreen(
                        name: widget.tripName,
                        homeCurrency: _selectedCurrency,
                        startDate: widget.startDate,
                        endDate: widget.endDate,
                        imagePath: widget.imagePath,
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
            ],
          ),
        ),
      ),
    );
  }
}
