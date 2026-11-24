import 'package:freezed_annotation/freezed_annotation.dart';

import 'service.dart';

part 'stylist.freezed.dart';
part 'stylist.g.dart';

/// A stylist's bookable profile, as `stylistPublic` returns it.
///
/// `fullName` is nullable on the wire because the profile hangs off a User
/// row that a departed stylist no longer has — their past appointments
/// survive, their bookable profile does not.
@freezed
abstract class Stylist with _$Stylist {
  const factory Stylist({
    required String id,
    required String userId,
    String? fullName,
    @Default('') String title,
    @Default('') String specialization,
    @Default('') String bio,
    @Default(0) int experienceYears,
    @Default(0) double rating,
    @Default(0) int reviewCount,
    String? imageAsset,
    @Default(true) bool active,
    @Default(<Service>[]) List<Service> services,
    @Default(<StylistSchedule>[]) List<StylistSchedule> schedule,
  }) = _Stylist;

  const Stylist._();

  factory Stylist.fromJson(Map<String, dynamic> json) =>
      _$StylistFromJson(json);

  String get displayName => fullName ?? 'Former stylist';

  String get firstName => displayName.split(RegExp(r'\s+')).first;

  bool performs(String serviceId) =>
      services.any((service) => service.id == serviceId);
}

/// One weekday of a stylist's working week. Minutes are from midnight local
/// time; the `HH:MM` labels come from the server so the app never has to
/// reimplement the salon's clock.
@freezed
abstract class StylistSchedule with _$StylistSchedule {
  const factory StylistSchedule({
    required int weekday,
    required int startMinute,
    required int endMinute,
    @Default('') String startTime,
    @Default('') String endTime,
  }) = _StylistSchedule;

  factory StylistSchedule.fromJson(Map<String, dynamic> json) =>
      _$StylistScheduleFromJson(json);
}
