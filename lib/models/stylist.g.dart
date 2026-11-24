// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stylist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Stylist _$StylistFromJson(Map<String, dynamic> json) => _Stylist(
  id: json['id'] as String,
  userId: json['userId'] as String,
  fullName: json['fullName'] as String?,
  title: json['title'] as String? ?? '',
  specialization: json['specialization'] as String? ?? '',
  bio: json['bio'] as String? ?? '',
  experienceYears: (json['experienceYears'] as num?)?.toInt() ?? 0,
  rating: (json['rating'] as num?)?.toDouble() ?? 0,
  reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
  imageAsset: json['imageAsset'] as String?,
  active: json['active'] as bool? ?? true,
  services:
      (json['services'] as List<dynamic>?)
          ?.map((e) => Service.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Service>[],
  schedule:
      (json['schedule'] as List<dynamic>?)
          ?.map((e) => StylistSchedule.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <StylistSchedule>[],
);

Map<String, dynamic> _$StylistToJson(_Stylist instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'fullName': instance.fullName,
  'title': instance.title,
  'specialization': instance.specialization,
  'bio': instance.bio,
  'experienceYears': instance.experienceYears,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'imageAsset': instance.imageAsset,
  'active': instance.active,
  'services': instance.services,
  'schedule': instance.schedule,
};

_StylistSchedule _$StylistScheduleFromJson(Map<String, dynamic> json) =>
    _StylistSchedule(
      weekday: (json['weekday'] as num).toInt(),
      startMinute: (json['startMinute'] as num).toInt(),
      endMinute: (json['endMinute'] as num).toInt(),
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
    );

Map<String, dynamic> _$StylistScheduleToJson(_StylistSchedule instance) =>
    <String, dynamic>{
      'weekday': instance.weekday,
      'startMinute': instance.startMinute,
      'endMinute': instance.endMinute,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };
