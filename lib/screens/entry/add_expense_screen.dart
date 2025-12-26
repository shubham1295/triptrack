import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:function_tree/function_tree.dart';
import 'package:triptrack/widgets/calculator_keyboard.dart';
import 'package:triptrack/screens/entry/pick_category_screen.dart';
import 'package:triptrack/models/entry.dart';
import 'package:triptrack/theme/app_constants.dart';
import 'package:isar/isar.dart';

class AddExpenseScreen extends StatefulWidget {
  final Category? category;
  final Entry? entryToEdit;

  const AddExpenseScreen({super.key, this.category, this.entryToEdit});

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

    // Fallback category (General)
    final defaultCatMap = AppConstants.categories.first;
    final defaultCategory = Category(
      name: defaultCatMap['name'] as String?,
      icon: (defaultCatMap['icon'] as IconData).codePoint,
      color: (defaultCatMap['color'] as Color).value,
    );

    _currentCategory =
        widget.category ?? (widget.entryToEdit?.category ?? defaultCategory);
    _selectedPaymentMode = _paymentModes.first;

    _amountFocusNode = FocusNode();
    _amountFocusNode.addListener(_handleFocusChange);

    // Pre-fill fields if editing an existing entry
    if (widget.entryToEdit != null) {
      final entry = widget.entryToEdit!;
      _currentCategory = entry.category ?? _currentCategory;
      _selectedCurrency = entry.currency;
      _notesController.text = entry.notes ?? '';
      _excludeFromMetrics = entry.isExcludedFromMetrics;
      _isRefund = entry.isRefund;

      if (entry.endDate != null && entry.groupId != null) {
        _spendAcrossDays = true;
        _selectedDateRange = DateTimeRange(
          start: entry.date,
          end: entry.endDate!,
        );
        final totalDays = _selectedDateRange!.duration.inDays + 1;
        _amountController.text = (entry.amount * totalDays).toString();
      } else {
        _selectedDate = entry.date;
        _amountController.text = entry.amount.toString();
      }

      final paymentMode = _paymentModes.firstWhere(
        (mode) => mode['name'] == entry.paymentMode,
        orElse: () => _paymentModes.first,
      );
      _selectedPaymentMode = paymentMode;
    }
  }

  void _handleFocusChange() {
    if (_amountFocusNode.hasFocus) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _showCalculator(context);
    }
  }

  void _showCalculator(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      barrierColor: Colors.transparent,
      enableDrag: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext ctx) {
        final categoryColor = Color(
          _currentCategory.color ?? Colors.blue.value,
        );
        final darkerColor = HSLColor.fromColor(categoryColor)
            .withLightness(
              (HSLColor.fromColor(categoryColor).lightness - 0.1).clamp(
                0.0,
                1.0,
              ),
            )
            .toColor();
        return CalculatorKeyboard(
          controller: _amountController,
          accentColor: darkerColor,
          onDone: () {
            Navigator.pop(ctx);
          },
        );
      },
    ).whenComplete(() {
      _amountFocusNode.unfocus();
    });
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.entryToEdit != null ? 'Edit Expense' : 'Add Expense',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Header
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const PickCategoryScreen(isSelecting: true),
                      ),
                    );
                    if (result is Category) {
                      setState(() {
                        _currentCategory = result;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(categoryIcon, color: categoryColor, size: 28),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Tap icon to change',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Amount and Currency
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  _selectedCurrency,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    focusNode: _amountFocusNode,
                    readOnly: true,
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: categoryColor,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Notes
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                hintText: 'Add notes...',
                prefixIcon: const Icon(Icons.notes),
                filled: true,
                fillColor: colorScheme.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 24),
            // Date Selection
            SwitchListTile(
              title: const Text('Spend Across Days'),
              value: _spendAcrossDays,
              onChanged: (val) => setState(() => _spendAcrossDays = val),
              secondary: const Icon(Icons.date_range),
              contentPadding: EdgeInsets.zero,
            ),
            if (_spendAcrossDays)
              ListTile(
                title: Text(
                  _selectedDateRange == null
                      ? 'Select Date Range'
                      : '${DateFormat('MMM d').format(_selectedDateRange!.start)} - ${DateFormat('MMM d').format(_selectedDateRange!.end)}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _selectDateRange(context),
                contentPadding: EdgeInsets.zero,
              )
            else
              ListTile(
                title: Text(
                  DateFormat('EEEE, MMMM d, y').format(_selectedDate),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
                contentPadding: EdgeInsets.zero,
              ),
            const SizedBox(height: 24),
            // Payment Mode
            Text(
              'Payment Mode',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _paymentModes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final mode = _paymentModes[index];
                  final isSelected =
                      _selectedPaymentMode['name'] == mode['name'];
                  return ChoiceChip(
                    label: Text(mode['name']),
                    avatar: Icon(
                      mode['icon'],
                      size: 18,
                      color: isSelected ? Colors.white : null,
                    ),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedPaymentMode = mode);
                    },
                    selectedColor: categoryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            // Advanced Options
            Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
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
                      final double dailyAmount = calculatedAmount / totalDays;
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
                            amount: dailyAmount,
                            currency: _selectedCurrency,
                            exchangeRate: _exchangeRate,
                            category: _currentCategory,
                            date: date,
                            endDate: _selectedDateRange!.end,
                            notes: _notesController.text,
                            paymentMode: _selectedPaymentMode['name'],
                            isExcludedFromMetrics: _excludeFromMetrics,
                            isRefund: _isRefund,
                            groupId: groupId,
                          ),
                        );
                      }
                      Navigator.of(context).pop(entries);
                      return;
                    }
                  }

                  final newEntry = Entry(
                    id: widget.entryToEdit?.id ?? Isar.autoIncrement,
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
                  Navigator.of(context).pop(newEntry);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: categoryColor,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  widget.entryToEdit != null
                      ? 'Update Expense'
                      : 'Save Expense',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
