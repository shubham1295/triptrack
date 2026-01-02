import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/entry.dart';
import '../../widgets/entry_item.dart';
import '../../widgets/summary_card.dart';

import '../../providers/trip_provider.dart';
import '../../utils/formatting_util.dart';

import '../../services/isar_service.dart';

class EntriesScreen extends ConsumerStatefulWidget {
  static const routeName = '/entries';
  const EntriesScreen({super.key});

  @override
  ConsumerState<EntriesScreen> createState() => EntriesScreenState();
}

class EntriesScreenState extends ConsumerState<EntriesScreen> {
  // _entries is now derived from provider
  // grouping is done on the fly or memoized

  @override
  void initState() {
    super.initState();
  }

  // Helper to group entries
  Map<DateTime, List<Entry>> _groupEntriesByDate(List<Entry> entries) {
    final Map<DateTime, List<Entry>> groupedEntries = {};
    for (var entry in entries) {
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      groupedEntries.putIfAbsent(date, () => []).add(entry);
    }
    // Sort dates descending
    return Map.fromEntries(
      groupedEntries.entries.toList()
        ..sort((e1, e2) => e2.key.compareTo(e1.key)),
    );
  }

  // Calculate daily totals
  Map<DateTime, double> _calculateDailyTotals(List<Entry> entries) {
    final Map<DateTime, double> dailyTotals = {};
    for (var entry in entries) {
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      dailyTotals.update(
        date,
        (value) => value + entry.amount,
        ifAbsent: () => entry.amount,
      );
    }
    return dailyTotals;
  }

  void updateEntry(Entry updatedEntry) async {
    final isarService = ref.read(isarServiceProvider);
    // If it's an update, Isar's put matches by ID.
    // We need to ensure the ID is set.
    // Also need to handle if it's a new entry masquerading as update? Unlikely here.
    await isarService.saveEntry(updatedEntry);
    ref.invalidate(activeTripEntriesProvider);
    ref.invalidate(tripProvider); // To update totals in trip list if needed
  }

  void deleteEntry(String identifier) async {
    final isarService = ref.read(isarServiceProvider);
    // Logic for group deletion if needed
    // Currently IsarService.deleteEntry takes int id.
    // If identifier is string and might be groupId...

    final entries = ref.read(activeTripEntriesProvider).value ?? [];

    final hasGroupId = entries.any(
      (e) => e.groupId == identifier && e.groupId != null,
    );

    if (hasGroupId) {
      final entriesToDelete = entries
          .where((e) => e.groupId == identifier)
          .toList();
      for (final e in entriesToDelete) {
        await isarService.deleteEntry(e.id);
      }
    } else {
      final id = int.tryParse(identifier);
      if (id != null) {
        await isarService.deleteEntry(id);
      }
    }
    ref.invalidate(activeTripEntriesProvider);
    ref.invalidate(tripProvider);
  }

