import 'service.dart';
import 'stylist.dart';

/// What the user has chosen so far while stepping through the booking flow.
///
/// Immutable and passed forward between the steps. Milestone 6 lifts this into
/// a Riverpod notifier so the flow survives a rebuild and can ask the server
/// to re-check a slot; the shape stays the same.
class BookingDraft {
  const BookingDraft({this.service, this.stylist, this.date, this.time});

  final Service? service;

  /// `null` means "anyone available" — a real choice, not a missing one.
  final Stylist? stylist;
  final DateTime? date;
  final String? time;

  bool get hasService => service != null;

  bool get isComplete => service != null && date != null && time != null;

  String get stylistLabel => stylist?.fullName ?? 'Anyone available';

  BookingDraft copyWith({
    Service? service,
    Stylist? stylist,
    DateTime? date,
    String? time,
    bool clearStylist = false,
    bool clearTime = false,
  }) => BookingDraft(
    service: service ?? this.service,
    stylist: clearStylist ? null : (stylist ?? this.stylist),
    date: date ?? this.date,
    time: clearTime ? null : (time ?? this.time),
  );

  @override
  String toString() =>
      'BookingDraft(service: ${service?.name}, stylist: $stylistLabel, '
      'date: $date, time: $time)';
}
