// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppointmentStylist {

 String get id; String? get fullName; String get title; String? get imageAsset;
/// Create a copy of AppointmentStylist
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentStylistCopyWith<AppointmentStylist> get copyWith => _$AppointmentStylistCopyWithImpl<AppointmentStylist>(this as AppointmentStylist, _$identity);

  /// Serializes this AppointmentStylist to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppointmentStylist;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentStylist&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.imageAsset, _this.imageAsset) || other.imageAsset == _this.imageAsset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppointmentStylist;
  return Object.hash(runtimeType,_this.id,_this.fullName,_this.title,_this.imageAsset);
}

@override
String toString() {
  final _this = this as AppointmentStylist;
  return 'AppointmentStylist(id: ${_this.id}, fullName: ${_this.fullName}, title: ${_this.title}, imageAsset: ${_this.imageAsset})';
}


}

/// @nodoc
abstract mixin class $AppointmentStylistCopyWith<$Res>  {
  factory $AppointmentStylistCopyWith(AppointmentStylist value, $Res Function(AppointmentStylist) _then) = _$AppointmentStylistCopyWithImpl;
@useResult
$Res call({
 String id, String? fullName, String title, String? imageAsset
});




}
/// @nodoc
class _$AppointmentStylistCopyWithImpl<$Res>
    implements $AppointmentStylistCopyWith<$Res> {
  _$AppointmentStylistCopyWithImpl(this._self, this._then);

  final AppointmentStylist _self;
  final $Res Function(AppointmentStylist) _then;

/// Create a copy of AppointmentStylist
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = freezed,Object? title = null,Object? imageAsset = freezed,}) {
  return _then(AppointmentStylist(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageAsset: freezed == imageAsset ? _self.imageAsset : imageAsset // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppointmentStylist].
extension AppointmentStylistPatterns on AppointmentStylist {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentStylist value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentStylist() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentStylist value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentStylist():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentStylist value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentStylist() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? fullName,  String title,  String? imageAsset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentStylist() when $default != null:
return $default(_that.id,_that.fullName,_that.title,_that.imageAsset);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? fullName,  String title,  String? imageAsset)  $default,) {final _that = this;
switch (_that) {
case _AppointmentStylist():
return $default(_that.id,_that.fullName,_that.title,_that.imageAsset);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? fullName,  String title,  String? imageAsset)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentStylist() when $default != null:
return $default(_that.id,_that.fullName,_that.title,_that.imageAsset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppointmentStylist implements AppointmentStylist {
  const _AppointmentStylist({required this.id, this.fullName, this.title = '', this.imageAsset});
  factory _AppointmentStylist.fromJson(Map<String, dynamic> json) => _$AppointmentStylistFromJson(json);

@override final  String id;
@override final  String? fullName;
@override@JsonKey() final  String title;
@override final  String? imageAsset;

/// Create a copy of AppointmentStylist
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentStylistCopyWith<_AppointmentStylist> get copyWith => __$AppointmentStylistCopyWithImpl<_AppointmentStylist>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentStylistToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentStylist&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageAsset, imageAsset) || other.imageAsset == imageAsset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,fullName,title,imageAsset);
}

@override
String toString() {
    return 'AppointmentStylist(id: $id, fullName: $fullName, title: $title, imageAsset: $imageAsset)';
}


}

/// @nodoc
abstract mixin class _$AppointmentStylistCopyWith<$Res> implements $AppointmentStylistCopyWith<$Res> {
  factory _$AppointmentStylistCopyWith(_AppointmentStylist value, $Res Function(_AppointmentStylist) _then) = __$AppointmentStylistCopyWithImpl;
@override @useResult
$Res call({
 String id, String? fullName, String title, String? imageAsset
});




}
/// @nodoc
class __$AppointmentStylistCopyWithImpl<$Res>
    implements _$AppointmentStylistCopyWith<$Res> {
  __$AppointmentStylistCopyWithImpl(this._self, this._then);

  final _AppointmentStylist _self;
  final $Res Function(_AppointmentStylist) _then;

/// Create a copy of AppointmentStylist
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = freezed,Object? title = null,Object? imageAsset = freezed,}) {
  return _then(_AppointmentStylist(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageAsset: freezed == imageAsset ? _self.imageAsset : imageAsset // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AppointmentClient {

 String get id; String get fullName; String get phone; String get email;
/// Create a copy of AppointmentClient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentClientCopyWith<AppointmentClient> get copyWith => _$AppointmentClientCopyWithImpl<AppointmentClient>(this as AppointmentClient, _$identity);

  /// Serializes this AppointmentClient to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppointmentClient;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentClient&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.email, _this.email) || other.email == _this.email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppointmentClient;
  return Object.hash(runtimeType,_this.id,_this.fullName,_this.phone,_this.email);
}

@override
String toString() {
  final _this = this as AppointmentClient;
  return 'AppointmentClient(id: ${_this.id}, fullName: ${_this.fullName}, phone: ${_this.phone}, email: ${_this.email})';
}


}

/// @nodoc
abstract mixin class $AppointmentClientCopyWith<$Res>  {
  factory $AppointmentClientCopyWith(AppointmentClient value, $Res Function(AppointmentClient) _then) = _$AppointmentClientCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String phone, String email
});




}
/// @nodoc
class _$AppointmentClientCopyWithImpl<$Res>
    implements $AppointmentClientCopyWith<$Res> {
  _$AppointmentClientCopyWithImpl(this._self, this._then);

  final AppointmentClient _self;
  final $Res Function(AppointmentClient) _then;

/// Create a copy of AppointmentClient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? phone = null,Object? email = null,}) {
  return _then(AppointmentClient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppointmentClient].
extension AppointmentClientPatterns on AppointmentClient {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentClient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentClient() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentClient value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentClient():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentClient value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentClient() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  String phone,  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentClient() when $default != null:
return $default(_that.id,_that.fullName,_that.phone,_that.email);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  String phone,  String email)  $default,) {final _that = this;
switch (_that) {
case _AppointmentClient():
return $default(_that.id,_that.fullName,_that.phone,_that.email);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  String phone,  String email)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentClient() when $default != null:
return $default(_that.id,_that.fullName,_that.phone,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppointmentClient implements AppointmentClient {
  const _AppointmentClient({required this.id, required this.fullName, this.phone = '', this.email = ''});
  factory _AppointmentClient.fromJson(Map<String, dynamic> json) => _$AppointmentClientFromJson(json);

@override final  String id;
@override final  String fullName;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String email;

/// Create a copy of AppointmentClient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentClientCopyWith<_AppointmentClient> get copyWith => __$AppointmentClientCopyWithImpl<_AppointmentClient>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentClientToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentClient&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,fullName,phone,email);
}

@override
String toString() {
    return 'AppointmentClient(id: $id, fullName: $fullName, phone: $phone, email: $email)';
}


}

/// @nodoc
abstract mixin class _$AppointmentClientCopyWith<$Res> implements $AppointmentClientCopyWith<$Res> {
  factory _$AppointmentClientCopyWith(_AppointmentClient value, $Res Function(_AppointmentClient) _then) = __$AppointmentClientCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String phone, String email
});




}
/// @nodoc
class __$AppointmentClientCopyWithImpl<$Res>
    implements _$AppointmentClientCopyWith<$Res> {
  __$AppointmentClientCopyWithImpl(this._self, this._then);

  final _AppointmentClient _self;
  final $Res Function(_AppointmentClient) _then;

/// Create a copy of AppointmentClient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? phone = null,Object? email = null,}) {
  return _then(_AppointmentClient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Appointment {

 String get id; AppointmentStatus get status; DateTime get startsAt; DateTime get endsAt; int get durationMinutes; int get priceCents; String get serviceId; String get stylistId; String get userId; String get notes; DateTime? get createdAt; DateTime? get cancelledAt; String? get cancellationReason; Service? get service; AppointmentStylist? get stylist; AppointmentClient? get client;
/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentCopyWith<Appointment> get copyWith => _$AppointmentCopyWithImpl<Appointment>(this as Appointment, _$identity);

  /// Serializes this Appointment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Appointment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Appointment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes)&&(identical(other.priceCents, _this.priceCents) || other.priceCents == _this.priceCents)&&(identical(other.serviceId, _this.serviceId) || other.serviceId == _this.serviceId)&&(identical(other.stylistId, _this.stylistId) || other.stylistId == _this.stylistId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.cancelledAt, _this.cancelledAt) || other.cancelledAt == _this.cancelledAt)&&(identical(other.cancellationReason, _this.cancellationReason) || other.cancellationReason == _this.cancellationReason)&&(identical(other.service, _this.service) || other.service == _this.service)&&(identical(other.stylist, _this.stylist) || other.stylist == _this.stylist)&&(identical(other.client, _this.client) || other.client == _this.client));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Appointment;
  return Object.hash(runtimeType,_this.id,_this.status,_this.startsAt,_this.endsAt,_this.durationMinutes,_this.priceCents,_this.serviceId,_this.stylistId,_this.userId,_this.notes,_this.createdAt,_this.cancelledAt,_this.cancellationReason,_this.service,_this.stylist,_this.client);
}

@override
String toString() {
  final _this = this as Appointment;
  return 'Appointment(id: ${_this.id}, status: ${_this.status}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, durationMinutes: ${_this.durationMinutes}, priceCents: ${_this.priceCents}, serviceId: ${_this.serviceId}, stylistId: ${_this.stylistId}, userId: ${_this.userId}, notes: ${_this.notes}, createdAt: ${_this.createdAt}, cancelledAt: ${_this.cancelledAt}, cancellationReason: ${_this.cancellationReason}, service: ${_this.service}, stylist: ${_this.stylist}, client: ${_this.client})';
}


}

/// @nodoc
abstract mixin class $AppointmentCopyWith<$Res>  {
  factory $AppointmentCopyWith(Appointment value, $Res Function(Appointment) _then) = _$AppointmentCopyWithImpl;
@useResult
$Res call({
 String id, AppointmentStatus status, DateTime startsAt, DateTime endsAt, int durationMinutes, int priceCents, String serviceId, String stylistId, String userId, String notes, DateTime? createdAt, DateTime? cancelledAt, String? cancellationReason, Service? service, AppointmentStylist? stylist, AppointmentClient? client
});


$ServiceCopyWith<$Res>? get service;$AppointmentStylistCopyWith<$Res>? get stylist;$AppointmentClientCopyWith<$Res>? get client;

}
/// @nodoc
class _$AppointmentCopyWithImpl<$Res>
    implements $AppointmentCopyWith<$Res> {
  _$AppointmentCopyWithImpl(this._self, this._then);

  final Appointment _self;
  final $Res Function(Appointment) _then;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? startsAt = null,Object? endsAt = null,Object? durationMinutes = null,Object? priceCents = null,Object? serviceId = null,Object? stylistId = null,Object? userId = null,Object? notes = null,Object? createdAt = freezed,Object? cancelledAt = freezed,Object? cancellationReason = freezed,Object? service = freezed,Object? stylist = freezed,Object? client = freezed,}) {
  return _then(Appointment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppointmentStatus,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,stylistId: null == stylistId ? _self.stylistId : stylistId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as Service?,stylist: freezed == stylist ? _self.stylist : stylist // ignore: cast_nullable_to_non_nullable
as AppointmentStylist?,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as AppointmentClient?,
  ));
}
/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceCopyWith<$Res>? get service {
    if (_self.service == null) {
    return null;
  }

  return $ServiceCopyWith<$Res>(_self.service!, (value) {
    return _then(_self.copyWith(service: value));
  });
}/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentStylistCopyWith<$Res>? get stylist {
    if (_self.stylist == null) {
    return null;
  }

  return $AppointmentStylistCopyWith<$Res>(_self.stylist!, (value) {
    return _then(_self.copyWith(stylist: value));
  });
}/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentClientCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $AppointmentClientCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}
}