  void _showDetailOptionsSheet(BuildContext context) {
    const options = [
      'View Detailed Breakdown',
      'Change Date Range',
      'Export Data',
    ];

    String currentSelection = options[0];

    showModalBottomSheet(
      context: context,
      showDragHandle: false,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final colorScheme = Theme.of(context).colorScheme;
            final textTheme = Theme.of(context).textTheme;

            return Container(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Select an Option',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...options.map((optionText) {
                    final isSelected = currentSelection == optionText;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12.0),
                        border: isSelected
                            ? Border.all(color: colorScheme.primary, width: 1)
                            : null,
                      ),
                      child: ListTile(
                        title: Text(
                          optionText,
                          style: textTheme.bodyLarge?.copyWith(
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: colorScheme.primary,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            currentSelection = optionText;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeTripAsync = ref.watch(currentActiveTripProvider);
    final entriesAsync = ref.watch(activeTripEntriesProvider);

    return activeTripAsync.when(
      data: (activeTrip) {
        return entriesAsync.when(
          data: (entries) {
            final groupedEntries = _groupEntriesByDate(entries);
            final dailyTotals = _calculateDailyTotals(entries);

            final totalSpent = entries.fold(0.0, (sum, e) => sum + e.amount);
            final today = DateTime.now();
            final todaySpent = entries
                .where(
                  (e) =>
                      e.date.year == today.year &&
                      e.date.month == today.month &&
                      e.date.day == today.day,
                )
                .fold(0.0, (sum, e) => sum + e.amount);

            final totalBudget = activeTrip?.totalBudget ?? 0.0;
            final dailyBudget = activeTrip?.dailyBudget ?? 0.0;
            final totalProgress = totalBudget > 0
                ? (totalSpent / totalBudget).clamp(0.0, 1.0)
                : 0.0;
            final todayProgress = dailyBudget > 0
                ? (todaySpent / dailyBudget).clamp(0.0, 1.0)
                : 0.0;

            final isCurrentlyActive =
                activeTrip != null &&
                (activeTrip.endDate == null ||
                    activeTrip.endDate!.isAfter(today) ||
                    (activeTrip.endDate!.year == today.year &&
                        activeTrip.endDate!.month == today.month &&
                        activeTrip.endDate!.day == today.day));

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Total',
                          amount: totalSpent,
                          budget:
                              '${FormattingUtil.formatCurrency(totalSpent, activeTrip?.homeCurrency ?? 'USD')}/${FormattingUtil.formatCurrency(totalBudget, activeTrip?.homeCurrency ?? 'USD')}',
                          progressValue: totalProgress,
                          onMoreTap: () => _showDetailOptionsSheet(context),
                          currency: activeTrip?.homeCurrency ?? 'USD',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          title: 'Today',
                          amount: todaySpent,
                          budget:
                              '${FormattingUtil.formatCurrency(todaySpent, activeTrip?.homeCurrency ?? 'USD')}/${FormattingUtil.formatCurrency(dailyBudget, activeTrip?.homeCurrency ?? 'USD')}',
                          progressValue: todayProgress,
                          onMoreTap: () => _showDetailOptionsSheet(context),
                          currency: activeTrip?.homeCurrency ?? 'USD',
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isCurrentlyActive && activeTrip != null)
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? colorScheme.surfaceContainerHighest
                          : colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: isDark
                            ? Colors.transparent
                            : colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Trip Ended',
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: entries.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.receipt_long_rounded,
                                size: 64,
                                color: colorScheme.onSurfaceVariant.withOpacity(
                                  0.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No entries yet',
                                style: textTheme.titleLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap the + button to add an expense',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(top: 8, bottom: 96),
                          itemCount: groupedEntries.keys.length,
                          itemBuilder: (BuildContext context, int index) {
                            final date = groupedEntries.keys.elementAt(index);
                            final entriesForDate = groupedEntries[date]!;
                            final totalAmount = dailyTotals[date]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16.0,
                                    16.0,
                                    16.0,
                                    8.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                          vertical: 6.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? colorScheme
                                                    .surfaceContainerHighest
                                              : colorScheme.primary.withValues(
                                                  alpha: 0.1,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            20.0,
                                          ),
                                        ),
                                        child: Text(
                                          DateFormat(
                                            'EEEE, MMM d',
                                          ).format(date),
                                          style: textTheme.titleMedium
                                              ?.copyWith(
                                                color: colorScheme.primary,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        FormattingUtil.formatCurrency(
                                          totalAmount,
                                          activeTrip?.homeCurrency ?? 'USD',
                                        ),
                                        style: textTheme.titleMedium?.copyWith(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...entriesForDate.asMap().entries.map((
                                  mapEntry,
                                ) {
                                  final entryIndex = mapEntry.key;
                                  final entry = mapEntry.value;
                                  final isLastItem =
                                      entryIndex == entriesForDate.length - 1;
                                  return EntryItem(
                                    entry: entry,
                                    isLastItem: isLastItem,
                                    onEntryUpdated: updateEntry,
                                    onEntryDeleted: deleteEntry,
                                    homeCurrency:
                                        activeTrip?.homeCurrency ?? 'USD',
                                  );
                                }),
                              ],
                            );
                          },
                        ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
