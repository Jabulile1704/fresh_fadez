import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/service.dart';
import '../utils/constants.dart';
import '../widgets/service_row.dart';

/// The Services tab: the full price list, grouped by category.
class ServicesScreen extends StatelessWidget {
  const ServicesScreen({required this.onStartBooking, super.key});

  final void Function(Service service) onStartBooking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = SampleData.services
        .map((service) => service.category)
        .toSet()
        .toList();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.large,
          AppSpacing.large,
          AppSpacing.large,
          AppSpacing.navClearance,
        ),
        children: [
          Text('Services', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text(
            'Prices include VAT. Pay in the chair.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 26),
          for (final category in categories) ...[
            Text(category.toUpperCase(), style: theme.textTheme.labelSmall),
            const SizedBox(height: 6),
            for (final service in SampleData.services.where(
              (s) => s.category == category,
            ))
              ServiceRow(
                service: service,
                onTap: () => onStartBooking(service),
                showDivider:
                    service !=
                    SampleData.services
                        .where((s) => s.category == category)
                        .last,
              ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}
