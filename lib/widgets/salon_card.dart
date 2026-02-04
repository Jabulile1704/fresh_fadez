import 'package:flutter/material.dart';
import '../models/salon.dart';
import '../utils/constants.dart';

class SalonCard extends StatelessWidget {
  final Salon salon;
  final VoidCallback onTap;

  const SalonCard({
    Key? key,
    required this.salon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Salon name and status
            Padding(
              padding: EdgeInsets.all(AppSpacing.medium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          salon.name,
                          style: TextStyle(
                            fontSize: AppFontSize.title,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppSpacing.small),
                        Text(
                          salon.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppFontSize.small,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.medium,
                      vertical: AppSpacing.small,
                    ),
                    decoration: BoxDecoration(
                      color: salon.isOpen
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: Text(
                      salon.isOpen ? 'Open' : 'Closed',
                      style: TextStyle(
                        color: salon.isOpen ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w600,
                        fontSize: AppFontSize.small,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Rating
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.medium),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 18,
                  ),
                  SizedBox(width: AppSpacing.small),
                  Text(
                    '${salon.rating} (${salon.reviewCount} reviews)',
                    style: TextStyle(
                      fontSize: AppFontSize.small,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.medium),
          ],
        ),
      ),
    );
  }
}