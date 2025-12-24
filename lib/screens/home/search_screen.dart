import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:triptrack/providers/search_providers.dart';
import 'package:triptrack/theme/app_colors.dart';
import 'package:triptrack/screens/entry/add_expense_screen.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredEntries = ref.watch(filteredEntriesProvider);
    final categories = ref.watch(categoriesProvider);
    final countries = ref.watch(countriesProvider);
    final paymentModes = ref.watch(paymentModesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedCountry = ref.watch(selectedCountryProvider);
    final selectedPaymentMode = ref.watch(selectedPaymentModeProvider);
    final dateRange = ref.watch(selectedDateRangeProvider);

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
            decoration: InputDecoration(
              hintText: 'Search entries...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: ref.watch(searchQueryProvider).isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        ref.read(searchQueryProvider.notifier).state = '';
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        // Filters section
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // Category filter
                _FilterChip(
                  label: 'Category',
                  value: selectedCategory,
                  options: categories,
                  onChanged: (value) {
                    ref.read(selectedCategoryProvider.notifier).state = value;
                  },
                ),
                const SizedBox(width: 8),
                // Location filter
                _FilterChip(
                  label: 'Location',
                  value: selectedCountry,
                  options: countries,
                  onChanged: (value) {
                    ref.read(selectedCountryProvider.notifier).state = value;
                  },
                ),
                const SizedBox(width: 8),
                // Payment mode filter
                _FilterChip(
                  label: 'Payment',
                  value: selectedPaymentMode,
                  options: paymentModes,
                  onChanged: (value) {
                    ref.read(selectedPaymentModeProvider.notifier).state =
                        value;
                  },
                ),
                const SizedBox(width: 8),
                // Date range filter
                _DateRangeFilterChip(
                  startDate: dateRange.$1,
                  endDate: dateRange.$2,
                  onChanged: (start, end) {
                    ref.read(selectedDateRangeProvider.notifier).state = (
                      start,
                      end,
                    );
                  },
                ),
                const SizedBox(width: 8),
                // Clear filters button
                if (selectedCategory != null ||
                    selectedCountry != null ||
                    selectedPaymentMode != null ||
                    dateRange.$1 != null ||
                    dateRange.$2 != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ActionChip(
                      label: const Text('Clear All'),
                      avatar: const Icon(Icons.clear, size: 18),
                      backgroundColor: Colors.red.shade100,
                      labelStyle: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      onPressed: () {
                        ref.read(clearFiltersProvider)();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Results
        Expanded(
          child: filteredEntries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No results found',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Try adjusting your search or filters',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredEntries.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey.shade200,
                    height: 16,
                    thickness: 1,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _SearchResultCard(entry: filteredEntries[index]),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> options;
  final Function(String?) onChanged;

  const _FilterChip({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String?>(
      initialValue: value,
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(value: null, child: Text('Clear $label')),
          const PopupMenuDivider(),
          ...options.map((option) {
            return PopupMenuItem(value: option, child: Text(option));
          }),
        ];
      },
      onSelected: onChanged,
      child: Chip(
        label: Text('$label${value != null ? ': $value' : ''}'),
        onDeleted: value != null ? () => onChanged(null) : null,
        backgroundColor: value != null
            ? AppColors.primary.withOpacity(0.2)
            : AppColors.lightGrey.withOpacity(0.5),
        labelStyle: TextStyle(
          color: value != null ? AppColors.primary : AppColors.text,
          fontWeight: value != null ? FontWeight.w600 : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _DateRangeFilterChip extends ConsumerWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?, DateTime?) onChanged;

  const _DateRangeFilterChip({
    required this.startDate,
    required this.endDate,
    required this.onChanged,
  });

  void _showDatePickerMenu(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();

    // Current month
    final currentMonthStart = DateTime(now.year, now.month, 1);
    final currentMonthEnd = DateTime(now.year, now.month + 1, 0);

    // Previous month
    final prevMonthStart = DateTime(now.year, now.month - 1, 1);
    final prevMonthEnd = DateTime(now.year, now.month, 0);

    showMenu<String?>(
      context: context,
      position: RelativeRect.fromLTRB(100, 185, 0, 0),
      items: <PopupMenuEntry<String>>[
        const PopupMenuItem(value: 'custom', child: Text('Custom Date Range')),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'this_month',
          child: Text('This Month (${DateFormat('MMM').format(now)})'),
        ),
        PopupMenuItem(
          value: 'prev_month',
          child: Text(
            'Previous Month (${DateFormat('MMM').format(DateTime(now.year, now.month - 1))})',
          ),
        ),
        const PopupMenuItem(value: 'clear', child: Text('Clear')),
      ],
    ).then((value) async {
      if (value == 'custom') {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(now.year, now.month + 2, 0),
          initialDateRange: startDate != null && endDate != null
              ? DateTimeRange(start: startDate!, end: endDate!)
              : null,
        );
        if (picked != null) {
          onChanged(picked.start, picked.end);
        }
      } else if (value == 'this_month') {
        onChanged(currentMonthStart, currentMonthEnd);
      } else if (value == 'prev_month') {
        onChanged(prevMonthStart, prevMonthEnd);
      } else if (value == 'clear') {
        onChanged(null, null);
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showDatePickerMenu(context, ref),
      child: Chip(
        label: Text(
          startDate != null && endDate != null
              ? '${DateFormat('MMM d').format(startDate!)} - ${DateFormat('MMM d').format(endDate!)}'
              : 'Date Range',
          style: const TextStyle(fontSize: 12),
        ),
        onDeleted: startDate != null || endDate != null
            ? () => onChanged(null, null)
            : null,
        backgroundColor: startDate != null || endDate != null
            ? AppColors.primary.withOpacity(0.2)
            : AppColors.lightGrey.withOpacity(0.5),
        labelStyle: TextStyle(
          color: startDate != null || endDate != null
              ? AppColors.primary
              : AppColors.text,
          fontWeight: startDate != null || endDate != null
              ? FontWeight.w600
              : FontWeight.normal,
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final entry;

  const _SearchResultCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final categoryColor = entry.category['color'] as Color?;
    final categoryIcon = entry.category['icon'] as IconData?;
    final categoryName = entry.category['name'] ?? 'Unknown';

    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AddExpenseScreen(category: entry.category, entryToEdit: entry),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: categoryColor?.withOpacity(0.1) ?? Colors.grey.shade200,
              ),
              child: Icon(
                categoryIcon ?? Icons.category,
                color: categoryColor ?? Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (entry.notes == null || entry.notes!.isEmpty)
                        ? categoryName
                        : entry.notes!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (entry.notes == null || entry.notes!.isEmpty)
                        ? ''
                        : categoryName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('MMM d, yyyy').format(entry.date),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${entry.currency} ${entry.amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: categoryColor ?? Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.paymentMode,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Colors.grey.shade500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
