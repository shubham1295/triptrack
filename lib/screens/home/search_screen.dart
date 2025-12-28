import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:triptrack/providers/search_providers.dart';
import 'package:triptrack/theme/app_colors.dart';
import 'package:triptrack/screens/entry/add_expense_screen.dart';
import 'package:triptrack/models/entry.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch search results and available options
    final filteredEntries = ref.watch(searchResultsProvider);
    final categories = ref.watch(availableCategoriesProvider);
    final countries = ref.watch(availableCountriesProvider);
    final paymentModes = ref.watch(availablePaymentModesProvider);

    // Watch current filter state for values
    final filters = ref.watch(searchFiltersProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // backgroundColor: colorScheme.surface, // Removed to match StatsScreen (use default)
      body: SafeArea(
        child: Column(
          children: [
            // Header with Back Button
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Search Entries',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  ref.read(searchFiltersProvider.notifier).setQuery(value);
                },
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Search by notes, location...',
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  prefixIcon: Icon(
                    Icons.search,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: filters.query.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          onPressed: () {
                            ref
                                .read(searchFiltersProvider.notifier)
                                .setQuery('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: colorScheme
                      .surfaceContainerHighest, // Match Stats dropdown background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      20,
                    ), // Match Stats dropdown radius
                    borderSide: BorderSide(
                      color: colorScheme.outline.withOpacity(
                        0.2,
                      ), // Match Stats dropdown border
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),

            // Filters List
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Category Filter
                  _FilterChip(
                    label: 'Category',
                    value: filters.category,
                    options: categories,
                    onChanged: (value) {
                      ref
                          .read(searchFiltersProvider.notifier)
                          .setCategory(value);
                    },
                  ),
                  const SizedBox(width: 8),

                  // Location Filter
                  _FilterChip(
                    label: 'Location',
                    value: filters.country,
                    options: countries,
                    onChanged: (value) {
                      ref
                          .read(searchFiltersProvider.notifier)
                          .setCountry(value);
                    },
                  ),
                  const SizedBox(width: 8),

                  // Payment Mode Filter
                  _FilterChip(
                    label: 'Payment',
                    value: filters.paymentMode,
                    options: paymentModes,
                    onChanged: (value) {
                      ref
                          .read(searchFiltersProvider.notifier)
                          .setPaymentMode(value);
                    },
                  ),
                  const SizedBox(width: 8),

                  // Date Range Filter
                  _DateRangeFilterChip(
                    startDate: filters.startDate,
                    endDate: filters.endDate,
                    onChanged: (start, end) {
                      ref
                          .read(searchFiltersProvider.notifier)
                          .setDateRange(start, end);
                    },
                  ),
                  const SizedBox(width: 8),

                  // Clear All Button
                  if (filters.hasFilters)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: TextButton.icon(
                        onPressed: () {
                          ref.read(searchFiltersProvider.notifier).clearAll();
                        },
                        icon: Icon(
                          Icons.refresh,
                          size: 16,
                          color: colorScheme.error,
                        ),
                        label: Text(
                          'Reset',
                          style: TextStyle(color: colorScheme.error),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.error,
                          textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 5), // Increased spacing
            // Results List
            Expanded(
              child: filteredEntries.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No matches found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting filters or search terms',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(
                        16,
                      ), // Restore padding for card list
                      itemCount: filteredEntries.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _SearchResultCard(entry: filteredEntries[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Logic from StatsScreen _buildDropdown
    final textColor = isDark ? Colors.white : Colors.black;
    final backgroundColor = colorScheme.surfaceContainerHighest;
    final borderColor = colorScheme.outline.withOpacity(0.2);

    final isActive = value != null;

    return PopupMenuButton<String?>(
      initialValue: value,
      padding: EdgeInsets.zero,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorScheme.surfaceContainer,
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: null,
            child: Row(
              children: [
                Icon(
                  Icons.clear,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'All ${label}s',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(),
          ...options.map((option) {
            final isSelected = option == value;
            return PopupMenuItem(
              value: option,
              child: Row(
                children: [
                  if (isSelected)
                    Icon(Icons.check, size: 18, color: colorScheme.primary)
                  else
                    const SizedBox(width: 18),
                  const SizedBox(width: 8),
                  Text(
                    option,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }),
        ];
      },
      onSelected: onChanged,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ), // Matching Stats Screen height roughly
        decoration: BoxDecoration(
          color: isActive ? colorScheme.primary : backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? colorScheme.primary : borderColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isActive ? value! : label,
              style: TextStyle(
                color: isActive ? colorScheme.onPrimary : textColor,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20, // Stats screen uses 20
              color: isActive ? colorScheme.onPrimary : textColor,
            ),
          ],
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final currentMonthStart = DateTime(now.year, now.month, 1);
    final currentMonthEnd = DateTime(now.year, now.month + 1, 0);

    final prevMonthStart = DateTime(now.year, now.month - 1, 1);
    final prevMonthEnd = DateTime(now.year, now.month, 0);

    showMenu<String?>(
      context: context,
      position: RelativeRect.fromLTRB(100, 185, 0, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorScheme.surfaceContainer,
      items: <PopupMenuEntry<String>>[
        PopupMenuItem(
          value: 'custom',
          child: Text(
            'Custom Range...',
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'this_month',
          child: Text(
            'This Month (${DateFormat('MMM').format(now)})',
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ),
        PopupMenuItem(
          value: 'prev_month',
          child: Text(
            'Last Month (${DateFormat('MMM').format(DateTime(now.year, now.month - 1))})',
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ),
        PopupMenuItem(
          value: 'clear',
          child: Text(
            'Clear Date Filter',
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ),
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
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(primary: AppColors.primary),
                // Note: keeping AppColors.primary hardcoded as per date picker requirement or use colorScheme.primary
              ),
              child: child!,
            );
          },
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
    final isActive = startDate != null;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Logic from StatsScreen _buildDropdown
    final textColor = isDark ? Colors.white : Colors.black;
    final backgroundColor = colorScheme.surfaceContainerHighest;
    final borderColor = colorScheme.outline.withOpacity(0.2);

    return GestureDetector(
      onTap: () => _showDatePickerMenu(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? colorScheme.primary : backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? colorScheme.primary : borderColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today,
              size: 14,
              color: isActive ? colorScheme.onPrimary : textColor,
            ),
            const SizedBox(width: 6),
            Text(
              isActive && endDate != null
                  ? '${DateFormat('d/MMM').format(startDate!)} - ${DateFormat('d/MMM').format(endDate!)}'
                  : 'Date Range',
              style: TextStyle(
                color: isActive ? colorScheme.onPrimary : textColor,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: isActive ? colorScheme.onPrimary : textColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final Entry entry;

  const _SearchResultCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final categoryColor = entry.category?.color;
    final categoryIcon = entry.category?.icon;
    final categoryName = entry.category?.name ?? 'Unknown';

    final amountString = '${entry.amount.toStringAsFixed(0)}';

    // Converted amount logic (Yen)
    String? convertedAmountString;
    if (entry.exchangeRate != 1.0) {
      final converted = entry.amount * entry.exchangeRate;
      convertedAmountString = '~ ¥ ${converted.toStringAsFixed(0)}';
    }

    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AddExpenseScreen(category: entry.category!, entryToEdit: entry),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // Match StatsScreen _buildCategoryWiseSpendingList decoration perfectly
          color: theme.cardTheme.color ?? colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: colorScheme.outline.withOpacity(0.05)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment
              .center, // Center align for card items often looks better
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                // Use a slightly more opaque background for the icon container in cards
                color:
                    (categoryColor != null
                            ? Color(categoryColor)
                            : colorScheme.primary)
                        .withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                categoryIcon != null
                    ? IconData(
                        categoryIcon,
                        fontFamily: Icons.category.fontFamily,
                        fontPackage: Icons.category.fontPackage,
                      )
                    : Icons.category,
                color: categoryColor != null
                    ? Color(categoryColor)
                    : colorScheme.primary,
                // Stats screen: color: (categoryColor...).withOpacity(0.5) (bg), Icon color: Colors.white
                // Let's stick to EntryItem style here as it's cleaner for the icon itself,
                // BUT user said match Stats styling.
                // Stats styling:
                // decoration: BoxDecoration(color: ...withOpacity(0.5), shape: BoxShape.circle),
                // child: Icon(..., color: Colors.white, size: 20)
                // Let's adopt the Shape: BoxShape.circle at least.
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (entry.notes?.isNotEmpty == true)
                        ? entry.notes!
                        : categoryName,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      fontSize: 15, // Stats uses 15
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (entry.location != null &&
                          entry.location!.isNotEmpty) ...[
                        Text(
                          entry.location!,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: colorScheme.onSurfaceVariant.withOpacity(
                              0.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        DateFormat('d MMM yyyy').format(entry.date),
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amountString,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    fontSize: 15, // Stats uses 15
                  ),
                ),
                if (convertedAmountString != null) ...[
                  Text(
                    convertedAmountString,
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                Text(
                  entry.paymentMode,
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
