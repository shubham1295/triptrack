import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:triptrack/models/trip.dart';
import 'package:triptrack/theme/app_constants.dart';
import 'package:triptrack/screens/trip/currency_selection_screen.dart';

class EditTripScreen extends StatefulWidget {
  final Trip trip;

  const EditTripScreen({super.key, required this.trip});

  @override
  State<EditTripScreen> createState() => _EditTripScreenState();
}

class _EditTripScreenState extends State<EditTripScreen> {
  late TextEditingController _nameController;
  late String _homeCurrency;
  late DateTime? _startDate;
  late DateTime? _endDate;
  late TextEditingController _totalBudgetController;
  String? _imagePath;
  bool _nameError = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.trip.name);
    _homeCurrency = widget.trip.homeCurrency;
    _startDate = widget.trip.startDate;
    _endDate = widget.trip.endDate;
    _totalBudgetController = TextEditingController(
      text: widget.trip.totalBudget > 0
          ? widget.trip.totalBudget.toStringAsFixed(0)
          : '',
    );
    _imagePath = widget.trip.imagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _totalBudgetController.dispose();
    super.dispose();
  }

  void _addPhoto() {
    // TODO: Implement image picking logic
    print('Add photo tapped');
  }

  // Calculate daily budget based on total budget and date range
  double _calculateDailyBudget() {
    if (_startDate == null || _endDate == null) return 0;
    final totalBudget = double.tryParse(_totalBudgetController.text) ?? 0;
    if (totalBudget <= 0) return 0;

    final days = _endDate!.difference(_startDate!).inDays + 1;
    return totalBudget / days;
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _clearDates() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
  }

  void _clearBudget() {
    setState(() {
      _totalBudgetController.clear();
    });
  }

  void _selectCurrency() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CurrencySelectionScreen(
          tripName: _nameController.text,
          imagePath: _imagePath,
          startDate: _startDate,
          endDate: _endDate,
          isEditMode: true,
          currentCurrency: _homeCurrency,
        ),
      ),
    );

    if (result != null && result is String) {
      setState(() {
        _homeCurrency = result;
      });
    }
  }

  void _saveTrip() {
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _nameError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a trip name'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Calculate daily budget
    final dailyBudget = _calculateDailyBudget();

    // TODO: Save trip to database/storage
    final updatedTrip = widget.trip.copyWith(
      name: _nameController.text.trim(),
      imagePath: _imagePath,
      homeCurrency: _homeCurrency,
      startDate: _startDate,
      endDate: _endDate,
      totalBudget: double.tryParse(_totalBudgetController.text) ?? 0,
      dailyBudget: dailyBudget,
    );

    Navigator.pop(context, updatedTrip);
  }

  void _deleteTrip() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: const Text(
          'Are you sure you want to delete this trip? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Delete trip from database/storage
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, 'deleted'); // Return to previous screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Trip deleted'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _getSummaryText() {
    final currencySymbol =
        AppConstants.currencyData[_homeCurrency]?['symbol'] ?? '';
    final parts = <String>[];

    parts.add(
      'Trip to ${_nameController.text.isNotEmpty ? _nameController.text : "your destination"}',
    );

    if (_startDate != null && _endDate != null) {
      final days = _endDate!.difference(_startDate!).inDays + 1;
      parts.add(
        'from ${DateFormat('dd MMM yyyy').format(_startDate!)} to ${DateFormat('dd MMM yyyy').format(_endDate!)} ($days days)',
      );
    }

    final totalBudget = double.tryParse(_totalBudgetController.text) ?? 0;
    final dailyBudget = _calculateDailyBudget();

    if (totalBudget > 0) {
      parts.add(
        'with a total budget of $currencySymbol${totalBudget.toStringAsFixed(0)}',
      );
    }

    if (dailyBudget > 0) {
      parts.add(
        'and a daily budget of $currencySymbol${dailyBudget.toStringAsFixed(0)}',
      );
    }

    parts.add('using $_homeCurrency as your home currency.');

    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencySymbol =
        AppConstants.currencyData[_homeCurrency]?['symbol'] ?? '';
    final dailyBudget = _calculateDailyBudget();

    return GestureDetector(
      onTap: () {
        // Unfocus text fields when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: theme.colorScheme.onSurface,
          leading: const BackButton(),
          title: Text(
            'Edit Trip Details',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Photo Section - Reduced size with upload button
                      Stack(
                        children: [
                          InkWell(
                            onTap: _addPhoto,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.05,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: theme.colorScheme.outline.withOpacity(
                                    0.3,
                                  ),
                                  width: 1.5,
                                ),
                              ),
                              child: _imagePath != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        _imagePath!,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo_outlined,
                                          size: 20,
                                          color: theme.colorScheme.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Tap to Add Cover Photo',
                                          style: TextStyle(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          // Circular upload button overlay
                          if (_imagePath != null)
                            Positioned(
                              right: 8,
                              bottom: 8,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _addPhoto,
                                  borderRadius: BorderRadius.circular(24),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.shadow
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Trip Name
                      TextField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (value) {
                          if (_nameError) {
                            setState(() {
                              _nameError = false;
                            });
                          }
                          setState(() {}); // Update summary
                        },
                        decoration: InputDecoration(
                          labelText: 'Trip Name *',
                          hintText: 'e.g., "Summer in Japan"',
                          errorText: _nameError
                              ? 'Trip name is required'
                              : null,
                          prefixIcon: const Icon(
                            Icons.flight_takeoff,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.onSurface.withOpacity(
                            0.05,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Home Currency
                      InkWell(
                        onTap: _selectCurrency,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withOpacity(
                              0.05,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.attach_money,
                                size: 20,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Home Currency',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '$_homeCurrency ($currencySymbol)',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Travel Dates
                      InkWell(
                        onTap: _selectDateRange,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withOpacity(
                              0.05,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                size: 20,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Travel Dates',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _startDate != null && _endDate != null
                                          ? '${DateFormat('dd MMM yyyy').format(_startDate!)} - ${DateFormat('dd MMM yyyy').format(_endDate!)}'
                                          : 'Not set',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: _startDate == null
                                                ? theme
                                                      .colorScheme
                                                      .onSurfaceVariant
                                                : null,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_startDate != null && _endDate != null)
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    size: 18,
                                    color: theme.colorScheme.error,
                                  ),
                                  onPressed: _clearDates,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                )
                              else
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Total Budget
                      TextField(
                        controller: _totalBudgetController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: 'Total Budget',
                          hintText: '0',
                          prefixIcon: const Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 20,
                          ),
                          prefixText: '$currencySymbol ',
                          suffixIcon: _totalBudgetController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    size: 18,
                                    color: theme.colorScheme.error,
                                  ),
                                  onPressed: _clearBudget,
                                )
                              : null,
                          filled: true,
                          fillColor: theme.colorScheme.onSurface.withOpacity(
                            0.05,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Daily Budget (Auto-calculated, read-only)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.outline.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Daily Budget (Auto-calculated)',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    dailyBudget > 0
                                        ? '$currencySymbol${dailyBudget.toStringAsFixed(0)}'
                                        : 'Set dates and budget',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: dailyBudget > 0
                                          ? theme.colorScheme.onSurface
                                          : theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.lock_outline,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Summary Info - Compact
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withOpacity(
                            0.3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: theme.colorScheme.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _getSummaryText(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Delete Button - Compact
                      OutlinedButton.icon(
                        onPressed: _deleteTrip,
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: const Text('Delete Trip'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.error,
                          side: BorderSide(color: theme.colorScheme.error),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Save Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveTrip,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
