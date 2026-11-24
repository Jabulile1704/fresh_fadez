// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Service _$ServiceFromJson(Map<String, dynamic> json) => _Service(
  id: json['id'] as String,
  name: json['name'] as String,
  category: json['category'] as String,
  priceCents: (json['priceCents'] as num).toInt(),
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  description: json['description'] as String? ?? '',
  imageAsset: json['imageAsset'] as String?,
  active: json['active'] as bool? ?? true,
);

Map<String, dynamic> _$ServiceToJson(_Service instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': instance.category,
  'priceCents': instance.priceCents,
  'durationMinutes': instance.durationMinutes,
  'description': instance.description,
  'imageAsset': instance.imageAsset,
  'active': instance.active,
};
