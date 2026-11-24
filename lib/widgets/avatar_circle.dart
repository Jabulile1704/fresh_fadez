import 'package:flutter/material.dart';

import '../utils/constants.dart';

/// An initials avatar. Filled black when it is the selected or primary person,
/// outlined otherwise — the monochrome stand-in for a highlight colour.
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    required this.name,
    this.size = 52,
    this.filled = false,
    this.ringed = false,
    super.key,
  });

  final String name;
  final double size;
  final bool filled;

  /// Draws a gap-and-ring around the avatar, used for the chosen stylist.
  final bool ringed;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      return '?';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: filled ? scheme.primary : scheme.surfaceContainerHighest,
        shape: BoxShape.circle,
        border: filled ? null : Border.all(color: scheme.outline),
        boxShadow: ringed
            ? [
                BoxShadow(color: scheme.surface, spreadRadius: 2.5),
                BoxShadow(color: scheme.primary, spreadRadius: 4),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          _initials,
          style: TextStyle(
            fontSize: size * 0.3,
            fontWeight: AppFontWeight.semiBold,
            color: filled ? scheme.onPrimary : scheme.onSurface,
          ),
        ),
      ),
    );
  }
}
