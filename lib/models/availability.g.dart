// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AvailableSlot _$AvailableSlotFromJson(Map<String, dynamic> json) =>
    _AvailableSlot(
      startsAt: DateTime.parse(json['startsAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
      stylistIds:
          (json['stylistIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$AvailableSlotToJson(_AvailableSlot instance) =>
    <String, dynamic>{
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt.toIso8601String(),
      'stylistIds': instance.stylistIds,
    };

_AvailabilityRules _$AvailabilityRulesFromJson(Map<String, dynamic> json) =>
    _AvailabilityRules(
      slotStepMinutes: (json['slotStepMinutes'] as num?)?.toInt() ?? 15,
      leadTimeMinutes: (json['leadTimeMinutes'] as num?)?.toInt() ?? 0,
      maxDaysAhead: (json['maxDaysAhead'] as num?)?.toInt() ?? 60,
    );

Map<String, dynamic> _$AvailabilityRulesToJson(_AvailabilityRules instance) =>
    <String, dynamic>{
      'slotStepMinutes': instance.slotStepMinutes,
      'leadTimeMinutes': instance.leadTimeMinutes,
      'maxDaysAhead': instance.maxDaysAhead,
    };

_AvailabilityService _$AvailabilityServiceFromJson(Map<String, dynamic> json) =>
    _AvailabilityService(
      id: json['id'] as String,
      name: json['name'] as String,
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      priceCents: (json['priceCents'] as num).toInt(),
    );

Map<String, dynamic> _$AvailabilityServiceToJson(
  _AvailabilityService instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'durationMinutes': instance.durationMinutes,
  'priceCents': instance.priceCents,
};

_Availability _$AvailabilityFromJson(Map<String, dynamic> json) =>
    _Availability(
      date: json['date'] as String,
      service: AvailabilityService.fromJson(
        json['service'] as Map<String, dynamic>,
      ),
      slots:
          (json['slots'] as List<dynamic>?)
              ?.map((e) => AvailableSlot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AvailableSlot>[],
      reason: $enumDecodeNullable(_$UnavailableReasonEnumMap, json['reason']),
      rules: json['rules'] == null
          ? const AvailabilityRules()
          : AvailabilityRules.fromJson(json['rules'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AvailabilityToJson(_Availability instance) =>
    <String, dynamic>{
      'date': instance.date,
      'service': instance.service,
      'slots': instance.slots,
      'reason': _$UnavailableReasonEnumMap[instance.reason],
      'rules': instance.rules,
    };

const _$UnavailableReasonEnumMap = {
  UnavailableReason.salonClosed: 'SALON_CLOSED',
  UnavailableReason.noStylistForService: 'NO_STYLIST_FOR_SERVICE',
  UnavailableReason.noStylistWorking: 'NO_STYLIST_WORKING',
  UnavailableReason.fullyBooked: 'FULLY_BOOKED',
};
