import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triptrack/screens/trip/add_trip_screen.dart';
import 'package:triptrack/theme/app_constants.dart';
import 'package:triptrack/theme/app_strings.dart';
import 'package:triptrack/widgets/trip_card.dart';
import 'package:triptrack/providers/trip_provider.dart';
import 'package:triptrack/utils/formatting_util.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer(
      builder: (context, ref, child) {
        final activeTripAsync = ref.watch(currentActiveTripProvider);
        final previousTripsAsync = ref.watch(previousTripsProvider);
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        return Drawer(
          width:
              MediaQuery.of(context).size.width *
              AppConstants.drawerWidthFactor,
          child: Column(
            children: [
              // Header Section with User Profile
              Container(
                decoration: BoxDecoration(
                  gradient: isDark
                      ? null
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primaryContainer,
                          ],
                        ),
                  color: isDark ? theme.scaffoldBackgroundColor : null,
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Profile Section
                        Row(
                          children: [
                            Icon(
                              Icons.luggage,
                              color: isDark
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onPrimary,
                              size: 30,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              AppStrings.myTrips,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: isDark
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            const Spacer(),
                            const _AddTripButton(),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Active Trip Card with Badge
                        activeTripAsync.when(
                          data: (activeTrip) => activeTrip != null
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? theme.colorScheme.surface.withValues(
                                            alpha: 0.3,
                                          )
                                        : Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isDark
                                          ? theme.colorScheme.primary
                                                .withValues(alpha: 0.3)
                                          : Colors.white.withValues(alpha: 0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      if (activeTrip.endDate != null &&
                                          !activeTrip.endDate!.isBefore(today))
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            12,
                                            12,
                                            12,
                                            8,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: theme
                                                      .colorScheme
                                                      .secondary,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: theme
                                                          .colorScheme
                                                          .secondary
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      blurRadius: 4,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      size: 10,
                                                      color: theme
                                                          .colorScheme
                                                          .onSecondary,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      'Active',
                                                      style: theme
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(
                                                            color: theme
                                                                .colorScheme
                                                                .onSecondary,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      TripCard(
                                        imageUrl:
                                            activeTrip.imagePath ??
                                            'assets/images/world-icon.jpg',
                                        title: activeTrip.name,
                                        date: _formatDateRange(
                                          activeTrip.startDate,
                                          activeTrip.endDate,
                                        ),
                                        budget: _formatBudget(
                                          activeTrip.dailyBudget,
                                          activeTrip.totalBudget,
                                          activeTrip.homeCurrency,
                                        ),
                                        isInDrawer: true,
                                        trip: activeTrip,
                                        onDataChanged: () {
                                          // Riverpod will automatically refresh
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (err, stack) => Text('Error: $err'),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),

              // Previous Trips Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Row(
                  children: [
                    Icon(
                      Icons.history,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.previousTrip,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Previous Trips List
              Expanded(
                child: previousTripsAsync.when(
                  data: (previousTrips) => ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: previousTrips.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final trip = previousTrips[index];
                      return TripCard(
                        imageUrl:
                            trip.imagePath ?? 'assets/images/world-icon.jpg',
                        title: trip.name,
                        date: _formatDateRange(trip.startDate, trip.endDate),
                        budget: _formatBudget(
                          trip.dailyBudget,
                          trip.totalBudget,
                          trip.homeCurrency,
                        ),
                        trip: trip,
                        onDataChanged: () {
                          // Riverpod will automatically refresh
                        },
                      );
                    },
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error: $err'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Formats the date range for display
  String _formatDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return 'No dates set';
    }
    final start =
        '${startDate.day.toString().padLeft(2, '0')}/${_getMonthName(startDate.month)}/${startDate.year}';
    final end =
        '${endDate.day.toString().padLeft(2, '0')}/${_getMonthName(endDate.month)}/${endDate.year}';
    return '$start - $end';
  }

  /// Formats the budget for display
  String _formatBudget(
    double dailyBudget,
    double totalBudget,
    String homeCurrency,
  ) {
    return '${FormattingUtil.formatCurrency(dailyBudget, homeCurrency)} / ${FormattingUtil.formatCurrency(totalBudget, homeCurrency)}';
  }

  /// Gets the month name abbreviation
  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

class _AddTripButton extends StatelessWidget {
  const _AddTripButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(AddTripScreen.routeName);
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.secondary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle,
                size: 18,
                color: theme.colorScheme.onSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                AppStrings.add,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
