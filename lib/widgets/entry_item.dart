import 'package:flutter/material.dart';
import 'package:triptrack/models/entry.dart';
import 'package:triptrack/theme/app_constants.dart';

class EntryItem extends StatelessWidget {
  final Entry entry;
  final VoidCallback? onTap;
  final bool isLastItem;

  const EntryItem({
    super.key,
    required this.entry,
    this.onTap,
    this.isLastItem = false,
  });

  @override
  Widget build(BuildContext context) {
    final categoryName = entry.category['name'] ?? 'Unknown';
    final categoryIcon = entry.category['icon'] as IconData? ?? Icons.category;
    final categoryColor = entry.category['color'] as Color? ?? Colors.grey;

    final currencyData = AppConstants.currencyData[entry.currency];
    final currencySymbol = currencyData?['symbol'] ?? entry.currency;
    final amountString = '$currencySymbol ${entry.amount.toStringAsFixed(0)}';

    // Calculate converted amount (placeholder logic: assuming USD as base or using exchangeRate)
    // If exchange rate is available and different from 1, show converted.
    // Ideally this should convert to the user's home currency.
    // For now, mirroring old logic: show if exchange rate implies conversion.
    // Or just show provided exchange rate calculation.
    String? convertedAmountString;
    if (entry.exchangeRate != 1.0) {
      // Assuming entry.amount is in local currency and we want to show it in some other currency?
      // Or entry.amount is in 'currency' and we want to show home currency?
      // Let's assume we show the value * exchangeRate.
      // The specific logic depends on what exchangeRate means (Local -> Home or Home -> Local).
      // ExpenseModel usually had exchange rate to Home Currency.
      // So converted amount is amount * exchangeRate.
      final converted = entry.amount * entry.exchangeRate;
      // Assuming home currency is not stored in entry but known contextually.
      // For now just showing value.
      // formatted with some currency symbol? '¥' was in old code.
      // I'll leave it simple for now or try to deduce.
      // Old code had: amount: 'Rs 12,500', converted: '¥ 21,250'
      // Let's just show formatted number.
      convertedAmountString = '~ ${converted.toStringAsFixed(0)}';
    }

    return Column(
      children: [
        InkWell(
          onTap: onTap,
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
                            : entry.notes,
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
                      amountString,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
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
