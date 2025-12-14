import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  static const routeName = '/settings';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;
    final themeNotifier = ref.read(themeModeProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 24),
        // Notifications Section
        Text('Notifications', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('Enable Notifications'),
          subtitle: const Text('Receive trip and budget alerts'),
          value: true, // Replace with actual notification state
          onChanged: (value) {
            // Handle notification state change
          },
        ),
        const Divider(),
        const SizedBox(height: 16),
        // Display Section
        Text('Display', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Use dark theme'),
          value: isDarkMode,
          onChanged: (value) {
            themeNotifier.toggleTheme();
          },
        ),
        const Divider(),
        const SizedBox(height: 16),
        // About Section
        Text('About', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        const ListTile(
          title: Text('Version'),
          subtitle: Text('1.0.0'),
          trailing: Icon(Icons.info_outline),
        ),
        ListTile(
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () {
            // Handle privacy policy navigation
          },
        ),
        ListTile(
          title: const Text('Terms of Service'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () {
            // Handle terms navigation
          },
        ),
      ],
    );
  }
}
