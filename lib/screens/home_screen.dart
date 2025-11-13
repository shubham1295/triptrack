import 'package:flutter/material.dart';
import 'package:triptrack/theme/app_constants.dart';
import 'package:triptrack/theme/app_strings.dart';
import 'package:triptrack/widgets/trip_card.dart';
import 'package:triptrack/screens/entries_screen.dart';
import 'package:triptrack/screens/stats_screen.dart';
import 'package:triptrack/screens/search_screen.dart';
import 'package:triptrack/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions = <Widget>[
    const EntriesScreen(),
    const StatsScreen(),
    const SearchScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Text('Japan'),
            Spacer(),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Handle settings icon tap
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        width:
            MediaQuery.of(context).size.width *
            AppConstants.drawerWidthFactor, // Added drawer width
        child: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
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
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: AppConstants.myTripsFontSize,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            // Handle "My Trip" button tap
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.secondary,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onSecondary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 4,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.add, size: AppConstants.addIconSize),
                              SizedBox(width: AppConstants.sizedBoxWidth),
                              Text(
                                AppStrings.add,
                                style: TextStyle(
                                  fontSize: AppConstants.addTextFontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.sizedBoxHeight),
                    const TripCard(
                      imageUrl: 'assets/images/google_logo.png',
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
                    imageUrl: 'assets/images/google_logo.png',
                    title: 'EuropeEuropeEuropeEuropeEuropeEuropeEuropeEurope',
                    date: '01/Jan/2026 - 15/Jan/2026',
                    budget: 'Rs. 2000 / Rs. 3,50,000',
                  ),
                  SizedBox(height: AppConstants.tripCardHeight),
                  TripCard(
                    imageUrl: 'assets/images/google_logo.png',
                    title: 'USA',
                    date: '01/Mar/2026 - 10/Mar/2026',
                    budget: 'Rs. 1500 / Rs. 2,50,000',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: AppStrings.entries,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: AppStrings.stats,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: AppStrings.search,
          ),
          // BottomNavigationBarItem(icon: Icon(Icons.map), label: AppStrings.map),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: AppStrings.settings,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withAlpha(
          (AppConstants.bottomNavBarSelectedItemAlpha * 255).round(),
        ),
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                // Handle floating action button tap
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
