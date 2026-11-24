import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/constants.dart';

/// The frosted bar pinned to the bottom of a booking step.
///
/// Same glass recipe as the bottom nav, but edge-to-edge with a hairline on
/// top instead of a floating pill — a step in a flow wants one unmissable
/// action, not navigation.
class GlassActionBar extends StatelessWidget {
  const GlassActionBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppGlass.blurSigma,
          sigmaY: AppGlass.blurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.glassFillDark : AppColors.glassFillLight,
            border: Border(
              top: BorderSide(
                color: isDark
                    ? AppColors.glassBorderDark
                    : AppColors.glassBorderLight,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.large,
                AppSpacing.medium,
                AppSpacing.large,
                AppSpacing.medium,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
