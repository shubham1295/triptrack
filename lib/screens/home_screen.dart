import 'package:flutter/material.dart';
import 'package:triptrack/theme/app_constants.dart';
import 'package:triptrack/theme/app_strings.dart';
import 'package:triptrack/widgets/trip_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text(AppStrings.entries)),
    Center(child: Text(AppStrings.stats)),
    Center(child: Text(AppStrings.search)),
    Center(child: Text(AppStrings.map)),
    Center(child: Text(AppStrings.settings)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showDetailOptionsSheet(BuildContext context) {
    const options = [
      'View Detailed Breakdown',
      'Change Date Range',
      'Export Data',
    ];

    // Set an initial selected value (you can use your parent widget's current state here)
    String currentSelection = options[0];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Select an Option',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  ...options.map((optionText) {
                    final isSelected = currentSelection == optionText;

                    return ListTile(
                      title: Text(optionText),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        setState(() {
                          currentSelection = optionText;
                        });
                      },
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Spacer(),
                                  // Icon(
                                  //   Icons.keyboard_arrow_down,
                                  //   color: Colors.grey,
                                  //   size: 16,
                                  // ),
                                  // ✨ START OF CHANGE: GestureDetector for onTap
                                  GestureDetector(
                                    onTap: () =>
                                        _showDetailOptionsSheet(context),
                                    child: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                  ),
                                  // ✨ END OF CHANGE
                                ],
                              ),
                              SizedBox(height: 5),
                              Center(
                                child: Builder(
                                  builder: (context) {
                                    final baseStyle = Theme.of(
                                      context,
                                    ).textTheme.bodyLarge;
                                    return RichText(
                                      text: TextSpan(
                                        style: baseStyle,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Rs 19,000',
                                            style: baseStyle?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '.55',
                                            style: baseStyle?.copyWith(
                                              fontWeight: FontWeight.normal,
                                              fontSize:
                                                  (baseStyle.fontSize ?? 24.0) *
                                                  0.75,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Budget Amount
                              Center(
                                child: Text(
                                  '9000/2,00,000',
                                  style: TextStyle(
                                    color: Colors.grey, // Same color as 'Total'
                                    fontSize: 12, // Same size as 'Total'
                                  ),
                                ),
                              ),
                              // 📏 Space before the progress bar
                              const SizedBox(height: 10),

                              // 📊 HARDCODED PROGRESS BAR ADDED HERE
                              ClipRRect(
                                // Used ClipRRect to round the edges of the progress bar
                                borderRadius: BorderRadius.circular(5.0),
                                child: const LinearProgressIndicator(
                                  value: 0.45, // Hardcoded progress value (45%)
                                  minHeight:
                                      4.0, // Control the height of the bar
                                  backgroundColor: Colors.grey,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue, // Use your desired color
                                  ),
                                ),
                              ),
                              // 📊 END OF PROGRESS BAR
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Today',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Center(
                                child: Builder(
                                  builder: (context) {
                                    final baseStyle = Theme.of(
                                      context,
                                    ).textTheme.bodyLarge;
                                    return RichText(
                                      text: TextSpan(
                                        style: baseStyle,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Rs 5000',
                                            style: baseStyle?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '.55',
                                            style: baseStyle?.copyWith(
                                              fontWeight: FontWeight.normal,
                                              fontSize:
                                                  (baseStyle.fontSize ?? 24.0) *
                                                  0.75,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Budget Amount
                              Center(
                                child: Text(
                                  '9000/2,00,000',
                                  style: TextStyle(
                                    color: Colors.grey, // Same color as 'Total'
                                    fontSize: 12, // Same size as 'Total'
                                  ),
                                ),
                              ),
                              // 📏 Space before the progress bar
                              const SizedBox(height: 10),

                              // 📊 HARDCODED PROGRESS BAR ADDED HERE
                              ClipRRect(
                                // Used ClipRRect to round the edges of the progress bar
                                borderRadius: BorderRadius.circular(5.0),
                                child: const LinearProgressIndicator(
                                  value: 0.45, // Hardcoded progress value (45%)
                                  minHeight:
                                      4.0, // Control the height of the bar
                                  backgroundColor: Colors.grey,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue, // Use your desired color
                                  ),
                                ),
                              ),
                              // 📊 END OF PROGRESS BAR
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 2),
          const Divider(indent: 16.0, endIndent: 16.0, color: Colors.grey),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              // color: Colors.yellow,
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ),
        ],
      ),
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
