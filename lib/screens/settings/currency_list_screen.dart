import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:triptrack/theme/app_constants.dart';

class CurrencyListScreen extends StatefulWidget {
  static const String routeName = '/currency-list';

  const CurrencyListScreen({super.key});

  @override
  State<CurrencyListScreen> createState() => _CurrencyListScreenState();
}

class _CurrencyListScreenState extends State<CurrencyListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredCurrencies = [];

  @override
  void initState() {
    super.initState();
    _filteredCurrencies = AppConstants.currencyLocaleMap.keys.toList();
    _searchController.addListener(_filterCurrencies);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCurrencies);
    _searchController.dispose();
    super.dispose();
  }

  void _filterCurrencies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCurrencies = AppConstants.currencyLocaleMap.keys.toList().where((
        code,
      ) {
        final format = NumberFormat.simpleCurrency(name: code);
        // Note: currencyName is usually the code (e.g. USD) in standard intl
        final name = format.currencyName?.toLowerCase() ?? '';
        final symbol = format.currencySymbol.toLowerCase();

        return code.toLowerCase().contains(query) ||
            name.contains(query) ||
            symbol.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme
            .scaffoldBackgroundColor, // Use scaffold background for consistency
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
        leading: const BackButton(),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search currency...',
              prefixIcon: Icon(
                Icons.search,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 10,
              ),
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
      ),
      body: _filteredCurrencies.isEmpty
          ? Center(
              child: Text(
                'No currencies found.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            )
          : ListView.separated(
              itemCount: _filteredCurrencies.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: Colors.grey[200]),
              itemBuilder: (context, index) {
                final code = _filteredCurrencies[index];
                final format = NumberFormat.simpleCurrency(name: code);

                return Material(
                  color: theme
                      .cardColor, // Use card color for list tile background
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop(code);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width:
                                50.0, // Expanded width for potentially longer symbols
                            child: Text(
                              format.currencySymbol,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              format.currencyName ?? code,
                              style: TextStyle(
                                fontSize: 16,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Text(
                            code,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.7,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
