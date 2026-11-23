import 'package:flutter/material.dart';

import 'routes/app_routes.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'utils/constants.dart';
import 'utils/theme.dart';

void main() {
  runApp(const FreshFadezApp());
}

class FreshFadezApp extends StatelessWidget {
  const FreshFadezApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: appName,
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    debugShowCheckedModeBanner: false,
    initialRoute: AppRoutes.login,
    routes: {
      AppRoutes.login: (context) => const LoginScreen(),
      AppRoutes.home: (context) => const HomeScreen(),
    },
    // The home screen pushes `booking`, `services` and `staffDetail`, none of
    // which have screens yet, so those taps used to throw. Until Milestone 4
    // replaces this with `go_router`, they land somewhere honest instead.
    onUnknownRoute: (settings) => MaterialPageRoute<void>(
      builder: (context) => _NotBuiltYetScreen(routeName: settings.name),
    ),
  );
}

class _NotBuiltYetScreen extends StatelessWidget {
  const _NotBuiltYetScreen({this.routeName});

  final String? routeName;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Coming soon')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              'Not built yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              routeName == null
                  ? 'This part of the app is still being built.'
                  : 'There is no screen for $routeName yet.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    ),
  );
}
