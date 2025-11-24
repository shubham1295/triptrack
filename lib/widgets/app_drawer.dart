import 'package:flutter/material.dart';
import 'package:triptrack/screens/add_trip_screen.dart'; // Import the new screen
import 'package:triptrack/theme/app_constants.dart';
import 'package:triptrack/theme/app_strings.dart';
import 'package:triptrack/widgets/trip_card.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width:
          MediaQuery.of(context).size.width *
          AppConstants.drawerWidthFactor, // Added drawer width
      child: Column(
        children: [
          Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppStrings.myTrips,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onPrimary,
                          fontSize: AppConstants.myTripsFontSize,
                        ),
                      ),
                      const Spacer(),
                      const _AddTripButton(),
                    ],
                  ),
                  const SizedBox(height: AppConstants.sizedBoxHeight),
                  const TripCard(
                    imageUrl: 'assets/images/world-icon.jpg',
                    title: 'Japan',
                    date: '10/Nov/2025 - 20/Nov/2025',
                    budget: 'Rs.1200 / Rs. 2,00,000',
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.previousTrip,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppConstants.previousTripFontSize,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          const Divider(
            height: 1,
            indent: 16.0,
            endIndent: 16.0,
            color: Colors.grey,
          ),
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
                SizedBox(height: AppConstants.tripCardHeight),
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
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(AddTripScreen.routeName); // Navigate to AddTripScreen
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
      ),
      child: Row(
        children: [
          const Icon(Icons.add, size: AppConstants.addIconSize),
          const SizedBox(width: AppConstants.sizedBoxWidth),
          const Text(
            AppStrings.add,
            style: TextStyle(fontSize: AppConstants.addTextFontSize),
          ),
        ],
      ),
    );
  }
}
