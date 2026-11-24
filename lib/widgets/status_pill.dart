import 'package:flutter/material.dart';

import '../utils/constants.dart';

/// An appointment's status, carried by fill rather than hue.
///
/// Solid = confirmed, outlined = pending, muted = finished or cancelled. With
/// no colour in the palette this is what keeps the states apart, and it has
/// the side benefit of working for colour-blind users and in direct sunlight.
class StatusPill extends StatelessWidget {
  const StatusPill({required this.status, super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    late final Color background;
    late final Color foreground;
    late final Color? borderColor;

    switch (status) {
      case AppointmentStatus.confirmed:
        background = scheme.primary;
        foreground = scheme.onPrimary;
        borderColor = null;
      case AppointmentStatus.pending:
        background = Colors.transparent;
        foreground = scheme.onSurface;
        borderColor = scheme.onSurface;
      case AppointmentStatus.cancelled:
      case AppointmentStatus.noShow:
        background = scheme.surfaceContainerHighest;
        foreground = scheme.onSurfaceVariant;
        borderColor = null;
      default:
        background = scheme.surfaceContainerHighest;
        foreground = scheme.onSurface;
        borderColor = null;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 9,
        vertical: borderColor == null ? 4 : 2.5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.small + 2),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor, width: 1.5),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: AppFontWeight.bold,
          letterSpacing: 0.4,
          color: foreground,
        ),
      ),
    );
  }

  String get _label => switch (status) {
        AppointmentStatus.confirmed => 'CONFIRMED',
        AppointmentStatus.pending => 'PENDING',
        AppointmentStatus.completed => 'DONE',
        AppointmentStatus.cancelled => 'CANCELLED',
        AppointmentStatus.noShow => 'NO SHOW',
        _ => status.toUpperCase(),
      };
}
