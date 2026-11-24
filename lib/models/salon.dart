import 'package:freezed_annotation/freezed_annotation.dart';

part 'salon.freezed.dart';
part 'salon.g.dart';

@freezed
abstract class BusinessHours with _$BusinessHours {
  const factory BusinessHours({
    required int weekday,
    @Default(false) bool isClosed,
    @Default(0) int openMinute,
    @Default(0) int closeMinute,
    @Default('') String openTime,
    @Default('') String closeTime,
  }) = _BusinessHours;

  factory BusinessHours.fromJson(Map<String, dynamic> json) =>
      _$BusinessHoursFromJson(json);
}

@freezed
abstract class SalonDetails with _$SalonDetails {
  const factory SalonDetails({
    @Default('Fresh Fadez') String name,
    @Default('') String address,
    @Default('') String phone,
    @Default('') String email,
  }) = _SalonDetails;

  factory SalonDetails.fromJson(Map<String, dynamic> json) =>
      _$SalonDetailsFromJson(json);
}

/// Booking rules the client needs so it can disable what the server would
/// reject anyway — closed days, dates beyond the window, slots inside the
/// lead time. The server still enforces all of it; this only saves the user
/// a pointless round trip.
@freezed
abstract class SalonRules with _$SalonRules {
  const factory SalonRules({
    @Default(15) int slotStepMinutes,
    @Default(0) int leadTimeMinutes,
    @Default(60) int maxDaysAhead,
    @Default(24) int cancellationWindowHours,
    @Default(0) int utcOffsetMinutes,
  }) = _SalonRules;

  factory SalonRules.fromJson(Map<String, dynamic> json) =>
      _$SalonRulesFromJson(json);
}

@freezed
abstract class BookingWindow with _$BookingWindow {
  const factory BookingWindow({
    @Default('') String firstDate,
    @Default('') String lastDate,
  }) = _BookingWindow;

  factory BookingWindow.fromJson(Map<String, dynamic> json) =>
      _$BookingWindowFromJson(json);
}

/// The `GET /salon` envelope: who we are, when we are open, and the rules.
@freezed
abstract class SalonInfo with _$SalonInfo {
  const factory SalonInfo({
    @Default(SalonDetails()) SalonDetails salon,
    @Default(<BusinessHours>[]) List<BusinessHours> businessHours,
    @Default(SalonRules()) SalonRules rules,
    @Default(BookingWindow()) BookingWindow bookingWindow,
  }) = _SalonInfo;

  const SalonInfo._();

  factory SalonInfo.fromJson(Map<String, dynamic> json) =>
      _$SalonInfoFromJson(json);

  bool isClosedOn(DateTime day) => businessHours.any(
    (hours) => hours.weekday == day.weekday % 7 && hours.isClosed,
  );
}
