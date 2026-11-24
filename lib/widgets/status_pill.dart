import 'package:flutter/material.dart';

import '../models/appointment.dart';
import '../utils/constants.dart';

/// An appointment's status, carried by fill rather than hue.
///
/// Solid = confirmed, outlined = pending, muted = finished or cancelled. With
/// no colour in the palette this is what keeps the states apart, and it has
/// the side benefit of working for colour-blind users and in direct sunlight.
///
/// Takes the typed [AppointmentStatus] rather than a `String`, so a new state
/// on the server becomes a compile error here instead of an unstyled pill.
class StatusPill extends StatelessWidget {
  const StatusPill({required this.status, super.key});

  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final Color background;
    final Color foreground;
    final Color? borderColor;

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
      case AppointmentStatus.completed:
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
        status.label,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: AppFontWeight.bold,
          letterSpacing: 0.4,
          color: foreground,
        ),
      ),
    );
  }
}
