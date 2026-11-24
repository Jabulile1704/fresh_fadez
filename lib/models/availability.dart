import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'availability.freezed.dart';
part 'availability.g.dart';

/// Why there is nothing to offer, when there is nothing to offer.
///
/// The server sends this precisely so the app can say *why* a day is empty
/// instead of showing a blank grid and leaving the client to guess.
enum UnavailableReason {
  @JsonValue('SALON_CLOSED')
  salonClosed,
  @JsonValue('NO_STYLIST_FOR_SERVICE')
  noStylistForService,
  @JsonValue('NO_STYLIST_WORKING')
  noStylistWorking,
  @JsonValue('FULLY_BOOKED')
  fullyBooked;

  String get message => switch (this) {
    UnavailableReason.salonClosed => 'We are closed that day.',
    UnavailableReason.noStylistForService =>
      'Nobody here does that service yet.',
    UnavailableReason.noStylistWorking => 'Nobody is working that day.',
    UnavailableReason.fullyBooked => 'Fully booked — try another day.',
  };
}

@freezed
abstract class AvailableSlot with _$AvailableSlot {
  const factory AvailableSlot({
    required DateTime startsAt,
    required DateTime endsAt,
    @Default(<String>[]) List<String> stylistIds,
  }) = _AvailableSlot;

  const AvailableSlot._();

  factory AvailableSlot.fromJson(Map<String, dynamic> json) =>
      _$AvailableSlotFromJson(json);

  DateTime get localStart => startsAt.toLocal();

  /// `09:00` — the label the slot grid shows.
  String get label => DateFormat('HH:mm').format(localStart);

  bool get isMorning => localStart.hour < 12;
}

@freezed
abstract class AvailabilityRules with _$AvailabilityRules {
  const factory AvailabilityRules({
    @Default(15) int slotStepMinutes,
    @Default(0) int leadTimeMinutes,
    @Default(60) int maxDaysAhead,
  }) = _AvailabilityRules;

  factory AvailabilityRules.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityRulesFromJson(json);
}

@freezed
abstract class AvailabilityService with _$AvailabilityService {
  const factory AvailabilityService({
    required String id,
    required String name,
    required int durationMinutes,
    required int priceCents,
  }) = _AvailabilityService;

  factory AvailabilityService.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityServiceFromJson(json);
}

/// The whole `GET /availability` envelope.
@freezed
abstract class Availability with _$Availability {
  const factory Availability({
    required String date,
    required AvailabilityService service,
    @Default(<AvailableSlot>[]) List<AvailableSlot> slots,
    UnavailableReason? reason,
    @Default(AvailabilityRules()) AvailabilityRules rules,
  }) = _Availability;

  const Availability._();

  factory Availability.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityFromJson(json);

  bool get isEmpty => slots.isEmpty;

  List<AvailableSlot> get morning =>
      slots.where((slot) => slot.isMorning).toList();

  List<AvailableSlot> get afternoon =>
      slots.where((slot) => !slot.isMorning).toList();
}
