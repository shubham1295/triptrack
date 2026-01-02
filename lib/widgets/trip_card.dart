import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triptrack/theme/app_strings.dart';
import 'package:triptrack/models/trip.dart';
import 'package:triptrack/screens/trip/edit_trip_screen.dart';
import 'package:triptrack/providers/trip_provider.dart';

class TripCard extends ConsumerWidget {
  final String imageUrl;
  final String title;
  final String date;
  final String budget;
  final bool isInDrawer;
  final Trip? trip;
  final VoidCallback? onDataChanged;

  const TripCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.budget,
    this.isInDrawer = false,
    this.trip,
    this.onDataChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: isInDrawer
              ? null
              : Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
          boxShadow: isInDrawer
              ? null
              : [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage: imageUrl.startsWith('assets/')
                    ? AssetImage(imageUrl) as ImageProvider
                    : AssetImage(
                        'assets/images/world-icon.jpg',
                      ), // Placeholder or FileImage if implemented
                radius: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 35,
                        height: 30,
                        child: PopupMenuButton<String>(
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.more_vert,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          offset: const Offset(0, 30),
                          onSelected: (String result) async {
                            if (result == AppStrings.edit && trip != null) {
                              final editResult = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditTripScreen(trip: trip!),
                                ),
                              );

                              // Handle the result from EditTripScreen
                              if (editResult != null) {
                                if (editResult == 'deleted') {
                                  // Trip was deleted in EditTripScreen handled by the screen itself or we do it here
                                  // But usually EditTripScreen should just call the provider.
                                  // For consistency, let's assume it returned 'deleted' and we call provider
                                  await ref
                                      .read(tripProvider.notifier)
                                      .deleteTrip(trip!.id);
                                  onDataChanged?.call();

                                  // Close drawer and show snackbar on main screen
                                  if (context.mounted) {
                                    Navigator.of(context).pop(); // Close drawer
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Trip deleted successfully',
                                        ),
                                        backgroundColor:
                                            theme.colorScheme.error,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                } else if (editResult is Trip) {
                                  // Trip was updated
                                  await ref
                                      .read(tripProvider.notifier)
                                      .addTrip(
                                        editResult,
                                      ); // addTrip actually saves/updates in Isar
                                  onDataChanged?.call();

                                  // Close drawer and show snackbar on main screen
                                  if (context.mounted) {
                                    Navigator.of(context).pop(); // Close drawer
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Trip updated successfully',
                                        ),
                                        backgroundColor:
                                            theme.colorScheme.primary,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                }
                              }
                            } else if (result == AppStrings.delete &&
                                trip != null) {
                              // Show delete confirmation dialog
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
                                      onPressed: () async {
                                        // Delete trip from database via provider
                                        await ref
                                            .read(tripProvider.notifier)
                                            .deleteTrip(trip!.id);
                                        if (context.mounted) {
                                          Navigator.pop(
                                            context,
                                          ); // Close dialog
                                          onDataChanged?.call();

                                          // Close drawer and show snackbar on main screen
                                          Navigator.of(
                                            context,
                                          ).pop(); // Close drawer
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                'Trip deleted successfully',
                                              ),
                                              backgroundColor:
                                                  theme.colorScheme.error,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            theme.colorScheme.error,
                                      ),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: AppStrings.edit,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit_outlined,
                                        size: 20,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        AppStrings.editTrip,
                                        style: TextStyle(
                                          color: theme.colorScheme.onSurface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: AppStrings.delete,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        size: 20,
                                        color: theme.colorScheme.error,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        AppStrings.deleteTrip,
                                        style: TextStyle(
                                          color: theme.colorScheme.error,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          date,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          budget,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
