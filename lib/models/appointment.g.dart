// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppointmentStylist _$AppointmentStylistFromJson(Map<String, dynamic> json) =>
    _AppointmentStylist(
      id: json['id'] as String,
      fullName: json['fullName'] as String?,
      title: json['title'] as String? ?? '',
      imageAsset: json['imageAsset'] as String?,
    );

Map<String, dynamic> _$AppointmentStylistToJson(_AppointmentStylist instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'title': instance.title,
      'imageAsset': instance.imageAsset,
    };

_AppointmentClient _$AppointmentClientFromJson(Map<String, dynamic> json) =>
    _AppointmentClient(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );

Map<String, dynamic> _$AppointmentClientToJson(_AppointmentClient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
    };

_Appointment _$AppointmentFromJson(Map<String, dynamic> json) => _Appointment(
  id: json['id'] as String,
  status: $enumDecode(_$AppointmentStatusEnumMap, json['status']),
  startsAt: DateTime.parse(json['startsAt'] as String),
  endsAt: DateTime.parse(json['endsAt'] as String),
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  priceCents: (json['priceCents'] as num).toInt(),
  serviceId: json['serviceId'] as String,
  stylistId: json['stylistId'] as String,
  userId: json['userId'] as String,
  notes: json['notes'] as String? ?? '',
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  cancelledAt: json['cancelledAt'] == null
      ? null
      : DateTime.parse(json['cancelledAt'] as String),
  cancellationReason: json['cancellationReason'] as String?,
  service: json['service'] == null
      ? null
      : Service.fromJson(json['service'] as Map<String, dynamic>),
  stylist: json['stylist'] == null
      ? null
      : AppointmentStylist.fromJson(json['stylist'] as Map<String, dynamic>),
  client: json['client'] == null
      ? null
      : AppointmentClient.fromJson(json['client'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppointmentToJson(_Appointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$AppointmentStatusEnumMap[instance.status]!,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'priceCents': instance.priceCents,
      'serviceId': instance.serviceId,
      'stylistId': instance.stylistId,
      'userId': instance.userId,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
      'cancellationReason': instance.cancellationReason,
      'service': instance.service,
      'stylist': instance.stylist,
      'client': instance.client,
    };

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.pending: 'PENDING',
  AppointmentStatus.confirmed: 'CONFIRMED',
  AppointmentStatus.completed: 'COMPLETED',
  AppointmentStatus.cancelled: 'CANCELLED',
  AppointmentStatus.noShow: 'NO_SHOW',
};
