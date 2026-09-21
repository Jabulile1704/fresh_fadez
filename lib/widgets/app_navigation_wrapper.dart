import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../utils/constants.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class AppNavigationWrapper extends StatefulWidget {
  const AppNavigationWrapper({Key? key}) : super(key: key);

  @override
  State<AppNavigationWrapper> createState() => _AppNavigationWrapperState();
}

class _AppNavigationWrapperState extends State<AppNavigationWrapper> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) => PopScope(
      // Back from any other tab returns to Home instead of leaving the app.
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() => _currentIndex = 0);
        }
      },
      child: Scaffold(
        body: _buildScreen(_currentIndex),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTabChanged: (index) {
            setState(() => _currentIndex = index);
          },
        ),
        floatingActionButton: _buildFAB(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        // Services screen - will be navigated to
        return const HomeScreen();
      case 3:
        // Appointments screen - will be navigated to
        return const HomeScreen();
      case 4:
        // Staff screen - will be navigated to
        return const HomeScreen();
      default:
        return const HomeScreen();
    }
  }

  Widget _buildFAB(BuildContext context) => Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.booking);
          },
          borderRadius: BorderRadius.circular(AppBorderRadius.circle),
          child: const Padding(
            padding: EdgeInsets.all(AppSpacing.medium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(height: 2),
                Text(
                  'Book',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
}
