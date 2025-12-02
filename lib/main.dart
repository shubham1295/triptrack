import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triptrack/screens/add_trip_screen.dart'; // Import AddTripScreen
import 'package:triptrack/screens/currency_selection_screen.dart';
import 'package:triptrack/screens/currency_list_screen.dart'; // Import CurrencyListScreen
import 'services/theme_provider.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart'; // Import LoginScreen

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'TripTrack',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: LoginScreen.routeName, // Set initial route
          routes: {
            LoginScreen.routeName: (context) => const LoginScreen(),
            AddTripScreen.routeName: (context) => const AddTripScreen(),
            CurrencyListScreen.routeName: (context) => const CurrencyListScreen(),
          },
          debugShowCheckedModeBanner: true,
        );
      },
    );
  }
}
