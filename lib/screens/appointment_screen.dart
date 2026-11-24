import 'package:flutter/material.dart';

import '../models/appointment.dart';
import '../utils/constants.dart';
import '../widgets/appointment_card.dart';

enum _Filter { upcoming, past, cancelled }

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({
    required this.appointments,
    required this.onReschedule,
    required this.onCancel,
    required this.onStartBooking,
    super.key,
  });

  final List<Appointment> appointments;
  final ValueChanged<Appointment> onReschedule;
  final ValueChanged<Appointment> onCancel;
  final VoidCallback onStartBooking;

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  _Filter _filter = _Filter.upcoming;

  List<Appointment> get _visible {
    final now = DateTime.now();
    final matching = switch (_filter) {
      _Filter.upcoming => widget.appointments.where(
        (a) =>
            a.localStart.isAfter(now) &&
            (a.status == AppointmentStatus.confirmed ||
                a.status == AppointmentStatus.pending),
      ),
      _Filter.past => widget.appointments.where(
        (a) =>
            a.status == AppointmentStatus.completed ||
            (a.localStart.isBefore(now) &&
                a.status != AppointmentStatus.cancelled &&
                a.status != AppointmentStatus.noShow),
      ),
      _Filter.cancelled => widget.appointments.where(
        (a) =>
            a.status == AppointmentStatus.cancelled ||
            a.status == AppointmentStatus.noShow,
      ),
    };

    return matching.toList()..sort(
      (a, b) => _filter == _Filter.upcoming
          ? a.localStart.compareTo(b.localStart)
          : b.localStart.compareTo(a.localStart),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visible = _visible;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.large,
              AppSpacing.large,
              AppSpacing.large,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My bookings', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 20),
                _Segmented(
                  value: _filter,
                  onChanged: (value) => setState(() => _filter = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: visible.isEmpty
                ? _EmptyState(
                    filter: _filter,
                    onStartBooking: widget.onStartBooking,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.large,
                      20,
                      AppSpacing.large,
                      AppSpacing.navClearance,
                    ),
                    itemCount: visible.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final appointment = visible[index];
                      return AppointmentCard(
                        appointment: appointment,
                        onReschedule: () => widget.onReschedule(appointment),
                        onCancel: () => widget.onCancel(appointment),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _Segmented extends StatelessWidget {
  const _Segmented({required this.value, required this.onChanged});

  final _Filter value;
  final ValueChanged<_Filter> onChanged;

  static const Map<_Filter, String> _labels = {
    _Filter.upcoming: 'Upcoming',
    _Filter.past: 'Past',
    _Filter.cancelled: 'Cancelled',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Row(
        children: [
          for (final entry in _labels.entries)
            Expanded(
              child: Semantics(
                selected: entry.key == value,
                button: true,
                child: GestureDetector(
                  onTap: () => onChanged(entry.key),
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: entry.key == value ? scheme.surface : null,
                      borderRadius: BorderRadius.circular(AppRadius.small + 3),
                      boxShadow: entry.key == value ? AppShadows.card : null,
                    ),
                    child: Center(
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: AppFontSize.label,
                          fontWeight: entry.key == value
                              ? AppFontWeight.semiBold
                              : AppFontWeight.medium,
                          color: entry.key == value
                              ? scheme.onSurface
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filter, required this.onStartBooking});

  final _Filter filter;
  final VoidCallback onStartBooking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (String title, String body) = switch (filter) {
      _Filter.upcoming => ('Nothing booked', 'Your next cut starts here.'),
      _Filter.past => ('No history yet', 'Past visits will show up here.'),
      _Filter.cancelled => (
        'Nothing cancelled',
        'Bookings you call off land here.',
      ),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xlarge,
          0,
          AppSpacing.xlarge,
          AppSpacing.navClearance,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_note_outlined,
              size: 46,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            if (filter == _Filter.upcoming) ...[
              const SizedBox(height: AppSpacing.large),
              ElevatedButton(
                onPressed: onStartBooking,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, AppButtonStyles.secondaryHeight),
                ),
                child: const Text('Book a slot'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
