// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BusinessHours _$BusinessHoursFromJson(Map<String, dynamic> json) =>
    _BusinessHours(
      weekday: (json['weekday'] as num).toInt(),
      isClosed: json['isClosed'] as bool? ?? false,
      openMinute: (json['openMinute'] as num?)?.toInt() ?? 0,
      closeMinute: (json['closeMinute'] as num?)?.toInt() ?? 0,
      openTime: json['openTime'] as String? ?? '',
      closeTime: json['closeTime'] as String? ?? '',
    );

Map<String, dynamic> _$BusinessHoursToJson(_BusinessHours instance) =>
    <String, dynamic>{
      'weekday': instance.weekday,
      'isClosed': instance.isClosed,
      'openMinute': instance.openMinute,
      'closeMinute': instance.closeMinute,
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
    };

_SalonDetails _$SalonDetailsFromJson(Map<String, dynamic> json) =>
    _SalonDetails(
      name: json['name'] as String? ?? 'Fresh Fadez',
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );

Map<String, dynamic> _$SalonDetailsToJson(_SalonDetails instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
    };

_SalonRules _$SalonRulesFromJson(Map<String, dynamic> json) => _SalonRules(
  slotStepMinutes: (json['slotStepMinutes'] as num?)?.toInt() ?? 15,
  leadTimeMinutes: (json['leadTimeMinutes'] as num?)?.toInt() ?? 0,
  maxDaysAhead: (json['maxDaysAhead'] as num?)?.toInt() ?? 60,
  cancellationWindowHours:
      (json['cancellationWindowHours'] as num?)?.toInt() ?? 24,
  utcOffsetMinutes: (json['utcOffsetMinutes'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SalonRulesToJson(_SalonRules instance) =>
    <String, dynamic>{
      'slotStepMinutes': instance.slotStepMinutes,
      'leadTimeMinutes': instance.leadTimeMinutes,
      'maxDaysAhead': instance.maxDaysAhead,
      'cancellationWindowHours': instance.cancellationWindowHours,
      'utcOffsetMinutes': instance.utcOffsetMinutes,
    };

_BookingWindow _$BookingWindowFromJson(Map<String, dynamic> json) =>
    _BookingWindow(
      firstDate: json['firstDate'] as String? ?? '',
      lastDate: json['lastDate'] as String? ?? '',
    );

Map<String, dynamic> _$BookingWindowToJson(_BookingWindow instance) =>
    <String, dynamic>{
      'firstDate': instance.firstDate,
      'lastDate': instance.lastDate,
    };

_SalonInfo _$SalonInfoFromJson(Map<String, dynamic> json) => _SalonInfo(
  salon: json['salon'] == null
      ? const SalonDetails()
      : SalonDetails.fromJson(json['salon'] as Map<String, dynamic>),
  businessHours:
      (json['businessHours'] as List<dynamic>?)
          ?.map((e) => BusinessHours.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <BusinessHours>[],
  rules: json['rules'] == null
      ? const SalonRules()
      : SalonRules.fromJson(json['rules'] as Map<String, dynamic>),
  bookingWindow: json['bookingWindow'] == null
      ? const BookingWindow()
      : BookingWindow.fromJson(json['bookingWindow'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SalonInfoToJson(_SalonInfo instance) =>
    <String, dynamic>{
      'salon': instance.salon,
      'businessHours': instance.businessHours,
      'rules': instance.rules,
      'bookingWindow': instance.bookingWindow,
    };
