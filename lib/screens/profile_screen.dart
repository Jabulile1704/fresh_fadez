import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/appointment.dart';
import '../utils/constants.dart';
import '../widgets/avatar_circle.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    required this.appointments,
    required this.onSignOut,
    super.key,
  });

  final List<Appointment> appointments;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    const user = SampleData.currentUser;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.large,
          AppSpacing.large,
          AppSpacing.large,
          AppSpacing.navClearance,
        ),
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Profile', style: theme.textTheme.headlineMedium),
              ),
              IconButton(
                onPressed: () => _notYet(context, 'Editing your profile'),
                icon: const Icon(Icons.edit_outlined, size: 18),
                tooltip: 'Edit profile',
                style: IconButton.styleFrom(
                  shape: CircleBorder(side: BorderSide(color: scheme.outline)),
                  minimumSize: const Size(40, 40),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          Row(
            children: [
              AvatarCircle(name: user.fullName, size: 68, filled: true),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.fullName, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(user.email, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 3),
                    Text(user.phone, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: scheme.outline),
              borderRadius: BorderRadius.circular(AppRadius.large),
            ),
            child: Row(
              children: [
                _Stat(value: '${appointments.length}', label: 'Bookings'),
                _StatDivider(),
                const _Stat(value: '3', label: 'Favourites'),
                _StatDivider(),
                const _Stat(value: "'24", label: 'Member since'),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text('SETTINGS', style: theme.textTheme.labelSmall),
          const SizedBox(height: 10),
          _SettingsTile(
            icon: Icons.notifications_none_rounded,
            label: 'Notifications',
            onTap: () => _notYet(context, 'Notification settings'),
          ),
          _SettingsTile(
            icon: Icons.credit_card,
            label: 'Payment methods',
            onTap: () => _notYet(context, 'Payment methods'),
          ),
          _SettingsTile(
            icon: Icons.shield_outlined,
            label: 'Privacy & security',
            onTap: () => _notYet(context, 'Privacy settings'),
          ),
          _SettingsTile(
            icon: Icons.help_outline_rounded,
            label: 'Help & support',
            onTap: () => _notYet(context, 'Help & support'),
            showDivider: false,
          ),
          const SizedBox(height: 26),
          OutlinedButton(onPressed: onSignOut, child: const Text('Sign out')),
        ],
      ),
    );
  }

  void _notYet(BuildContext context, String what) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$what is not built yet.')));
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: AppFontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontSize: AppFontSize.caption + 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 52,
    color: Theme.of(context).colorScheme.outline,
  );
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(bottom: BorderSide(color: scheme.outlineVariant))
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 19, color: scheme.onSurface),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: AppFontWeight.medium,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }
}