/// Adds pattern-matching-related methods to [Appointment].
extension AppointmentPatterns on Appointment {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Appointment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Appointment value)  $default,){
final _that = this;
switch (_that) {
case _Appointment():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Appointment value)?  $default,){
final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  AppointmentStatus status,  DateTime startsAt,  DateTime endsAt,  int durationMinutes,  int priceCents,  String serviceId,  String stylistId,  String userId,  String notes,  DateTime? createdAt,  DateTime? cancelledAt,  String? cancellationReason,  Service? service,  AppointmentStylist? stylist,  AppointmentClient? client)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that.id,_that.status,_that.startsAt,_that.endsAt,_that.durationMinutes,_that.priceCents,_that.serviceId,_that.stylistId,_that.userId,_that.notes,_that.createdAt,_that.cancelledAt,_that.cancellationReason,_that.service,_that.stylist,_that.client);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  AppointmentStatus status,  DateTime startsAt,  DateTime endsAt,  int durationMinutes,  int priceCents,  String serviceId,  String stylistId,  String userId,  String notes,  DateTime? createdAt,  DateTime? cancelledAt,  String? cancellationReason,  Service? service,  AppointmentStylist? stylist,  AppointmentClient? client)  $default,) {final _that = this;
switch (_that) {
case _Appointment():
return $default(_that.id,_that.status,_that.startsAt,_that.endsAt,_that.durationMinutes,_that.priceCents,_that.serviceId,_that.stylistId,_that.userId,_that.notes,_that.createdAt,_that.cancelledAt,_that.cancellationReason,_that.service,_that.stylist,_that.client);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  AppointmentStatus status,  DateTime startsAt,  DateTime endsAt,  int durationMinutes,  int priceCents,  String serviceId,  String stylistId,  String userId,  String notes,  DateTime? createdAt,  DateTime? cancelledAt,  String? cancellationReason,  Service? service,  AppointmentStylist? stylist,  AppointmentClient? client)?  $default,) {final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that.id,_that.status,_that.startsAt,_that.endsAt,_that.durationMinutes,_that.priceCents,_that.serviceId,_that.stylistId,_that.userId,_that.notes,_that.createdAt,_that.cancelledAt,_that.cancellationReason,_that.service,_that.stylist,_that.client);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Appointment extends Appointment {
  const _Appointment({required this.id, required this.status, required this.startsAt, required this.endsAt, required this.durationMinutes, required this.priceCents, required this.serviceId, required this.stylistId, required this.userId, this.notes = '', this.createdAt, this.cancelledAt, this.cancellationReason, this.service, this.stylist, this.client}): super._();
  factory _Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);

