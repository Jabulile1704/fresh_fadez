import 'package:flutter/material.dart';
import '../models/salon.dart';
import '../utils/constants.dart';

class SpinningSalonCard extends StatefulWidget {

  const SpinningSalonCard({
    required this.salon, Key? key,
    this.onTap,
  }) : super(key: key);
  final Salon salon;
  final VoidCallback? onTap;

  @override
  State<SpinningSalonCard> createState() => _SpinningSalonCardState();
}

class _SpinningSalonCardState extends State<SpinningSalonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;
  late Animation<double> _spinAnimation;

  bool isFront = true; // tracks which side is showing

  @override
  void initState() {
    super.initState();

    _spinController = AnimationController(
      duration: const Duration(milliseconds: 600), // SLOW + SMOOTH
      vsync: this,
    );

    _spinAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _spinController,
        curve: Curves.easeInOutCubic, // SMOOTH FLIP CURVE
      ),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_spinController.isAnimating) {
      return;
    }

    if (isFront) {
      _spinController.forward();
    } else {
      _spinController.reverse();
    }

    setState(() => isFront = !isFront);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _spinAnimation,
        builder: (context, child) {
          final angle = _spinAnimation.value * 3.1415926535897932;

          final isBackVisible = _spinAnimation.value > 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateY(angle),
            child: isBackVisible ? _buildBackCard() : _buildFrontCard(),
          );
        },
      ),
    );

  // ---------- FRONT ----------
  Widget _buildFrontCard() => Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: AppColors.border,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.salon.name,
                        style: const TextStyle(
                          fontSize: AppFontSize.title,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.small),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.medium,
                          vertical: AppSpacing.small,
                        ),
                        decoration: BoxDecoration(
                          color: widget.salon.isOpen
                              ? AppColors.success.withValues(alpha: 0.2)
                              : AppColors.error.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                        ),
                        child: Text(
                          widget.salon.isOpen ? '🟢 Open Now' : '🔴 Closed',
                          style: TextStyle(
                            fontSize: AppFontSize.small,
                            fontWeight: FontWeight.w600,
                            color: widget.salon.isOpen
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.touch_app_rounded,
                    color: AppColors.primary.withValues(alpha: 0.5)),
              ],
            ),

            const SizedBox(height: AppSpacing.large),

            // Description
            Text(
              widget.salon.description,
              style: const TextStyle(
                fontSize: AppFontSize.body,
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: AppSpacing.large),

            Center(
              child: Text(
                '↻ Tap to flip',
                style: TextStyle(
                  fontSize: AppFontSize.small,
                  color: AppColors.primary.withValues(alpha: 0.6),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  // ---------- BACK ----------
  Widget _buildBackCard() => Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(3.1415926535897932),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Address',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: AppFontSize.small,
                ),
              ),
              Text(
                '${widget.salon.address}, ${widget.salon.city}',
                style:
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.large),
              const Center(
                child: Text(
                  '↻ Tap to flip back',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: AppFontSize.small,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
}
