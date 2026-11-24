import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import 'service.dart';

part 'appointment.freezed.dart';
part 'appointment.g.dart';

/// Mirrors the server's `AppointmentStatus` enum.
///
/// This replaced a bare `String` status. A typed enum is what lets the UI
/// switch exhaustively — a new state on the server becomes a compile error
/// here rather than a silently unhandled case.
enum AppointmentStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('CONFIRMED')
  confirmed,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('CANCELLED')
  cancelled,
  @JsonValue('NO_SHOW')
  noShow;

  /// Statuses that still occupy a slot in the diary.
  bool get isLive =>
      this == AppointmentStatus.pending || this == AppointmentStatus.confirmed;

  String get label => switch (this) {
    AppointmentStatus.pending => 'PENDING',
    AppointmentStatus.confirmed => 'CONFIRMED',
    AppointmentStatus.completed => 'DONE',
    AppointmentStatus.cancelled => 'CANCELLED',
    AppointmentStatus.noShow => 'NO SHOW',
  };
}

/// A stylist as embedded in an appointment — only what the card needs.
@freezed
abstract class AppointmentStylist with _$AppointmentStylist {
  const factory AppointmentStylist({
    required String id,
    String? fullName,
    @Default('') String title,
    String? imageAsset,
  }) = _AppointmentStylist;

  factory AppointmentStylist.fromJson(Map<String, dynamic> json) =>
      _$AppointmentStylistFromJson(json);
}

/// The client block, which the server includes only for staff callers.
@freezed
abstract class AppointmentClient with _$AppointmentClient {
  const factory AppointmentClient({
    required String id,
    required String fullName,
    @Default('') String phone,
    @Default('') String email,
  }) = _AppointmentClient;

  factory AppointmentClient.fromJson(Map<String, dynamic> json) =>
      _$AppointmentClientFromJson(json);
}

/// A booking.
///
/// `startsAt` and `endsAt` are real instants. The old model carried a
/// `DateTime` date plus a `"2:00 PM"` string, which made slot-collision
/// detection impossible and sorting unreliable.
@freezed
abstract class Appointment with _$Appointment {
  const factory Appointment({
    required String id,
    required AppointmentStatus status,
    required DateTime startsAt,
    required DateTime endsAt,
    required int durationMinutes,
    required int priceCents,
    required String serviceId,
    required String stylistId,
    required String userId,
    @Default('') String notes,
    DateTime? createdAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    Service? service,
    AppointmentStylist? stylist,
    AppointmentClient? client,
  }) = _Appointment;

  const Appointment._();

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  DateTime get localStart => startsAt.toLocal();

  bool get isUpcoming => status.isLive && localStart.isAfter(DateTime.now());

  bool get isPast =>
      status == AppointmentStatus.completed ||
      (status.isLive && localStart.isBefore(DateTime.now()));

  bool get isCancelled =>
      status == AppointmentStatus.cancelled ||
      status == AppointmentStatus.noShow;

  String get serviceName => service?.name ?? 'Appointment';

  String get stylistName => stylist?.fullName ?? 'Anyone available';

  /// `14:00`, in the device's local time.
  String get timeLabel => DateFormat('HH:mm').format(localStart);

  String get dateLabel => DateFormat('EEE d MMM').format(localStart);
}