@override final  String id;
@override final  AppointmentStatus status;
@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  int durationMinutes;
@override final  int priceCents;
@override final  String serviceId;
@override final  String stylistId;
@override final  String userId;
@override@JsonKey() final  String notes;
@override final  DateTime? createdAt;
@override final  DateTime? cancelledAt;
@override final  String? cancellationReason;
@override final  Service? service;
@override final  AppointmentStylist? stylist;
@override final  AppointmentClient? client;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentCopyWith<_Appointment> get copyWith => __$AppointmentCopyWithImpl<_Appointment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Appointment&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.stylistId, stylistId) || other.stylistId == stylistId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.service, service) || other.service == service)&&(identical(other.stylist, stylist) || other.stylist == stylist)&&(identical(other.client, client) || other.client == client));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,status,startsAt,endsAt,durationMinutes,priceCents,serviceId,stylistId,userId,notes,createdAt,cancelledAt,cancellationReason,service,stylist,client);
}

@override
String toString() {
    return 'Appointment(id: $id, status: $status, startsAt: $startsAt, endsAt: $endsAt, durationMinutes: $durationMinutes, priceCents: $priceCents, serviceId: $serviceId, stylistId: $stylistId, userId: $userId, notes: $notes, createdAt: $createdAt, cancelledAt: $cancelledAt, cancellationReason: $cancellationReason, service: $service, stylist: $stylist, client: $client)';
}


}

