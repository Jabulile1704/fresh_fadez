import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';
import 'routes/app_routes.dart' hide AppRoutes;
import 'screens/login_screen.dart';
import 'screens/home_screen.dart' hide appName;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: appName,
    theme: AppTheme.lightTheme,
    debugShowCheckedModeBanner: false,
    home: const LoginScreen(),
    routes: {
      AppRoutes.login: (context) => LoginScreen(),
      AppRoutes.home: (context) => HomeScreen(),
    },
  );
}