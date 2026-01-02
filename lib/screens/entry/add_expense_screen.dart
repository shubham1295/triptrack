import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:function_tree/function_tree.dart';
import 'package:triptrack/widgets/calculator_keyboard.dart';

import 'package:triptrack/screens/entry/pick_category_screen.dart';
import 'package:triptrack/theme/app_constants.dart';
import 'package:triptrack/models/entry.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddExpenseScreen extends StatefulWidget {
  final Category category;
  final Entry? entryToEdit;

  const AddExpenseScreen({super.key, required this.category, this.entryToEdit});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  late Category _currentCategory;

  String _selectedCurrency = 'USD';
  final double _exchangeRate = 1.0;

  DateTime _selectedDate = DateTime.now();
  DateTimeRange? _selectedDateRange;
  bool _spendAcrossDays = false;

  bool _isAdvancedExpanded = false;
  bool _excludeFromMetrics = false;
  bool _isRefund = false;
  bool _showCalculatorKeyboard = false;

  late FocusNode _amountFocusNode;

  final List<Map<String, dynamic>> _paymentModes = [
    {'name': 'Cash', 'icon': Icons.attach_money},
    {'name': 'Credit Card', 'icon': Icons.credit_card},
    {'name': 'Debit Card', 'icon': Icons.credit_card},
  ];

  late Map<String, dynamic> _selectedPaymentMode;

  @override
  void initState() {
    super.initState();
    _currentCategory = widget.category;
    _selectedPaymentMode = _paymentModes.first;

    _amountFocusNode = FocusNode();
    _amountFocusNode.addListener(_handleFocusChange);

    // Pre-fill fields if editing an existing entry
    if (widget.entryToEdit != null) {
      final entry = widget.entryToEdit!;

      // Check if this was a multi-day entry
      if (entry.endDate != null && entry.groupId != null) {
        _spendAcrossDays = true;

        // Calculate the actual start date of the group
        // Entry IDs are in format: "groupId_index" where index is 0, 1, 2, etc.
        DateTime startDate = entry.date;

        // Try to extract the index from the entry ID
        // final idParts = entry.id.split('_');
        // if (idParts.length == 2) {
        //   final index = int.tryParse(idParts[1]);
        //   if (index != null) {
        //     // Calculate start date by subtracting the index
        //     startDate = entry.date.subtract(Duration(days: index));
        //   }
        // }

        _selectedDateRange = DateTimeRange(
          start: startDate,
          end: entry.endDate!,
        );

        // Calculate total amount from daily amount and number of days
        final totalDays = _selectedDateRange!.duration.inDays + 1;
        final totalAmount = entry.amount * totalDays;
        _amountController.text = totalAmount.toString();
      } else {
        // Single day entry
        _amountController.text = entry.amount.toString();
        _selectedDate = entry.date;
      }

      _notesController.text = entry.notes ?? '';
      _currentCategory = entry.category ?? Category();
      _selectedCurrency = entry.currency;

      // Find and set the payment mode
      final paymentMode = _paymentModes.firstWhere(
        (mode) => mode['name'] == entry.paymentMode,
        orElse: () => _paymentModes.first,
      );
      _selectedPaymentMode = paymentMode;

      // Set advanced options
      _excludeFromMetrics = entry.isExcludedFromMetrics;
      _isRefund = entry.isRefund;
    } else {
      _loadPreferences();
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final savedCurrency = prefs.getString('last_used_currency');
    if (savedCurrency != null) {
      setState(() {
        _selectedCurrency = savedCurrency;
      });
    }

    final savedPaymentMode = prefs.getString('last_payment_mode');
    if (savedPaymentMode != null) {
      final mode = _paymentModes.firstWhere(
        (m) => m['name'] == savedPaymentMode,
        orElse: () => _paymentModes.first,
      );
      setState(() {
        _selectedPaymentMode = mode;
      });
    }
  }

  void _handleFocusChange() {
    if (_amountFocusNode.hasFocus) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      setState(() {
        _showCalculatorKeyboard = true;
      });
    } else {
      setState(() {
        _showCalculatorKeyboard = false;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _amountFocusNode.removeListener(_handleFocusChange);
    _amountFocusNode.dispose();

    super.dispose();
  }

  double _evaluateExpression(String expression) {
    if (expression.isEmpty) return 0.0;
    // Handle "x" as "*"
    String cleanExp = expression.replaceAll('x', '*');

    if (double.tryParse(cleanExp) != null) {
      return double.parse(cleanExp);
    }
    try {
      if (cleanExp.endsWith('+') ||
          cleanExp.endsWith('-') ||
          cleanExp.endsWith('*') ||
          cleanExp.endsWith('/') ||
          cleanExp.endsWith('.')) {
        cleanExp = cleanExp.substring(0, cleanExp.length - 1);
      }
      return cleanExp.interpret().toDouble();
    } catch (e) {
      return 0.0;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange:
          _selectedDateRange ??
          DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 1)),
          ),
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _showCurrencyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredCurrencies = AppConstants.currencyLocaleMap.keys
                .where((code) {
                  final format = NumberFormat.simpleCurrency(name: code);
                  final name = format.currencyName?.toLowerCase() ?? '';
                  final symbol = format.currencySymbol.toLowerCase();
                  final query = searchQuery.toLowerCase();
                  return code.toLowerCase().contains(query) ||
                      name.contains(query) ||
                      symbol.contains(query);
                })
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Currency',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) {
                        setModalState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search currency...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHigh,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredCurrencies.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final code = filteredCurrencies[index];
                          final format = NumberFormat.simpleCurrency(
                            name: code,
                          );
                          final isSelected = _selectedCurrency == code;

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHigh,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onSurface,
                              child: Text(
                                format.currencySymbol,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              code,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check_circle_rounded,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  )
                                : null,
                            onTap: () {
                              setState(() {
                                _selectedCurrency = code;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showPaymentModePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Mode',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (_paymentModes.length > 1)
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 14,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Long press to delete',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _paymentModes.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _paymentModes.length) {
                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.add_rounded),
                            ),
                            title: Text(
                              'Add Custom Mode',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              _showAddCustomModeDialog(context, setModalState);
                            },
                          );
                        }
                        final mode = _paymentModes[index];
                        final isSelected =
                            _selectedPaymentMode['name'] == mode['name'];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHigh,
                            child: Icon(
                              mode['icon'] as IconData,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          title: Text(
                            mode['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : null,
                          onLongPress: () {
                            if (_paymentModes.length > 1) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Payment Mode'),
                                  content: Text('Delete "${mode['name']}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setModalState(() {
                                          _paymentModes.removeAt(index);
                                          if (isSelected) {
                                            _selectedPaymentMode =
                                                _paymentModes.first;
                                          }
                                        });
                                        setState(() {});
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          onTap: () {
                            setState(() {
                              _selectedPaymentMode = mode;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddCustomModeDialog(
    BuildContext context,
    StateSetter setModalState,
  ) {
    final TextEditingController customModeController = TextEditingController();
    IconData selectedIcon = Icons.payment;
    final List<IconData> availableIcons = [
      Icons.attach_money,
      Icons.credit_card,
      Icons.account_balance_wallet,
      Icons.phone_android,
      Icons.account_balance,
      Icons.shopping_bag,
      Icons.qr_code,
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Add Custom Mode'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: customModeController,
                  decoration: const InputDecoration(
                    hintText: 'Enter payment mode name',
                    filled: true,
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                const Text('Select Icon'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: availableIcons.map((icon) {
                    final isSelected = selectedIcon == icon;
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = icon;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHigh,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          size: 20,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  if (customModeController.text.isNotEmpty) {
                    final newMode = {
                      'name': customModeController.text,
                      'icon': selectedIcon,
                    };
                    setModalState(() {
                      _paymentModes.add(newMode);
                      _selectedPaymentMode = newMode;
                    });
                    setState(() {
                      _selectedPaymentMode = newMode;
                    });
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Close bottom sheet
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: theme.colorScheme.onError),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: theme.colorScheme.onError),
              ),
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoryColor = Color(_currentCategory.color ?? Colors.blue.value);
    final categoryIcon = IconData(
      _currentCategory.icon ?? Icons.category.codePoint,
      fontFamily: Icons.category.fontFamily,
      fontPackage: Icons.category.fontPackage,
    );
    final categoryName = _currentCategory.name ?? 'General';

    return PopScope(
      canPop: !_showCalculatorKeyboard,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_showCalculatorKeyboard) {
          setState(() {
            _showCalculatorKeyboard = false;
          });
          _amountFocusNode.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close_rounded, color: colorScheme.onSurface),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.entryToEdit != null ? 'Edit Expense' : categoryName,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          centerTitle: true,
          actions: widget.entryToEdit != null
              ? [
                  IconButton(
                    icon: Icon(Icons.delete_outline_rounded, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Expense'),
                          content: Text(
                            widget.entryToEdit!.groupId != null
                                ? 'This will delete all entries in this multi-day expense. Are you sure?'
                                : 'Are you sure you want to delete this expense?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx); // Close dialog
                                // Return delete action with groupId if it exists
                                Navigator.of(context).pop({
                                  'action': 'delete',
                                  'groupId': widget.entryToEdit!.groupId,
                                  'entryId': widget.entryToEdit!.id,
                                });
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ]
              : null,
        ),
        body: GestureDetector(
          onTap: () {
            // Close calculator keyboard if open
            if (_showCalculatorKeyboard || _amountFocusNode.hasFocus) {
              _amountFocusNode.unfocus();
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Header: Icon + Amount + Currency
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PickCategoryScreen(
                                        isSelecting: true,
                                      ),
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  _currentCategory = result;
                                });
                              }
                            },
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: categoryColor.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                categoryIcon,
                                size: 32,
                                color: categoryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              focusNode: _amountFocusNode,
                              readOnly: true, // Disable system keyboard
                              showCursor: true,
                              // keyboardType: const TextInputType.numberWithOptions(
                              //   decimal: true,
                              // ), // Removed as we use custom keyboard
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                              decoration: InputDecoration(
                                hintText: '0',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: colorScheme.onSurfaceVariant
                                      .withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () => _showCurrencyPicker(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.outlineVariant.withOpacity(
                                0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  NumberFormat.simpleCurrency(
                                    name: _selectedCurrency,
                                  ).currencySymbol,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _selectedCurrency,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '1 $_selectedCurrency = $_exchangeRate USD', // Placeholder
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Date & Spend Across Days
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        title: Text(
                          'Spend Across Days',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        value: _spendAcrossDays,
                        activeThumbColor: categoryColor,
                        onChanged: (val) {
                          setState(() {
                            _spendAcrossDays = val;
                          });
                        },
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      InkWell(
                        onTap: () {
                          if (_spendAcrossDays) {
                            _selectDateRange(context);
                          } else {
                            _selectDate(context);
                          }
                        },
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                color: categoryColor,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                _spendAcrossDays
                                    ? _selectedDateRange == null
                                          ? 'Select Date Range'
                                          : '${DateFormat('MMM dd').format(_selectedDateRange!.start)} - ${DateFormat('MMM dd, yyyy').format(_selectedDateRange!.end)}'
                                    : DateFormat(
                                        'EEEE, MMM dd, yyyy',
                                      ).format(_selectedDate),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Payment & Details
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => _showPaymentModePicker(context),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _selectedPaymentMode['icon'] as IconData,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Text(
                                  'Payment Mode',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                _selectedPaymentMode['name'].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.description_rounded,
                            color: Colors.orange,
                            size: 20,
                          ),
                        ),
                        title: TextField(
                          controller: _notesController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            hintText: 'Add notes...',
                            border: InputBorder.none,
                          ),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Extras
                Row(
                  children: [
                    Expanded(
                      child: _buildExtraButton(
                        context,
                        icon: Icons.place_rounded,
                        label: 'Location',
                        color: Colors.redAccent,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildExtraButton(
                        context,
                        icon: Icons.camera_alt_rounded,
                        label: 'Photo',
                        color: Colors.teal,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Advanced Options
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text(
                      'Advanced Options',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    initiallyExpanded: _isAdvancedExpanded,
                    onExpansionChanged: (val) =>
                        setState(() => _isAdvancedExpanded = val),
                    children: [
                      CheckboxListTile(
                        title: const Text('Exclude from daily metrics'),
                        activeColor: categoryColor,
                        value: _excludeFromMetrics,
                        onChanged: (val) =>
                            setState(() => _excludeFromMetrics = val ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      CheckboxListTile(
                        title: const Text('Refund payment'),
                        activeColor: categoryColor,
                        value: _isRefund,
                        onChanged: (val) =>
                            setState(() => _isRefund = val ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      final amountText = _amountController.text;
                      if (amountText.isEmpty) {
                        _showErrorSnackBar('Please enter an amount');
                        return;
                      }

                      // Save the selected currency and payment mode as preference
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setString(
                          'last_used_currency',
                          _selectedCurrency,
                        );
                        prefs.setString(
                          'last_payment_mode',
                          _selectedPaymentMode['name'],
                        );
                      });

                      final calculatedAmount = _evaluateExpression(amountText);
                      if (calculatedAmount <= 0.0 && amountText != '0') {
                        _showErrorSnackBar('Invalid expression or amount');
                        return;
                      }

                      if (_spendAcrossDays) {
                        if (_selectedDateRange == null) {
                          _showErrorSnackBar('Please select a date range');
                          return;
                        }

                        final int totalDays =
                            _selectedDateRange!.duration.inDays + 1;
                        if (totalDays > 0) {
                          final double dailyAmount =
                              calculatedAmount / totalDays;
                          final List<Entry> entries = [];
                          final String groupId = DateTime.now()
                              .millisecondsSinceEpoch
                              .toString();

                          for (int i = 0; i < totalDays; i++) {
                            final date = _selectedDateRange!.start.add(
                              Duration(days: i),
                            );
                            entries.add(
                              Entry(
                                // id will be auto-generated by Isar
                                amount: dailyAmount,
                                currency: _selectedCurrency,
                                exchangeRate: _exchangeRate,
                                category: _currentCategory,
                                date: date,
                                endDate: _selectedDateRange!
                                    .end, // Store the end date
                                notes: _notesController.text,
                                paymentMode: _selectedPaymentMode['name'],
                                isExcludedFromMetrics: _excludeFromMetrics,
                                isRefund: _isRefund,
                                groupId:
                                    groupId, // Link all entries with same groupId
                              ),
                            );
                          }

                          // If editing, return info to delete old entries
                          if (widget.entryToEdit != null) {
                            Navigator.of(context).pop({
                              'action': 'update',
                              'oldGroupId': widget.entryToEdit!.groupId,
                              'oldEntryId': widget.entryToEdit!.id,
                              'entries': entries,
                            });
                          } else {
                            Navigator.of(context).pop(entries);
                          }
                          return;
                        }
                      }

                      final newEntry = Entry(
                        // id will be auto-generated by Isar if not provided, or use existing if editing
                        id: widget.entryToEdit != null
                            ? widget.entryToEdit!.id
                            : Isar.autoIncrement,
                        amount: calculatedAmount,
                        currency: _selectedCurrency,
                        exchangeRate: _exchangeRate,
                        category: _currentCategory,
                        date: _selectedDate,
                        notes: _notesController.text,
                        paymentMode: _selectedPaymentMode['name'],
                        isExcludedFromMetrics: _excludeFromMetrics,
                        isRefund: _isRefund,
                      );

                      // If editing a grouped entry that's now single-day, delete old group
                      if (widget.entryToEdit != null &&
                          widget.entryToEdit!.groupId != null) {
                        Navigator.of(context).pop({
                          'action': 'update',
                          'oldGroupId': widget.entryToEdit!.groupId,
                          'entry': newEntry,
                        });
                      } else {
                        Navigator.of(context).pop(newEntry);
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: categoryColor,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                      shadowColor: categoryColor.withOpacity(0.4),
                    ),
                    child: Text(
                      widget.entryToEdit != null
                          ? 'Update Expense'
                          : 'Save Expense',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        bottomSheet: _showCalculatorKeyboard
            ? Container(
                color: theme.scaffoldBackgroundColor,
                child: Builder(
                  builder: (context) {
                    final originalColor = Color(
                      _currentCategory.color ?? Colors.blue.value,
                    );
                    final darkerColor = HSLColor.fromColor(originalColor)
                        .withLightness(
                          (HSLColor.fromColor(originalColor).lightness - 0.1)
                              .clamp(0.0, 1.0),
                        )
                        .toColor();
                    return CalculatorKeyboard(
                      controller: _amountController,
                      accentColor: darkerColor,
                      onDone: () {
                        _amountFocusNode.unfocus();
                      },
                    );
                  },
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildExtraButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
