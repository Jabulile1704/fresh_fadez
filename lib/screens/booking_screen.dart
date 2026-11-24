import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/booking_draft.dart';
import '../models/service.dart';
import '../models/stylist.dart';
import '../utils/constants.dart';
import '../utils/money.dart';
import '../widgets/avatar_circle.dart';
import '../widgets/glass_action_bar.dart';
import 'time_slots_screen.dart';

/// Step 1 of the booking flow: what, and who with.
///
/// This file was 0 bytes before the revamp — there was no booking flow at all.
class BookingScreen extends StatefulWidget {
  const BookingScreen({this.initialService, super.key});

  final Service? initialService;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late BookingDraft _draft = BookingDraft(service: widget.initialService);

  List<Stylist> get _eligibleStylists {
    final service = _draft.service;
    if (service == null) {
      return SampleData.stylists;
    }
    final matching = SampleData.stylistsFor(service.id);
    return matching.isEmpty ? SampleData.stylists : matching;
  }

  void _selectService(Service service) {
    setState(() {
      // Changing the service can invalidate the stylist, so clear it rather
      // than carry a stylist who does not perform the new service.
      final keepStylist =
          _draft.stylist != null &&
          SampleData.stylistsFor(service.id).contains(_draft.stylist);
      _draft = _draft.copyWith(service: service, clearStylist: !keepStylist);
    });
  }

  Future<void> _continue() async {
    final result = await Navigator.of(context).push<BookingDraft>(
      MaterialPageRoute<BookingDraft>(
        builder: (context) => TimeSlotsScreen(draft: _draft),
      ),
    );
    if (result == null || !mounted) {
      return;
    }
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final service = _draft.service;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: const BackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.large),
            child: Center(
              child: Text(
                'Step 1 of 2',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: AppFontWeight.semiBold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const _StepBar(step: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.large,
                AppSpacing.large,
                AppSpacing.large,
                170,
              ),
              children: [
                Text(
                  'What are we\ndoing today?',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 22),
                for (final option in SampleData.services)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ServiceOption(
                      service: option,
                      selected: option == service,
                      onTap: () => _selectService(option),
                    ),
                  ),
                const SizedBox(height: 14),
                Text('Who with?', style: theme.textTheme.titleMedium),
                const SizedBox(height: 13),
                SizedBox(
                  height: 92,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _AnyoneOption(
                        selected: _draft.stylist == null,
                        onTap: () => setState(
                          () => _draft = _draft.copyWith(clearStylist: true),
                        ),
                      ),
                      for (final stylist in _eligibleStylists)
                        _StylistOption(
                          stylist: stylist,
                          selected: _draft.stylist == stylist,
                          onTap: () => setState(
                            () => _draft = _draft.copyWith(stylist: stylist),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: GlassActionBar(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    service == null
                        ? AppMessages.selectService
                        : '${service.name} · ${service.formattedDuration}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                if (service != null)
                  Text(
                    Money.fromCents(service.priceCents),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 17,
                      fontWeight: AppFontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: service == null ? null : _continue,
              child: const Text('Pick a time'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepBar extends StatelessWidget {
  const _StepBar({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
      child: Row(
        children: [
          for (var i = 1; i <= 2; i++)
            Expanded(
              child: Container(
                height: 3,
                margin: EdgeInsets.only(right: i == 2 ? 0 : 6),
                decoration: BoxDecoration(
                  color: i <= step ? scheme.primary : scheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ServiceOption extends StatelessWidget {
  const _ServiceOption({
    required this.service,
    required this.selected,
    required this.onTap,
  });

  final Service service;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.medium),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(
            color: selected ? scheme.onSurface : scheme.outline,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 21,
              height: 21,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? scheme.onSurface : scheme.outline,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: scheme.onSurface,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 15.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${service.formattedDuration} · ${service.description}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.small),
            Text(
              Money.fromCents(service.priceCents),
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: AppFontSize.subtitle,
                fontWeight: AppFontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnyoneOption extends StatelessWidget {
  const _AnyoneOption({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? scheme.onSurface : scheme.outline,
                  width: selected ? 2 : 1.5,
                ),
              ),
              child: Icon(
                Icons.groups_outlined,
                size: 22,
                color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Anyone',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: selected
                    ? AppFontWeight.semiBold
                    : AppFontWeight.medium,
                color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StylistOption extends StatelessWidget {
  const _StylistOption({
    required this.stylist,
    required this.selected,
    required this.onTap,
  });

  final Stylist stylist;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            AvatarCircle(
              name: stylist.displayName,
              filled: selected,
              ringed: selected,
            ),
            const SizedBox(height: 7),
            Text(
              stylist.firstName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: selected
                    ? AppFontWeight.semiBold
                    : AppFontWeight.medium,
                color: selected
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
