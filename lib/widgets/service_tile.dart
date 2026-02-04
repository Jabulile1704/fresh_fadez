import 'package:flutter/material.dart';
import '../models/service.dart';
import '../utils/constants.dart';

class ServiceTile extends StatelessWidget {
  final Service service;
  final VoidCallback onTap;
  final bool isSelected;

  const ServiceTile({
    Key? key,
    required this.service,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: ListTile(
          title: Text(
            service.name,
            style: TextStyle(
              fontSize: AppFontSize.subtitle,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            service.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppFontSize.small,
              color: AppColors.textSecondary,
            ),
          ),
          trailing: isSelected
              ? Icon(Icons.check_circle, color: AppColors.primary)
              : null,
          onTap: onTap,
        ),
      ),
    );
  }
}