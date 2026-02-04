import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../routes/app_routes.dart' hide AppRoutes;

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChanged;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.medium,
          right: AppSpacing.medium,
          top: AppSpacing.small,
          bottom: AppSpacing.small,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Home
            _buildNavItem(
              icon: Icons.home_outlined,
              label: 'Home',
              index: 0,
              context: context,
            ),
            // Services
            _buildNavItem(
              icon: Icons.shopping_bag_outlined,
              label: 'Services',
              index: 1,
              context: context,
            ),
            // Center Space for FAB
            SizedBox(width: 60),
            // Appointments
            _buildNavItem(
              icon: Icons.calendar_month_outlined,
              label: 'Appointments',
              index: 3,
              context: context,
            ),
            // Staff
            _buildNavItem(
              icon: Icons.people_outline,
              label: 'Staff',
              index: 4,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required BuildContext context,
  }) {
    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        onTabChanged(index);
        _navigateToScreen(context, index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.small),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Home - no navigation needed if already on home
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.services);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.appointments);
        break;
      case 4:
        Navigator.pushNamed(context, '/staff');
        break;
      default:
        break;
    }
  }
}
