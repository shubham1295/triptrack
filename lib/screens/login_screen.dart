import 'package:flutter/material.dart';
import '../widgets/elevated_button.dart';
import '../widgets/hill_background.dart';
import 'home_screen.dart';

/// Button width constant for Google and Email buttons
const double _kButtonWidth = 280.0;

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hill background
          const HillBackgroundWidget(),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 90),

                  // Logo Section
                  _LogoSection(),

                  const SizedBox(height: 30),

                  // Buttons Section
                  _ButtonsSection(
                    onGooglePressed: () => _navigateToHome(context),
                    onEmailPressed: () => _navigateToHome(context),
                    onGuestPressed: () => _navigateToHome(context),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Logo and welcome text section
class _LogoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Placeholder Logo
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.flight_takeoff,
            size: 64,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),

        // Welcome Text
        Text(
          'Welcome to',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'TripTrack',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Track your spending while travelling',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodySmall?.color,
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Authentication buttons section
class _ButtonsSection extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onEmailPressed;
  final VoidCallback onGuestPressed;

  const _ButtonsSection({
    required this.onGooglePressed,
    required this.onEmailPressed,
    required this.onGuestPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Continue with Google button
        Center(
          child: SizedBox(
            width: _kButtonWidth,
            child: _GoogleButton(onPressed: onGooglePressed),
          ),
        ),
        const SizedBox(height: 16),

        // Continue with Email button
        Center(
          child: SizedBox(
            width: _kButtonWidth,
            child: AppElevatedButton(
              text: 'Continue with Email',
              isPrimary: true,
              width: _kButtonWidth,
              icon: Icons.email,
              onPressed: onEmailPressed,
              textStyle: theme.textTheme.labelLarge?.copyWith(fontSize: 15),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Continue as Guest
        Center(
          child: SizedBox(
            width: _kButtonWidth,
            child: TextButton(
              onPressed: onGuestPressed,
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurfaceVariant,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                minimumSize: const Size(_kButtonWidth, 48),
              ),
              child: Text(
                'Continue as Guest',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Google sign-in button with transparent background
class _GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _GoogleButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
        side: BorderSide(color: theme.colorScheme.primary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        minimumSize: const Size(_kButtonWidth, 48),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Google logo
          SizedBox(
            width: 30,
            height: 30,
            child: Image.asset(
              'assets/images/google_logo.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.login, size: 24, color: theme.colorScheme.primary),
            ),
          ),
          Text(
            'Continue with Google',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
