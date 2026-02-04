import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SalonHeader extends StatelessWidget {
  final Map<String, dynamic> salonInfo;

  const SalonHeader({
    Key? key,
    required this.salonInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image or gradient placeholder
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.8),
                AppColors.primaryDark.withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.store_outlined,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),

        // Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
        ),

        // Content
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${salonInfo['rating']}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${salonInfo['reviews']} reviews)',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}