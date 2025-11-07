import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/elevated_button.dart';
import '../widgets/hill_background.dart';
import 'home_screen.dart';

/// Button width constant for Google and Email buttons
const double _kButtonWidth = 280.0;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _navigateToHome(BuildContext context) {
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const HomeScreen()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
    return Column(
      children: [
        // Placeholder Logo
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: kBorderRadius,
            boxShadow: [
              BoxShadow(
                color: AppColors.text.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(Icons.flight_takeoff, size: 64, color: AppColors.primary),
        ),
        const SizedBox(height: 24),

        // Welcome Text
        Text(
          'Welcome to',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'TripTrack',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Track your spending while travelling',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.grey,
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
              textStyle: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontSize: 16),
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
                foregroundColor: AppColors.grey,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                minimumSize: Size(_kButtonWidth, 48),
              ),
              child: Text(
                'Continue as Guest',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w700,
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
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.text,
        side: const BorderSide(color: AppColors.primary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        minimumSize: Size(_kButtonWidth, 48),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Google logo
          // Image.asset('assets/images/google_logo.png', width: 50, height: 24),
          // const SizedBox(width: 5),
          SizedBox(
            width: 30,
            height: 30,
            child: Image.asset(
              'assets/images/google_logo.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.login, size: 24, color: AppColors.primary),
            ),
          ),
          Text(
            'Continue with Google',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
