import 'package:flutter/material.dart';
import '../utils/constants.dart';

class BottomNavBar extends StatelessWidget {

  const BottomNavBar({
    required this.currentIndex, required this.onIndexChanged, Key? key,
  }) : super(key: key);
  final int currentIndex;
  final Function(int) onIndexChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
      // Ensures the bottom nav bar fits standard height
      height: kBottomNavigationBarHeight,
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onIndexChanged,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        elevation: 8,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(
          fontSize: AppFontSize.small,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: AppFontSize.small,
          fontWeight: FontWeight.w500,
        ),
        // Reduce padding to prevent overflow on smaller screens
        iconSize: 26,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Salons',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cut_outlined),
            activeIcon: Icon(Icons.cut),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
}
