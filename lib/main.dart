import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/trip/add_trip_screen.dart';
import 'screens/settings/currency_list_screen.dart'; // Import CurrencyListScreen
import 'services/theme_provider.dart';
import 'theme/app_theme.dart';
import 'screens/auth/login_screen.dart'; // Import LoginScreen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'TripTrack',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      initialRoute: LoginScreen.routeName, // Set initial route
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        AddTripScreen.routeName: (context) => const AddTripScreen(),
        CurrencyListScreen.routeName: (context) => const CurrencyListScreen(),
      },
      debugShowCheckedModeBanner: true,
    );
  }
}
