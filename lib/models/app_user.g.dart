// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  email: json['email'] as String,
  fullName: json['fullName'] as String,
  phone: json['phone'] as String? ?? '',
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.client,
  stylistId: json['stylistId'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'fullName': instance.fullName,
  'phone': instance.phone,
  'role': _$UserRoleEnumMap[instance.role]!,
  'stylistId': instance.stylistId,
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$UserRoleEnumMap = {
  UserRole.client: 'CLIENT',
  UserRole.stylist: 'STYLIST',
  UserRole.owner: 'OWNER',
};

_AuthSession _$AuthSessionFromJson(Map<String, dynamic> json) => _AuthSession(
  user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  accessTokenExpiresIn: (json['accessTokenExpiresIn'] as num?)?.toInt() ?? 0,
  refreshTokenExpiresAt: json['refreshTokenExpiresAt'] == null
      ? null
      : DateTime.parse(json['refreshTokenExpiresAt'] as String),
);

Map<String, dynamic> _$AuthSessionToJson(
  _AuthSession instance,
) => <String, dynamic>{
  'user': instance.user,
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'accessTokenExpiresIn': instance.accessTokenExpiresIn,
  'refreshTokenExpiresAt': instance.refreshTokenExpiresAt?.toIso8601String(),
};
