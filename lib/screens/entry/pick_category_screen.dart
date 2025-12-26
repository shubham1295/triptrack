import 'package:flutter/material.dart';
import 'package:triptrack/theme/app_constants.dart';
import 'package:triptrack/screens/entry/add_expense_screen.dart';
import 'package:triptrack/models/entry.dart';

class PickCategoryScreen extends StatelessWidget {
  final bool isSelecting;

  const PickCategoryScreen({super.key, this.isSelecting = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.brightness == Brightness.light
            ? AppConstants.appBarBackgroundColorLight
            : colorScheme.surfaceContainer,
        iconTheme: IconThemeData(color: colorScheme.primary),
        title: Text(
          isSelecting ? 'Change Category' : 'Pick a Category',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Field
            TextField(
              decoration: InputDecoration(
                hintText: 'Search category',
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: colorScheme.primary,
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Handle Change order
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      side: BorderSide(
                        color: colorScheme.primary.withValues(alpha: 0.5),
                      ),
                      foregroundColor: colorScheme.primary,
                    ),
                    icon: const Icon(Icons.swap_vert_rounded, size: 20),
                    label: const Text('Change Order'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Handle Edit Categories
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      side: BorderSide(
                        color: colorScheme.primary.withValues(alpha: 0.5),
                      ),
                      foregroundColor: colorScheme.primary,
                    ),
                    icon: const Icon(Icons.edit_rounded, size: 20),
                    label: const Text('Edit'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Categories Grid
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 16,
                ),
                itemCount: AppConstants.categories.length,
                itemBuilder: (context, index) {
                  final categoryMap = AppConstants.categories[index];
                  final category = Category(
                    name: categoryMap['name'] as String?,
                    icon: (categoryMap['icon'] as IconData).codePoint,
                    color: (categoryMap['color'] as Color).value,
                  );
                  return InkWell(
                    onTap: () async {
                      if (isSelecting) {
                        Navigator.pop(context, category);
                      } else {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddExpenseScreen(category: category),
                          ),
                        );
                        if ((result is Entry || result is List<Entry>) &&
                            context.mounted) {
                          Navigator.pop(context, result);
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(20), // Changed from 16
                    child: Column(
                      // Changed from Container to Column directly
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16), // Changed from 8
                          decoration: BoxDecoration(
                            color: Color(
                              category.color ?? Colors.blue.value,
                            ).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            IconData(
                              category.icon ?? Icons.category.codePoint,
                              fontFamily: Icons.category.fontFamily,
                              fontPackage: Icons.category.fontPackage,
                            ),
                            color: Color(category.color ?? Colors.blue.value),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.name ?? 'General',
                          textAlign: TextAlign.center,
                          maxLines: 1, // Changed from 2
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500, // Changed from w600
                            color: colorScheme.onSurface,
                            fontSize: 10, // Added fontSize
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
