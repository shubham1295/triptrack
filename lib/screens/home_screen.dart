import 'package:flutter/material.dart';
import 'package:triptrack/theme/app_constants.dart';
import 'package:triptrack/theme/app_strings.dart';
import 'package:triptrack/widgets/app_drawer.dart';
import 'package:triptrack/screens/entries_screen.dart';
import 'package:triptrack/screens/stats_screen.dart';
import 'package:triptrack/screens/pick_category_screen.dart';
import 'package:triptrack/screens/search_screen.dart';
import 'package:triptrack/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    EntriesScreen(),
    StatsScreen(),
    SearchScreen(),
    SettingsScreen(),
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
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFE8EAED)
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              'Japan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PickCategoryScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
