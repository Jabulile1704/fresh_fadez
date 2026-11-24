import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/service.dart';
import '../utils/constants.dart';
import '../utils/money.dart';

/// One service in a list: icon tile, name, duration, price.
class ServiceRow extends StatelessWidget {
  const ServiceRow({
    required this.service,
    required this.onTap,
    this.showDivider = true,
    super.key,
  });

  final Service service;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(bottom: BorderSide(color: scheme.outlineVariant))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Icon(
                SampleData.iconFor(service.id),
                size: 20,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(width: AppSpacing.medium - 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontSize: AppFontSize.body,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    service.formattedDuration,
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            Text(
              Money.fromRand(service.price),
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: AppFontSize.body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
