import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/appointment.dart';
import '../utils/constants.dart';
import '../utils/money.dart';
import 'status_pill.dart';

/// One booking: a date block, the details, and the two actions that used to be
/// empty callbacks on the old screen.
class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    required this.appointment,
    this.onReschedule,
    this.onCancel,
    super.key,
  });

  final Appointment appointment;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;

  bool get _showsActions =>
      appointment.status == AppointmentStatus.confirmed ||
      appointment.status == AppointmentStatus.pending;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final date = appointment.localStart;
    final isConfirmed = appointment.status == AppointmentStatus.confirmed;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline),
        borderRadius: BorderRadius.circular(AppRadius.xlarge),
      ),
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DateBlock(date: date, filled: isConfirmed),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            appointment.serviceName,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.small),
                        StatusPill(status: appointment.status),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${appointment.stylistName} · ${appointment.timeLabel}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Text(
                      Money.fromCents(appointment.priceCents),
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontSize: AppFontSize.body,
                        fontWeight: AppFontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_showsActions) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 14, 0, 12),
              child: Divider(),
            ),
            Row(
              children: [
                Expanded(
                  child: _CardAction(
                    label: 'Reschedule',
                    onPressed: onReschedule,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _CardAction(
                    label: 'Cancel',
                    onPressed: onCancel,
                    emphasised: true,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DateBlock extends StatelessWidget {
  const _DateBlock({required this.date, required this.filled});

  final DateTime date;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final onBlock = filled ? scheme.onPrimary : scheme.onSurface;
    final mutedOnBlock = filled
        ? scheme.onPrimary.withValues(alpha: 0.7)
        : scheme.onSurfaceVariant;

    return Container(
      width: 54,
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        color: filled ? scheme.primary : null,
        border: filled ? null : Border.all(color: scheme.outline),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        children: [
          Text(
            DateFormat('EEE').format(date).toUpperCase(),
            style: TextStyle(
              fontSize: AppFontSize.tiny,
              fontWeight: AppFontWeight.semiBold,
              letterSpacing: 0.5,
              color: mutedOnBlock,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            DateFormat('dd').format(date),
            style: TextStyle(
              fontSize: 21,
              fontWeight: AppFontWeight.bold,
              height: 1,
              color: onBlock,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            DateFormat('MMM').format(date).toUpperCase(),
            style: TextStyle(
              fontSize: AppFontSize.tiny,
              fontWeight: AppFontWeight.medium,
              color: mutedOnBlock,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardAction extends StatelessWidget {
  const _CardAction({
    required this.label,
    required this.onPressed,
    this.emphasised = false,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Cancelling is destructive, so it gets the full-strength outline while
  /// rescheduling gets the quiet one. There is no red to lean on here.
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(AppButtonStyles.smallHeight),
        side: BorderSide(
          color: emphasised ? scheme.onSurface : scheme.outline,
          width: emphasised ? AppButtonStyles.borderWidth : 1,
        ),
        textStyle: const TextStyle(
          fontSize: AppFontSize.label,
          fontWeight: AppFontWeight.semiBold,
        ),
      ),
      child: Text(label),
    );
  }
}
