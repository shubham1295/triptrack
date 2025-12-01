import 'package:flutter/material.dart';
import 'package:triptrack/screens/add_trip_screen.dart';
import 'package:triptrack/theme/app_constants.dart';
import 'package:triptrack/theme/app_strings.dart';
import 'package:triptrack/widgets/trip_card.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

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
                        theme.colorScheme.primary.withOpacity(0.6),
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
                            ? theme.colorScheme.surface.withOpacity(0.3)
                            : Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? theme.colorScheme.primary.withOpacity(0.3)
                              : Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 12,
                                        color: theme.colorScheme.onSecondary,
                                      ),
                                      const SizedBox(width: 4),
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
                          const TripCard(
                            imageUrl: 'assets/images/world-icon.jpg',
                            title: 'Japan',
                            date: '10/Nov/2025 - 20/Nov/2025',
                            budget: 'Rs.1200 / Rs. 2,00,000',
                            isInDrawer: true,
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
              children: const [
                TripCard(
                  imageUrl: 'assets/images/world-icon.jpg',
                  title: 'EuropeEuropeEuropeEuropeEuropeEuropeEuropeEurope',
                  date: '01/Jan/2026 - 15/Jan/2026',
                  budget: 'Rs. 2000 / Rs. 3,50,000',
                ),
                SizedBox(height: 12),
                TripCard(
                  imageUrl: 'assets/images/world-icon.jpg',
                  title: 'USA',
                  date: '01/Mar/2026 - 10/Mar/2026',
                  budget: 'Rs. 1500 / Rs. 2,50,000',
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
                color: theme.colorScheme.secondary.withOpacity(0.3),
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
