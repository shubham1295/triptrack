import 'package:flutter/material.dart';
import 'package:triptrack/models/entry.dart';

import 'package:triptrack/screens/entry/add_expense_screen.dart';
import 'package:triptrack/utils/formatting_util.dart';

class EntryItem extends StatelessWidget {
  final Entry entry;
  final bool isLastItem;
  final Function(Entry)? onEntryUpdated;
  final Function(String)? onEntryDeleted;
  final String homeCurrency;

  const EntryItem({
    super.key,
    required this.entry,
    this.isLastItem = false,
    this.onEntryUpdated,
    this.onEntryDeleted,
    required this.homeCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final categoryName = entry.category?.name ?? 'General';
    final categoryIcon = IconData(
      entry.category?.icon ?? Icons.category.codePoint,
      fontFamily: Icons.category.fontFamily,
      fontPackage: Icons.category.fontPackage,
    );
    final categoryColor = Color(entry.category?.color ?? Colors.grey.value);

    final amountString = FormattingUtil.formatCurrency(
      entry.amount,
      homeCurrency,
    );

    // Show converted amount in home currency if exchange rate differs from 1.0
    String? convertedAmountString;
    if (entry.exchangeRate != 1.0) {
      final converted = entry.amount * entry.exchangeRate;
      convertedAmountString = FormattingUtil.formatCurrency(
        converted,
        entry.currency,
      );
    }

    return Column(
      children: [
        InkWell(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddExpenseScreen(
                  category: entry.category!,
                  entryToEdit: entry,
                ),
              ),
            );

            // Handle the result
            if (result is Map && result['action'] == 'delete') {
              // Entry was deleted - check if it's a grouped entry
              final groupId = result['groupId'] as String?;
              if (groupId != null) {
                // Delete all entries with this groupId
                onEntryDeleted?.call(groupId);
              } else {
                // Delete single entry
                onEntryDeleted?.call(result['entryId'] as String);
              }
            } else if (result is Map && result['action'] == 'update') {
              // Entry was updated - handle grouped entry updates
              final oldGroupId = result['oldGroupId'] as String?;
              final oldEntryId = result['oldEntryId'] as String?;

              // First delete old entries
              if (oldGroupId != null) {
                onEntryDeleted?.call(oldGroupId);
              } else if (oldEntryId != null) {
                onEntryDeleted?.call(oldEntryId);
              }

              // Then add new entries
              if (result['entries'] != null) {
                // Multiple entries (multi-day)
                final entries = result['entries'] as List<Entry>;
                for (final newEntry in entries) {
                  onEntryUpdated?.call(newEntry);
                }
              } else if (result['entry'] != null) {
                // Single entry
                onEntryUpdated?.call(result['entry'] as Entry);
              }
            } else if (result is Entry) {
              // Simple entry update (non-grouped)
              onEntryUpdated?.call(result);
            } else if (result is List<Entry>) {
              // Multiple new entries (creating multi-day)
              for (final newEntry in result) {
                onEntryUpdated?.call(newEntry);
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon/Image on the left
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: categoryColor.withValues(alpha: 0.1),
                  ),
                  child: Icon(categoryIcon, color: categoryColor, size: 24),
                ),
                const SizedBox(width: 12),
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
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Amount on the right
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      entry.isExcludedFromMetrics
                          ? '($amountString)'
                          : amountString,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: entry.isExcludedFromMetrics ? Colors.red : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (convertedAmountString != null)
                      Text(
                        convertedAmountString,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (!isLastItem)
          const Divider(
            indent: 16.0,
            endIndent: 16.0,
            color: Colors.grey,
            height: 1,
          ),
      ],
    );
  }
}
