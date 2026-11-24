import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/sample_data.dart';
import '../models/appointment.dart';
import '../models/service.dart';
import '../utils/constants.dart';
import '../utils/money.dart';
import '../widgets/avatar_circle.dart';
import '../widgets/service_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.appointments,
    required this.onStartBooking,
    required this.onSeeAllServices,
    super.key,
  });

  final List<Appointment> appointments;
  final void Function(Service? service) onStartBooking;
  final VoidCallback onSeeAllServices;

  Appointment? get _nextAppointment {
    final upcoming = appointments.where((a) => a.isUpcoming).toList()
      ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
    return upcoming.isEmpty ? null : upcoming.first;
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 18) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final next = _nextAppointment;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE, d MMM').format(DateTime.now()),
                      style: theme.textTheme.labelSmall,
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '$_greeting, ${SampleData.currentUser.firstName}',
                      style: theme.textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              AvatarCircle(name: SampleData.currentUser.fullName, size: 44),
            ],
          ),
          const SizedBox(height: 22),
          if (next != null)
            _NextUpCard(appointment: next)
          else
            _NoBookingsCard(onStartBooking: () => onStartBooking(null)),
          const SizedBox(height: 30),
          _SectionHeader(
            title: 'Services',
            actionLabel: 'See all',
            onAction: onSeeAllServices,
          ),
          const SizedBox(height: AppSpacing.small + 4),
          for (final service in SampleData.services.take(3))
            ServiceRow(
              service: service,
              onTap: () => onStartBooking(service),
              showDivider: service != SampleData.services[2],
            ),
          const SizedBox(height: 26),
          Text('Our team', style: theme.textTheme.titleLarge),
          const SizedBox(height: 14),
          Row(
            children: [
              for (final stylist in SampleData.stylists)
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: () => onStartBooking(null),
                    child: SizedBox(
                      width: 62,
                      child: Column(
                        children: [
                          AvatarCircle(
                            name: stylist.fullName,
                            size: 58,
                            filled: stylist == SampleData.stylists.first,
                          ),
                          const SizedBox(height: AppSpacing.small),
                          Text(
                            stylist.firstName,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 26),
          _SalonCard(),
        ],
      ),
    );
  }
}

class _NextUpCard extends StatelessWidget {
  const _NextUpCard({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onPrimary.withValues(alpha: 0.72);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(AppRadius.xlarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'NEXT UP',
                  style: TextStyle(
                    fontSize: AppFontSize.caption,
                    fontWeight: AppFontWeight.semiBold,
                    letterSpacing: 0.8,
                    color: muted,
                  ),
                ),
              ),
              // A filled black pill would vanish on a black card, so the
              // status inverts here.
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: scheme.onPrimary,
                  borderRadius: BorderRadius.circular(AppRadius.small + 3),
                ),
                child: Text(
                  appointment.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: AppFontWeight.bold,
                    letterSpacing: 0.4,
                    color: scheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            appointment.serviceName,
            style: TextStyle(
              fontSize: 21,
              fontWeight: AppFontWeight.semiBold,
              letterSpacing: -0.4,
              color: scheme.onPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'with ${appointment.stylistName}',
            style: TextStyle(fontSize: AppFontSize.label + 1, color: muted),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
            child: Divider(color: scheme.onPrimary.withValues(alpha: 0.18)),
          ),
          Row(
            children: [
              _MetaChip(
                icon: Icons.calendar_today_outlined,
                label: DateFormat(
                  'EEE d MMM',
                ).format(appointment.appointmentDate),
                color: muted,
              ),
              const SizedBox(width: 18),
              _MetaChip(
                icon: Icons.access_time,
                label: appointment.appointmentTime,
                color: muted,
              ),
              const Spacer(),
              Text(
                Money.fromRand(appointment.totalPrice),
                style: TextStyle(
                  fontSize: AppFontSize.body,
                  fontWeight: AppFontWeight.bold,
                  color: scheme.onPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 15, color: color),
      const SizedBox(width: 7),
      Text(label, style: TextStyle(fontSize: AppFontSize.label, color: color)),
    ],
  );
}

class _NoBookingsCard extends StatelessWidget {
  const _NoBookingsCard({required this.onStartBooking});

  final VoidCallback onStartBooking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(AppRadius.xlarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nothing booked', style: theme.textTheme.titleMedium),
          const SizedBox(height: 5),
          Text(
            'Three taps and the chair is yours.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.medium),
          ElevatedButton(
            onPressed: onStartBooking,
            child: const Text('Book a slot'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}

class _SalonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium + 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.xlarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(SampleData.salonName, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.small + 2),
          const _InfoLine(
            icon: Icons.location_on_outlined,
            text: SampleData.salonAddress,
          ),
          const SizedBox(height: 7),
          const _InfoLine(icon: Icons.call_outlined, text: SampleData.salonPhone),
          const SizedBox(height: 7),
          const _InfoLine(
            icon: Icons.access_time,
            text: 'Open today · ${SampleData.salonHours}',
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}
