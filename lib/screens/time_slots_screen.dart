import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/sample_data.dart';
import '../models/booking_draft.dart';
import '../utils/constants.dart';
import '../utils/money.dart';
import '../widgets/glass_action_bar.dart';

/// Step 2 of the booking flow: which day, which slot.
///
/// The taken slots are hardcoded for now. When `GET /availability` is wired
/// up this screen asks the server instead, and the shape it reads — free,
/// chosen, taken — does not change.
class TimeSlotsScreen extends StatefulWidget {
  const TimeSlotsScreen({required this.draft, super.key});

  final BookingDraft draft;

  @override
  State<TimeSlotsScreen> createState() => _TimeSlotsScreenState();
}

class _TimeSlotsScreenState extends State<TimeSlotsScreen> {
  late BookingDraft _draft = widget.draft.date == null
      ? widget.draft.copyWith(date: _days.first)
      : widget.draft;

  static final List<DateTime> _days = _buildDays();

  static List<DateTime> _buildDays() {
    final today = DateTime.now();
    return [
      for (var i = 1; i <= 10; i++)
        DateTime(today.year, today.month, today.day + i),
    ];
  }

  // Sunday is the one day After8 is shut.
  bool _isClosed(DateTime day) => day.weekday == DateTime.sunday;

  void _selectDay(DateTime day) {
    if (_isClosed(day)) {
      return;
    }
    // A slot free on one day is not free on another, so the time resets.
    setState(() => _draft = _draft.copyWith(date: day, clearTime: true));
  }

  void _confirm() => Navigator.of(context).pop(_draft);

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
                'Step 2 of 2',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
            child: Row(
              children: [
                for (var i = 1; i <= 2; i++)
                  Expanded(
                    child: Container(
                      height: 3,
                      margin: EdgeInsets.only(right: i == 2 ? 0 : 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(
                top: AppSpacing.large,
                bottom: 180,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.large,
                  ),
                  child: Text(
                    'When suits you?',
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 74,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.large,
                    ),
                    itemCount: _days.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 9),
                    itemBuilder: (context, index) {
                      final day = _days[index];
                      return _DayChip(
                        day: day,
                        selected: _sameDay(day, _draft.date),
                        closed: _isClosed(day),
                        onTap: () => _selectDay(day),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28),
                if (_isClosed(_draft.date ?? _days.first))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.large,
                    ),
                    child: Text(
                      'We are closed that day.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
                else ...[
                  _SlotGroup(
                    title: 'Morning',
                    slots: SampleData.morningSlots,
                    selected: _draft.time,
                    onSelect: (slot) =>
                        setState(() => _draft = _draft.copyWith(time: slot)),
                  ),
                  const SizedBox(height: 24),
                  _SlotGroup(
                    title: 'Afternoon',
                    slots: SampleData.afternoonSlots,
                    selected: _draft.time,
                    onSelect: (slot) =>
                        setState(() => _draft = _draft.copyWith(time: slot)),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.large,
                    ),
                    child: _SlotLegend(),
                  ),
                ],
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _draft.time == null
                            ? AppMessages.selectTime
                            : '${DateFormat('EEE d MMM').format(_draft.date!)}'
                                ' · ${_draft.time}',
                        style: theme.textTheme.labelLarge,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${service?.name ?? ''} with '
                        '${_draft.stylistLabel.toLowerCase()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
                if (service != null)
                  Text(
                    Money.fromRand(service.price),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 17,
                      fontWeight: AppFontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _draft.isComplete ? _confirm : null,
              child: const Text('Confirm booking'),
            ),
          ],
        ),
      ),
    );
  }

  static bool _sameDay(DateTime a, DateTime? b) =>
      b != null && a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.day,
    required this.selected,
    required this.closed,
    required this.onTap,
  });

  final DateTime day;
  final bool selected;
  final bool closed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final Color background;
    final Color foreground;
    final Color mutedForeground;
    if (selected) {
      background = scheme.primary;
      foreground = scheme.onPrimary;
      mutedForeground = scheme.onPrimary.withValues(alpha: 0.7);
    } else if (closed) {
      background = scheme.surfaceContainerHighest;
      foreground = AppColors.grey400;
      mutedForeground = AppColors.grey400;
    } else {
      background = Colors.transparent;
      foreground = scheme.onSurface;
      mutedForeground = scheme.onSurfaceVariant;
    }

    return Semantics(
      selected: selected,
      enabled: !closed,
      child: GestureDetector(
        onTap: closed ? null : onTap,
        child: Container(
          width: 50,
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: background,
            border:
                selected || closed ? null : Border.all(color: scheme.outline),
            borderRadius: BorderRadius.circular(AppRadius.large - 2),
          ),
          child: Column(
            children: [
              Text(
                DateFormat('E').format(day).toUpperCase(),
                style: TextStyle(
                  fontSize: AppFontSize.caption,
                  fontWeight: AppFontWeight.medium,
                  color: mutedForeground,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                DateFormat('dd').format(day),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight:
                      selected ? AppFontWeight.bold : AppFontWeight.semiBold,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlotGroup extends StatelessWidget {
  const _SlotGroup({
    required this.title,
    required this.slots,
    required this.selected,
    required this.onSelect,
  });

  final String title;
  final List<String> slots;
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title.toUpperCase(), style: theme.textTheme.labelSmall),
              const SizedBox(width: 10),
              Expanded(child: Divider(color: theme.colorScheme.outlineVariant)),
            ],
          ),
          const SizedBox(height: 13),
          // A Wrap with explicit cell sizes rather than GridView's
          // childAspectRatio, which derived a row height from the available
          // width and left a large dead gap under the last row.
          LayoutBuilder(
            builder: (context, constraints) {
              final cellWidth = (constraints.maxWidth - 18) / 3;
              return Wrap(
                spacing: 9,
                runSpacing: 9,
                children: [
                  for (final slot in slots)
                    SizedBox(
                      width: cellWidth,
                      height: 46,
                      child: _SlotChip(
                        label: slot,
                        selected: slot == selected,
                        taken: SampleData.takenSlots.contains(slot),
                        onTap: () => onSelect(slot),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SlotChip extends StatelessWidget {
  const _SlotChip({
    required this.label,
    required this.selected,
    required this.taken,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool taken;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      selected: selected,
      enabled: !taken,
      button: true,
      child: GestureDetector(
        onTap: taken ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            color: selected
                ? scheme.primary
                : taken
                    ? scheme.surfaceContainerHighest
                    : null,
            border:
                selected || taken ? null : Border.all(color: scheme.outline),
            borderRadius: BorderRadius.circular(AppRadius.medium),
            boxShadow: selected ? AppShadows.card : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppFontSize.label + 1,
                fontWeight:
                    selected ? AppFontWeight.bold : AppFontWeight.semiBold,
                color: selected
                    ? scheme.onPrimary
                    : taken
                        ? AppColors.grey400
                        : scheme.onSurface,
                decoration: taken ? TextDecoration.lineThrough : null,
                decorationColor: AppColors.grey400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SlotLegend extends StatelessWidget {
  const _SlotLegend();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        _LegendKey(
          label: 'Free',
          decoration: BoxDecoration(
            border: Border.all(color: scheme.outline),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 16),
        _LegendKey(
          label: 'Chosen',
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 16),
        _LegendKey(
          label: 'Taken',
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

class _LegendKey extends StatelessWidget {
  const _LegendKey({required this.label, required this.decoration});

  final String label;
  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 13, height: 13, decoration: decoration),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: AppFontSize.caption,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
}
