import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/entry.dart';
import '../../widgets/entry_item.dart';
import '../../widgets/summary_card.dart';
import '../../data/temp_data.dart';
import '../../providers/trip_provider.dart';

class EntriesScreen extends StatefulWidget {
  static const routeName = '/entries';
  const EntriesScreen({super.key});

  @override
  State<EntriesScreen> createState() => EntriesScreenState();
}

class EntriesScreenState extends State<EntriesScreen> {
  late final List<Entry> _entries;

  @override
  void initState() {
    super.initState();
    _initEntries();
    _groupEntriesByDate();
  }

  void addEntry(Entry entry) {
    setState(() {
      _entries.insert(0, entry);
      _groupEntriesByDate();
    });
  }

  void addEntries(List<Entry> newEntries) {
    setState(() {
      _entries.insertAll(0, newEntries);
      _groupEntriesByDate();
    });
  }

  void updateEntry(Entry updatedEntry) {
    setState(() {
      final index = _entries.indexWhere((e) => e.id == updatedEntry.id);
      if (index != -1) {
        // Update existing entry
        _entries[index] = updatedEntry;
      } else {
        // Add new entry (happens when editing grouped entries)
        _entries.insert(0, updatedEntry);
      }
      _groupEntriesByDate();
    });
  }

  void deleteEntry(String identifier) {
    setState(() {
      // Check if identifier is a groupId or entryId
      // If any entry has this as groupId, delete all with same groupId
      final hasGroupId = _entries.any((e) => e.groupId == identifier);

      if (hasGroupId) {
        // Delete all entries with this groupId
        _entries.removeWhere((e) => e.groupId == identifier);
      } else {
        // Delete single entry by ID - parse identifier to int as Entry.id is Id (int)
        final id = int.tryParse(identifier);
        if (id != null) {
          _entries.removeWhere((e) => e.id == id);
        }
      }

      _groupEntriesByDate();
    });
  }

  void _initEntries() {
    // We must create a mutable list because TempData.getDummyEntries() returns an unmodifiable list
    _entries = List.from(TempData.getDummyEntries());
  }

  Map<DateTime, List<Entry>> _groupedEntries = {};
  final Map<DateTime, double> _dailyTotals = {};

  void _groupEntriesByDate() {
    _groupedEntries.clear();
    _dailyTotals.clear();

    for (var entry in _entries) {
      // Normalize date to remove time component for grouping
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);

      _groupedEntries.putIfAbsent(date, () => []).add(entry);
      _dailyTotals.update(
        date,
        (value) => value + entry.amount,
        ifAbsent: () => entry.amount,
      );
    }

    // Sort dates in descending order
    _groupedEntries = Map.fromEntries(
      _groupedEntries.entries.toList()
        ..sort((e1, e2) => e2.key.compareTo(e1.key)),
    );
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
                          // Add logic to handle selection if needed
                          // Navigator.pop(context); // Optional: close on select
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

    return Consumer(
      builder: (context, ref, child) {
        final activeTripAsync = ref.watch(currentActiveTripProvider);

        return activeTripAsync.when(
          data: (activeTrip) {
            final totalSpent = _entries.fold(0.0, (sum, e) => sum + e.amount);
            final today = DateTime.now();
            final todaySpent = _entries
                .where(
                  (e) =>
                      e.date.year == today.year &&
                      e.date.month == today.month &&
                      e.date.day == today.day,
                )
                .fold(0.0, (sum, e) => sum + e.amount);

            final totalBudget = activeTrip?.totalBudget ?? 0.0;
            final dailyBudget = activeTrip?.dailyBudget ?? 0.0;
            final currency = activeTrip?.homeCurrency ?? 'INR';

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
                          amount: '$currency ${totalSpent.toStringAsFixed(0)}',
                          budget:
                              '${totalSpent.toStringAsFixed(0)}/${totalBudget.toStringAsFixed(0)}',
                          progressValue: totalProgress,
                          onMoreTap: () => _showDetailOptionsSheet(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          title: 'Today',
                          amount: '$currency ${todaySpent.toStringAsFixed(0)}',
                          budget:
                              '${todaySpent.toStringAsFixed(0)}/${dailyBudget.toStringAsFixed(0)}',
                          progressValue: todayProgress,
                          onMoreTap: () => _showDetailOptionsSheet(context),
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
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8, bottom: 96),
                    itemCount: _groupedEntries.keys.length,
                    itemBuilder: (BuildContext context, int index) {
                      final date = _groupedEntries.keys.elementAt(index);
                      final entriesForDate = _groupedEntries[date]!;
                      final totalAmount = _dailyTotals[date]!;

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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 6.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? colorScheme.surfaceContainerHighest
                                        : colorScheme.primary.withValues(
                                            alpha: 0.1,
                                          ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Text(
                                    DateFormat('EEEE, MMM d').format(date),
                                    style: textTheme.titleMedium?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Text(
                                  '$currency ${totalAmount.toStringAsFixed(2)}',
                                  style: textTheme.titleMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...entriesForDate.asMap().entries.map((mapEntry) {
                            final entryIndex = mapEntry.key;
                            final entry = mapEntry.value;
                            final isLastItem =
                                entryIndex == entriesForDate.length - 1;
                            return EntryItem(
                              entry: entry,
                              isLastItem: isLastItem,
                              onEntryUpdated: updateEntry,
                              onEntryDeleted: deleteEntry,
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
    );
  }
}
