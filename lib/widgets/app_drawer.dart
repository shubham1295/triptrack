import 'package:flutter/material.dart';
import 'package:triptrack/screens/trip/add_trip_screen.dart';
import 'package:triptrack/theme/app_constants.dart';
import 'package:triptrack/theme/app_strings.dart';
import 'package:triptrack/widgets/trip_card.dart';
import 'package:triptrack/models/trip.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  // Sample trip data - Replace with actual data from database/state management
  static final Trip _activeTrip = Trip(
    id: '1',
    name: 'Japan',
    imagePath: 'assets/images/world-icon.jpg',
    homeCurrency: 'INR',
    startDate: DateTime(2025, 11, 10),
    endDate: DateTime(2025, 11, 20),
    totalBudget: 200000,
    dailyBudget: 1200,
  );

  static final Trip _europeTrip = Trip(
    id: '2',
    name: 'EuropeEuropeEuropeEuropeEuropeEuropeEuropeEurope',
    imagePath: 'assets/images/world-icon.jpg',
    homeCurrency: 'INR',
    startDate: DateTime(2026, 1, 1),
    endDate: DateTime(2026, 1, 15),
    totalBudget: 350000,
    dailyBudget: 2000,
  );

  static final Trip _usaTrip = Trip(
    id: '3',
    name: 'USA',
    imagePath: 'assets/images/world-icon.jpg',
    homeCurrency: 'INR',
    startDate: DateTime(2026, 3, 1),
    endDate: DateTime(2026, 3, 10),
    totalBudget: 250000,
    dailyBudget: 1500,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      width: MediaQuery.of(context).size.width * AppConstants.drawerWidthFactor,
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
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? theme.colorScheme.surface.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? theme.colorScheme.primary.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.secondary
                                            .withValues(alpha: 0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 10,
                                        color: theme.colorScheme.onSecondary,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Active',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color:
                                                  theme.colorScheme.onSecondary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TripCard(
                            imageUrl: 'assets/images/world-icon.jpg',
                            title: 'Japan',
                            date: '10/Nov/2025 - 20/Nov/2025',
                            budget: 'Rs.1200 / Rs. 2,00,000',
                            isInDrawer: true,
                            trip: _activeTrip,
                          ),
                        ],
                      ),
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
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                TripCard(
                  imageUrl: 'assets/images/world-icon.jpg',
                  title: 'EuropeEuropeEuropeEuropeEuropeEuropeEuropeEurope',
                  date: '01/Jan/2026 - 15/Jan/2026',
                  budget: 'Rs. 2000 / Rs. 3,50,000',
                  trip: _europeTrip,
                ),
                const SizedBox(height: 12),
                TripCard(
                  imageUrl: 'assets/images/world-icon.jpg',
                  title: 'USA',
                  date: '01/Mar/2026 - 10/Mar/2026',
                  budget: 'Rs. 1500 / Rs. 2,50,000',
                  trip: _usaTrip,
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
