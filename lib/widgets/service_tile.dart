import 'package:flutter/material.dart';
import '../models/service.dart';
import '../utils/constants.dart';

class ServiceTile extends StatelessWidget {

  const ServiceTile({
    required this.service, required this.onTap, Key? key,
    this.isSelected = false,
  }) : super(key: key);
  final Service service;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
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
            style: const TextStyle(
              fontSize: AppFontSize.subtitle,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            service.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: AppFontSize.small,
              color: AppColors.textSecondary,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: AppColors.primary)
              : null,
          onTap: onTap,
        ),
      ),
    );
}
