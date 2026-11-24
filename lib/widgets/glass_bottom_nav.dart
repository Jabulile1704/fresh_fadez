import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/constants.dart';

/// A tab in [GlassBottomNav].
class GlassNavItem {
  const GlassNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// The floating frosted-glass bottom bar.
///
/// It deliberately *floats* — inset from the sides and lifted off the bottom —
/// rather than sitting flush. Content scrolls underneath it, which is the only
/// thing that makes the blur legible; flush against a white page a blurred bar
/// just reads as flat grey.
///
/// Two details that are easy to get wrong:
///  * the shadow lives on an outer container, because a [ClipRRect] around the
///    [BackdropFilter] would clip the shadow away;
///  * the raised centre button sits outside that clip, in a [Stack] with
///    `clipBehavior: Clip.none`, or its top would be sliced off.
class GlassBottomNav extends StatelessWidget {
  const GlassBottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onBookPressed,
    super.key,
  });

  final List<GlassNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onBookPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    // Four tabs with a gap in the middle for the book button.
    final leading = items.take(2).toList();
    final trailing = items.skip(2).toList();

    return Padding(
      padding: EdgeInsets.only(
        left: AppGlass.sideInset,
        right: AppGlass.sideInset,
        bottom: AppGlass.bottomInset + bottomPadding * 0.5,
      ),
      child: SizedBox(
        height: AppGlass.barHeight + AppGlass.bookButtonLift,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppGlass.barHeight / 2),
                  ),
                  boxShadow: AppShadows.glassBar,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppGlass.barHeight / 2),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: AppGlass.blurSigma,
                      sigmaY: AppGlass.blurSigma,
                    ),
                    child: Container(
                      height: AppGlass.barHeight,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.glassFillDark
                            : AppColors.glassFillLight,
                        borderRadius: BorderRadius.circular(
                          AppGlass.barHeight / 2,
                        ),
                        border: Border.all(
                          color: isDark
                              ? AppColors.glassBorderDark
                              : AppColors.glassBorderLight,
                        ),
                      ),
                      child: Row(
                        children: [
                          for (var i = 0; i < leading.length; i++)
                            Expanded(child: _tab(context, scheme, i)),
                          const SizedBox(width: AppGlass.bookButtonSize + 8),
                          for (var i = 0; i < trailing.length; i++)
                            Expanded(
                              child: _tab(
                                context,
                                scheme,
                                leading.length + i,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: AppGlass.barHeight - AppGlass.bookButtonSize / 2 - 5,
              child: _bookButton(scheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(BuildContext context, ColorScheme scheme, int index) {
    final item = items[index];
    final selected = index == currentIndex;
    final color = selected ? scheme.onSurface : scheme.onSurfaceVariant;

    return Semantics(
      selected: selected,
      button: true,
      child: InkResponse(
        onTap: () => onTabSelected(index),
        radius: 34,
        child: SizedBox(
          height: AppGlass.barHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 21, color: color),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: AppFontSize.tiny,
                  fontWeight:
                      selected ? AppFontWeight.semiBold : AppFontWeight.medium,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookButton(ColorScheme scheme) => Semantics(
        button: true,
        label: 'Book an appointment',
        child: GestureDetector(
          onTap: onBookPressed,
          child: Container(
            width: AppGlass.bookButtonSize,
            height: AppGlass.bookButtonSize,
            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
              boxShadow: AppShadows.raisedButton,
            ),
            child: Icon(Icons.add_rounded, size: 27, color: scheme.onPrimary),
          ),
        ),
      );
}
