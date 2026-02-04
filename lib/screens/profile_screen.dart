import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../routes/app_routes.dart' hide AppRoutes;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(96, 31, 139, 7),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppRadius.large),
                  bottomRight: Radius.circular(AppRadius.large),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.large),
                child: Column(
                  children: [
                    // Profile Avatar
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 248, 133, 2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: AppSpacing.medium),
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: AppFontSize.heading,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: AppSpacing.small),
                    Text(
                      'john.doe@example.com',
                      style: TextStyle(
                        fontSize: AppFontSize.body,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Profile Details
            Padding(
              padding: EdgeInsets.all(AppSpacing.large),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phone
                  _buildProfileItem(
                    icon: Icons.phone,
                    label: 'Phone',
                    value: '+1 (555) 123-4567',
                  ),
                  SizedBox(height: AppSpacing.large),

                  // Appointments
                  _buildProfileItem(
                    icon: Icons.calendar_today,
                    label: 'Total Appointments',
                    value: '12',
                  ),
                  SizedBox(height: AppSpacing.large),

                  // Favorite Salons
                  _buildProfileItem(
                    icon: Icons.favorite,
                    label: 'Favorite Salons',
                    value: '3',
                  ),
                  SizedBox(height: AppSpacing.xlarge),

                  // Settings Section
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: AppFontSize.title,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.medium),

                  // Settings List
                  _buildSettingsTile(
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Edit Profile - Coming Soon')),
                      );
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Notifications - Coming Soon')),
                      );
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.security,
                    title: 'Privacy & Security',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Privacy & Security - Coming Soon'),
                        ),
                      );
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.help,
                    title: 'Help & Support',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Help & Support - Coming Soon')),
                      );
                    },
                  ),
                  SizedBox(height: AppSpacing.xlarge),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      label: 'Logout',
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      backgroundColor: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color.fromARGB(96, 31, 139, 7),
          size: 24,
        ),
        SizedBox(width: AppSpacing.medium),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: AppFontSize.small,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.small),
            Text(
              value,
              style: TextStyle(
                fontSize: AppFontSize.subtitle,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.medium),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color.fromARGB(96, 31, 139, 7),
              size: 24,
            ),
            SizedBox(width: AppSpacing.medium),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppFontSize.body,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            child: Text('Logout', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
