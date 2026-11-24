import 'package:flutter/material.dart';

import 'routes/app_routes.dart';
import 'screens/login_screen.dart';
import 'utils/constants.dart';
import 'utils/theme.dart';
import 'widgets/app_shell.dart';

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
      AppRoutes.home: (context) => const AppShell(),
    },
    // The booking flow is pushed with MaterialPageRoute rather than named
    // routes, because each step carries a BookingDraft forward and hands one
    // back. Anything else that is still unbuilt lands here instead of
    // throwing, until go_router arrives.
    onUnknownRoute: (settings) => MaterialPageRoute<void>(
      builder: (context) => _NotBuiltYetScreen(routeName: settings.name),
    ),
  );
}

class _NotBuiltYetScreen extends StatelessWidget {
  const _NotBuiltYetScreen({this.routeName});

  final String? routeName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Coming soon')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction_outlined,
                size: 52,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.medium),
              Text('Not built yet', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.small),
              Text(
                routeName == null
                    ? 'This part of the app is still being built.'
                    : 'There is no screen for $routeName yet.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
