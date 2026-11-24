import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// Who is signed in. `stylistId` is non-null only for staff who have a
/// bookable profile, and it is what the staff shell keys off.
enum UserRole {
  @JsonValue('CLIENT')
  client,
  @JsonValue('STYLIST')
  stylist,
  @JsonValue('OWNER')
  owner;

  bool get isStaff => this != UserRole.client;
}

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String email,
    required String fullName,
    @Default('') String phone,
    @Default(UserRole.client) UserRole role,
    String? stylistId,
    DateTime? createdAt,
  }) = _AppUser;

  const AppUser._();

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  String get firstName => fullName.trim().split(RegExp(r'\s+')).first;
}

/// What `/auth/login`, `/auth/register` and `/auth/refresh` hand back.
@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required AppUser user,
    required String accessToken,
    required String refreshToken,
    @Default(0) int accessTokenExpiresIn,
    DateTime? refreshTokenExpiresAt,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);
}
