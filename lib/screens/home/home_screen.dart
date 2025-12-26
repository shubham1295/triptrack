import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triptrack/theme/app_constants.dart';
import 'package:triptrack/models/entry.dart';
import 'package:triptrack/theme/app_strings.dart';
import 'package:triptrack/widgets/app_drawer.dart';
import 'package:triptrack/screens/entry/entries_screen.dart';
import 'package:triptrack/screens/home/stats_screen.dart';
import 'package:triptrack/screens/entry/pick_category_screen.dart';
import 'package:triptrack/screens/home/search_screen.dart';
import 'package:triptrack/screens/settings/settings_screen.dart';
import 'package:triptrack/providers/trip_provider.dart';
import 'package:triptrack/screens/trip/add_trip_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<EntriesScreenState> _entriesScreenKey = GlobalKey();

  late final List<Widget> _widgetOptions = <Widget>[
    EntriesScreen(key: _entriesScreenKey),
    const StatsScreen(),
    const SearchScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Check for trips on initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTripsAndRedirect();
    });
  }

  void _checkTripsAndRedirect() {
    final tripsAsync = ref.read(tripProvider);
    tripsAsync.whenData((trips) {
      if (trips.isEmpty) {
        Navigator.of(
          context,
        ).pushNamed(AddTripScreen.routeName, arguments: {'canPop': false});
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(tripProvider, (previous, next) {
      next.whenData((trips) {
        if (trips.isEmpty && mounted) {
          // If no trips, and we haven't already pushed/are on AddTripScreen
          // We can check the current route if needed, but simple pushNamed works for now
          Navigator.of(
            context,
          ).pushNamed(AddTripScreen.routeName, arguments: {'canPop': false});
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? AppConstants.appBarBackgroundColorLight
            : Theme.of(context).colorScheme.surfaceContainer,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            tooltip: 'Menu',
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Consumer(
          builder: (context, ref, child) {
            final activeTripAsync = ref.watch(currentActiveTripProvider);
            return activeTripAsync.when(
              data: (activeTrip) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    activeTrip?.name ?? 'No Trip Selected',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              loading: () => const Text('Loading...'),
              error: (err, stack) => const Text('Error'),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            tooltip: 'Settings',
            onPressed: () {
              // Navigate to settings or handle settings action
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
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
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(
          alpha: AppConstants.bottomNavBarSelectedItemAlpha,
        ),
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PickCategoryScreen(),
                  ),
                );
                if (result != null && _entriesScreenKey.currentState != null) {
                  if (result is Entry) {
                    _entriesScreenKey.currentState!.addEntry(result);
                  } else if (result is List<Entry>) {
                    _entriesScreenKey.currentState!.addEntries(result);
                  }
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