/// @nodoc
abstract mixin class _$AppointmentCopyWith<$Res> implements $AppointmentCopyWith<$Res> {
  factory _$AppointmentCopyWith(_Appointment value, $Res Function(_Appointment) _then) = __$AppointmentCopyWithImpl;
@override @useResult
$Res call({
 String id, AppointmentStatus status, DateTime startsAt, DateTime endsAt, int durationMinutes, int priceCents, String serviceId, String stylistId, String userId, String notes, DateTime? createdAt, DateTime? cancelledAt, String? cancellationReason, Service? service, AppointmentStylist? stylist, AppointmentClient? client
});


@override $ServiceCopyWith<$Res>? get service;@override $AppointmentStylistCopyWith<$Res>? get stylist;@override $AppointmentClientCopyWith<$Res>? get client;

}
/// @nodoc
class __$AppointmentCopyWithImpl<$Res>
    implements _$AppointmentCopyWith<$Res> {
  __$AppointmentCopyWithImpl(this._self, this._then);

  final _Appointment _self;
  final $Res Function(_Appointment) _then;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? startsAt = null,Object? endsAt = null,Object? durationMinutes = null,Object? priceCents = null,Object? serviceId = null,Object? stylistId = null,Object? userId = null,Object? notes = null,Object? createdAt = freezed,Object? cancelledAt = freezed,Object? cancellationReason = freezed,Object? service = freezed,Object? stylist = freezed,Object? client = freezed,}) {
  return _then(_Appointment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppointmentStatus,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,stylistId: null == stylistId ? _self.stylistId : stylistId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as Service?,stylist: freezed == stylist ? _self.stylist : stylist // ignore: cast_nullable_to_non_nullable
as AppointmentStylist?,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as AppointmentClient?,
  ));
}

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceCopyWith<$Res>? get service {
    if (_self.service == null) {
    return null;
  }

  return $ServiceCopyWith<$Res>(_self.service!, (value) {
    return _then(_self.copyWith(service: value));
  });
}/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentStylistCopyWith<$Res>? get stylist {
    if (_self.stylist == null) {
    return null;
  }

  return $AppointmentStylistCopyWith<$Res>(_self.stylist!, (value) {
    return _then(_self.copyWith(stylist: value));
  });
}/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentClientCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $AppointmentClientCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}
}

// dart format on
