// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BusinessHours {

 int get weekday; bool get isClosed; int get openMinute; int get closeMinute; String get openTime; String get closeTime;
/// Create a copy of BusinessHours
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessHoursCopyWith<BusinessHours> get copyWith => _$BusinessHoursCopyWithImpl<BusinessHours>(this as BusinessHours, _$identity);

  /// Serializes this BusinessHours to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BusinessHours;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessHours&&(identical(other.weekday, _this.weekday) || other.weekday == _this.weekday)&&(identical(other.isClosed, _this.isClosed) || other.isClosed == _this.isClosed)&&(identical(other.openMinute, _this.openMinute) || other.openMinute == _this.openMinute)&&(identical(other.closeMinute, _this.closeMinute) || other.closeMinute == _this.closeMinute)&&(identical(other.openTime, _this.openTime) || other.openTime == _this.openTime)&&(identical(other.closeTime, _this.closeTime) || other.closeTime == _this.closeTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BusinessHours;
  return Object.hash(runtimeType,_this.weekday,_this.isClosed,_this.openMinute,_this.closeMinute,_this.openTime,_this.closeTime);
}

@override
String toString() {
  final _this = this as BusinessHours;
  return 'BusinessHours(weekday: ${_this.weekday}, isClosed: ${_this.isClosed}, openMinute: ${_this.openMinute}, closeMinute: ${_this.closeMinute}, openTime: ${_this.openTime}, closeTime: ${_this.closeTime})';
}


}

/// @nodoc
abstract mixin class $BusinessHoursCopyWith<$Res>  {
  factory $BusinessHoursCopyWith(BusinessHours value, $Res Function(BusinessHours) _then) = _$BusinessHoursCopyWithImpl;
@useResult
$Res call({
 int weekday, bool isClosed, int openMinute, int closeMinute, String openTime, String closeTime
});




}
/// @nodoc
class _$BusinessHoursCopyWithImpl<$Res>
    implements $BusinessHoursCopyWith<$Res> {
  _$BusinessHoursCopyWithImpl(this._self, this._then);

  final BusinessHours _self;
  final $Res Function(BusinessHours) _then;

/// Create a copy of BusinessHours
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekday = null,Object? isClosed = null,Object? openMinute = null,Object? closeMinute = null,Object? openTime = null,Object? closeTime = null,}) {
  return _then(BusinessHours(
weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,openMinute: null == openMinute ? _self.openMinute : openMinute // ignore: cast_nullable_to_non_nullable
as int,closeMinute: null == closeMinute ? _self.closeMinute : closeMinute // ignore: cast_nullable_to_non_nullable
as int,openTime: null == openTime ? _self.openTime : openTime // ignore: cast_nullable_to_non_nullable
as String,closeTime: null == closeTime ? _self.closeTime : closeTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessHours].
extension BusinessHoursPatterns on BusinessHours {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessHours value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessHours() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessHours value)  $default,){
final _that = this;
switch (_that) {
case _BusinessHours():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessHours value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessHours() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int weekday,  bool isClosed,  int openMinute,  int closeMinute,  String openTime,  String closeTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessHours() when $default != null:
return $default(_that.weekday,_that.isClosed,_that.openMinute,_that.closeMinute,_that.openTime,_that.closeTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int weekday,  bool isClosed,  int openMinute,  int closeMinute,  String openTime,  String closeTime)  $default,) {final _that = this;
switch (_that) {
case _BusinessHours():
return $default(_that.weekday,_that.isClosed,_that.openMinute,_that.closeMinute,_that.openTime,_that.closeTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int weekday,  bool isClosed,  int openMinute,  int closeMinute,  String openTime,  String closeTime)?  $default,) {final _that = this;
switch (_that) {
case _BusinessHours() when $default != null:
return $default(_that.weekday,_that.isClosed,_that.openMinute,_that.closeMinute,_that.openTime,_that.closeTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BusinessHours implements BusinessHours {
  const _BusinessHours({required this.weekday, this.isClosed = false, this.openMinute = 0, this.closeMinute = 0, this.openTime = '', this.closeTime = ''});
  factory _BusinessHours.fromJson(Map<String, dynamic> json) => _$BusinessHoursFromJson(json);

@override final  int weekday;
@override@JsonKey() final  bool isClosed;
@override@JsonKey() final  int openMinute;
@override@JsonKey() final  int closeMinute;
@override@JsonKey() final  String openTime;
@override@JsonKey() final  String closeTime;

/// Create a copy of BusinessHours
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessHoursCopyWith<_BusinessHours> get copyWith => __$BusinessHoursCopyWithImpl<_BusinessHours>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BusinessHoursToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessHours&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed)&&(identical(other.openMinute, openMinute) || other.openMinute == openMinute)&&(identical(other.closeMinute, closeMinute) || other.closeMinute == closeMinute)&&(identical(other.openTime, openTime) || other.openTime == openTime)&&(identical(other.closeTime, closeTime) || other.closeTime == closeTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,weekday,isClosed,openMinute,closeMinute,openTime,closeTime);
}

@override
String toString() {
    return 'BusinessHours(weekday: $weekday, isClosed: $isClosed, openMinute: $openMinute, closeMinute: $closeMinute, openTime: $openTime, closeTime: $closeTime)';
}


}

/// @nodoc
abstract mixin class _$BusinessHoursCopyWith<$Res> implements $BusinessHoursCopyWith<$Res> {
  factory _$BusinessHoursCopyWith(_BusinessHours value, $Res Function(_BusinessHours) _then) = __$BusinessHoursCopyWithImpl;
@override @useResult
$Res call({
 int weekday, bool isClosed, int openMinute, int closeMinute, String openTime, String closeTime
});




}
/// @nodoc
class __$BusinessHoursCopyWithImpl<$Res>
    implements _$BusinessHoursCopyWith<$Res> {
  __$BusinessHoursCopyWithImpl(this._self, this._then);

  final _BusinessHours _self;
  final $Res Function(_BusinessHours) _then;

/// Create a copy of BusinessHours
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekday = null,Object? isClosed = null,Object? openMinute = null,Object? closeMinute = null,Object? openTime = null,Object? closeTime = null,}) {
  return _then(_BusinessHours(
weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,openMinute: null == openMinute ? _self.openMinute : openMinute // ignore: cast_nullable_to_non_nullable
as int,closeMinute: null == closeMinute ? _self.closeMinute : closeMinute // ignore: cast_nullable_to_non_nullable
as int,openTime: null == openTime ? _self.openTime : openTime // ignore: cast_nullable_to_non_nullable
as String,closeTime: null == closeTime ? _self.closeTime : closeTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SalonDetails {

 String get name; String get address; String get phone; String get email;
/// Create a copy of SalonDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalonDetailsCopyWith<SalonDetails> get copyWith => _$SalonDetailsCopyWithImpl<SalonDetails>(this as SalonDetails, _$identity);

  /// Serializes this SalonDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SalonDetails;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalonDetails&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.email, _this.email) || other.email == _this.email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SalonDetails;
  return Object.hash(runtimeType,_this.name,_this.address,_this.phone,_this.email);
}

@override
String toString() {
  final _this = this as SalonDetails;
  return 'SalonDetails(name: ${_this.name}, address: ${_this.address}, phone: ${_this.phone}, email: ${_this.email})';
}


}

/// @nodoc
abstract mixin class $SalonDetailsCopyWith<$Res>  {
  factory $SalonDetailsCopyWith(SalonDetails value, $Res Function(SalonDetails) _then) = _$SalonDetailsCopyWithImpl;
@useResult
$Res call({
 String name, String address, String phone, String email
});




}
/// @nodoc
class _$SalonDetailsCopyWithImpl<$Res>
    implements $SalonDetailsCopyWith<$Res> {
  _$SalonDetailsCopyWithImpl(this._self, this._then);

  final SalonDetails _self;
  final $Res Function(SalonDetails) _then;

/// Create a copy of SalonDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? address = null,Object? phone = null,Object? email = null,}) {
  return _then(SalonDetails(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SalonDetails].
extension SalonDetailsPatterns on SalonDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalonDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalonDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalonDetails value)  $default,){
final _that = this;
switch (_that) {
case _SalonDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalonDetails value)?  $default,){
final _that = this;
switch (_that) {
case _SalonDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String address,  String phone,  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalonDetails() when $default != null:
return $default(_that.name,_that.address,_that.phone,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String address,  String phone,  String email)  $default,) {final _that = this;
switch (_that) {
case _SalonDetails():
return $default(_that.name,_that.address,_that.phone,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String address,  String phone,  String email)?  $default,) {final _that = this;
switch (_that) {
case _SalonDetails() when $default != null:
return $default(_that.name,_that.address,_that.phone,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalonDetails implements SalonDetails {
  const _SalonDetails({this.name = 'Fresh Fadez', this.address = '', this.phone = '', this.email = ''});
  factory _SalonDetails.fromJson(Map<String, dynamic> json) => _$SalonDetailsFromJson(json);

@override@JsonKey() final  String name;
@override@JsonKey() final  String address;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String email;

/// Create a copy of SalonDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalonDetailsCopyWith<_SalonDetails> get copyWith => __$SalonDetailsCopyWithImpl<_SalonDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalonDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalonDetails&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,address,phone,email);
}

@override
String toString() {
    return 'SalonDetails(name: $name, address: $address, phone: $phone, email: $email)';
}


}

/// @nodoc
abstract mixin class _$SalonDetailsCopyWith<$Res> implements $SalonDetailsCopyWith<$Res> {
  factory _$SalonDetailsCopyWith(_SalonDetails value, $Res Function(_SalonDetails) _then) = __$SalonDetailsCopyWithImpl;
@override @useResult
$Res call({
 String name, String address, String phone, String email
});




}
/// @nodoc
class __$SalonDetailsCopyWithImpl<$Res>
    implements _$SalonDetailsCopyWith<$Res> {
  __$SalonDetailsCopyWithImpl(this._self, this._then);

  final _SalonDetails _self;
  final $Res Function(_SalonDetails) _then;

/// Create a copy of SalonDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? address = null,Object? phone = null,Object? email = null,}) {
  return _then(_SalonDetails(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SalonRules {

 int get slotStepMinutes; int get leadTimeMinutes; int get maxDaysAhead; int get cancellationWindowHours; int get utcOffsetMinutes;
/// Create a copy of SalonRules
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalonRulesCopyWith<SalonRules> get copyWith => _$SalonRulesCopyWithImpl<SalonRules>(this as SalonRules, _$identity);

  /// Serializes this SalonRules to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SalonRules;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalonRules&&(identical(other.slotStepMinutes, _this.slotStepMinutes) || other.slotStepMinutes == _this.slotStepMinutes)&&(identical(other.leadTimeMinutes, _this.leadTimeMinutes) || other.leadTimeMinutes == _this.leadTimeMinutes)&&(identical(other.maxDaysAhead, _this.maxDaysAhead) || other.maxDaysAhead == _this.maxDaysAhead)&&(identical(other.cancellationWindowHours, _this.cancellationWindowHours) || other.cancellationWindowHours == _this.cancellationWindowHours)&&(identical(other.utcOffsetMinutes, _this.utcOffsetMinutes) || other.utcOffsetMinutes == _this.utcOffsetMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SalonRules;
  return Object.hash(runtimeType,_this.slotStepMinutes,_this.leadTimeMinutes,_this.maxDaysAhead,_this.cancellationWindowHours,_this.utcOffsetMinutes);
}

@override
String toString() {
  final _this = this as SalonRules;
  return 'SalonRules(slotStepMinutes: ${_this.slotStepMinutes}, leadTimeMinutes: ${_this.leadTimeMinutes}, maxDaysAhead: ${_this.maxDaysAhead}, cancellationWindowHours: ${_this.cancellationWindowHours}, utcOffsetMinutes: ${_this.utcOffsetMinutes})';
}


}

/// @nodoc
abstract mixin class $SalonRulesCopyWith<$Res>  {
  factory $SalonRulesCopyWith(SalonRules value, $Res Function(SalonRules) _then) = _$SalonRulesCopyWithImpl;
@useResult
$Res call({
 int slotStepMinutes, int leadTimeMinutes, int maxDaysAhead, int cancellationWindowHours, int utcOffsetMinutes
});




}
/// @nodoc
class _$SalonRulesCopyWithImpl<$Res>
    implements $SalonRulesCopyWith<$Res> {
  _$SalonRulesCopyWithImpl(this._self, this._then);

  final SalonRules _self;
  final $Res Function(SalonRules) _then;

/// Create a copy of SalonRules
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slotStepMinutes = null,Object? leadTimeMinutes = null,Object? maxDaysAhead = null,Object? cancellationWindowHours = null,Object? utcOffsetMinutes = null,}) {
  return _then(SalonRules(
slotStepMinutes: null == slotStepMinutes ? _self.slotStepMinutes : slotStepMinutes // ignore: cast_nullable_to_non_nullable
as int,leadTimeMinutes: null == leadTimeMinutes ? _self.leadTimeMinutes : leadTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,maxDaysAhead: null == maxDaysAhead ? _self.maxDaysAhead : maxDaysAhead // ignore: cast_nullable_to_non_nullable
as int,cancellationWindowHours: null == cancellationWindowHours ? _self.cancellationWindowHours : cancellationWindowHours // ignore: cast_nullable_to_non_nullable
as int,utcOffsetMinutes: null == utcOffsetMinutes ? _self.utcOffsetMinutes : utcOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SalonRules].
extension SalonRulesPatterns on SalonRules {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalonRules value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalonRules() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalonRules value)  $default,){
final _that = this;
switch (_that) {
case _SalonRules():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalonRules value)?  $default,){
final _that = this;
switch (_that) {
case _SalonRules() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int slotStepMinutes,  int leadTimeMinutes,  int maxDaysAhead,  int cancellationWindowHours,  int utcOffsetMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalonRules() when $default != null:
return $default(_that.slotStepMinutes,_that.leadTimeMinutes,_that.maxDaysAhead,_that.cancellationWindowHours,_that.utcOffsetMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int slotStepMinutes,  int leadTimeMinutes,  int maxDaysAhead,  int cancellationWindowHours,  int utcOffsetMinutes)  $default,) {final _that = this;
switch (_that) {
case _SalonRules():
return $default(_that.slotStepMinutes,_that.leadTimeMinutes,_that.maxDaysAhead,_that.cancellationWindowHours,_that.utcOffsetMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int slotStepMinutes,  int leadTimeMinutes,  int maxDaysAhead,  int cancellationWindowHours,  int utcOffsetMinutes)?  $default,) {final _that = this;
switch (_that) {
case _SalonRules() when $default != null:
return $default(_that.slotStepMinutes,_that.leadTimeMinutes,_that.maxDaysAhead,_that.cancellationWindowHours,_that.utcOffsetMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalonRules implements SalonRules {
  const _SalonRules({this.slotStepMinutes = 15, this.leadTimeMinutes = 0, this.maxDaysAhead = 60, this.cancellationWindowHours = 24, this.utcOffsetMinutes = 0});
  factory _SalonRules.fromJson(Map<String, dynamic> json) => _$SalonRulesFromJson(json);

@override@JsonKey() final  int slotStepMinutes;
@override@JsonKey() final  int leadTimeMinutes;
@override@JsonKey() final  int maxDaysAhead;
@override@JsonKey() final  int cancellationWindowHours;
@override@JsonKey() final  int utcOffsetMinutes;

/// Create a copy of SalonRules
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalonRulesCopyWith<_SalonRules> get copyWith => __$SalonRulesCopyWithImpl<_SalonRules>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalonRulesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalonRules&&(identical(other.slotStepMinutes, slotStepMinutes) || other.slotStepMinutes == slotStepMinutes)&&(identical(other.leadTimeMinutes, leadTimeMinutes) || other.leadTimeMinutes == leadTimeMinutes)&&(identical(other.maxDaysAhead, maxDaysAhead) || other.maxDaysAhead == maxDaysAhead)&&(identical(other.cancellationWindowHours, cancellationWindowHours) || other.cancellationWindowHours == cancellationWindowHours)&&(identical(other.utcOffsetMinutes, utcOffsetMinutes) || other.utcOffsetMinutes == utcOffsetMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,slotStepMinutes,leadTimeMinutes,maxDaysAhead,cancellationWindowHours,utcOffsetMinutes);
}

@override
String toString() {
    return 'SalonRules(slotStepMinutes: $slotStepMinutes, leadTimeMinutes: $leadTimeMinutes, maxDaysAhead: $maxDaysAhead, cancellationWindowHours: $cancellationWindowHours, utcOffsetMinutes: $utcOffsetMinutes)';
}


}

/// @nodoc
abstract mixin class _$SalonRulesCopyWith<$Res> implements $SalonRulesCopyWith<$Res> {
  factory _$SalonRulesCopyWith(_SalonRules value, $Res Function(_SalonRules) _then) = __$SalonRulesCopyWithImpl;
@override @useResult
$Res call({
 int slotStepMinutes, int leadTimeMinutes, int maxDaysAhead, int cancellationWindowHours, int utcOffsetMinutes
});




}
/// @nodoc
class __$SalonRulesCopyWithImpl<$Res>
    implements _$SalonRulesCopyWith<$Res> {
  __$SalonRulesCopyWithImpl(this._self, this._then);

  final _SalonRules _self;
  final $Res Function(_SalonRules) _then;

/// Create a copy of SalonRules
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slotStepMinutes = null,Object? leadTimeMinutes = null,Object? maxDaysAhead = null,Object? cancellationWindowHours = null,Object? utcOffsetMinutes = null,}) {
  return _then(_SalonRules(
slotStepMinutes: null == slotStepMinutes ? _self.slotStepMinutes : slotStepMinutes // ignore: cast_nullable_to_non_nullable
as int,leadTimeMinutes: null == leadTimeMinutes ? _self.leadTimeMinutes : leadTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,maxDaysAhead: null == maxDaysAhead ? _self.maxDaysAhead : maxDaysAhead // ignore: cast_nullable_to_non_nullable
as int,cancellationWindowHours: null == cancellationWindowHours ? _self.cancellationWindowHours : cancellationWindowHours // ignore: cast_nullable_to_non_nullable
as int,utcOffsetMinutes: null == utcOffsetMinutes ? _self.utcOffsetMinutes : utcOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BookingWindow {

 String get firstDate; String get lastDate;
/// Create a copy of BookingWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingWindowCopyWith<BookingWindow> get copyWith => _$BookingWindowCopyWithImpl<BookingWindow>(this as BookingWindow, _$identity);

  /// Serializes this BookingWindow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BookingWindow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingWindow&&(identical(other.firstDate, _this.firstDate) || other.firstDate == _this.firstDate)&&(identical(other.lastDate, _this.lastDate) || other.lastDate == _this.lastDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BookingWindow;
  return Object.hash(runtimeType,_this.firstDate,_this.lastDate);
}

@override
String toString() {
  final _this = this as BookingWindow;
  return 'BookingWindow(firstDate: ${_this.firstDate}, lastDate: ${_this.lastDate})';
}


}

/// @nodoc
abstract mixin class $BookingWindowCopyWith<$Res>  {
  factory $BookingWindowCopyWith(BookingWindow value, $Res Function(BookingWindow) _then) = _$BookingWindowCopyWithImpl;
@useResult
$Res call({
 String firstDate, String lastDate
});




}
/// @nodoc
class _$BookingWindowCopyWithImpl<$Res>
    implements $BookingWindowCopyWith<$Res> {
  _$BookingWindowCopyWithImpl(this._self, this._then);

  final BookingWindow _self;
  final $Res Function(BookingWindow) _then;

/// Create a copy of BookingWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstDate = null,Object? lastDate = null,}) {
  return _then(BookingWindow(
firstDate: null == firstDate ? _self.firstDate : firstDate // ignore: cast_nullable_to_non_nullable
as String,lastDate: null == lastDate ? _self.lastDate : lastDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingWindow].
extension BookingWindowPatterns on BookingWindow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingWindow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingWindow value)  $default,){
final _that = this;
switch (_that) {
case _BookingWindow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingWindow value)?  $default,){
final _that = this;
switch (_that) {
case _BookingWindow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String firstDate,  String lastDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingWindow() when $default != null:
return $default(_that.firstDate,_that.lastDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String firstDate,  String lastDate)  $default,) {final _that = this;
switch (_that) {
case _BookingWindow():
return $default(_that.firstDate,_that.lastDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String firstDate,  String lastDate)?  $default,) {final _that = this;
switch (_that) {
case _BookingWindow() when $default != null:
return $default(_that.firstDate,_that.lastDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingWindow implements BookingWindow {
  const _BookingWindow({this.firstDate = '', this.lastDate = ''});
  factory _BookingWindow.fromJson(Map<String, dynamic> json) => _$BookingWindowFromJson(json);

@override@JsonKey() final  String firstDate;
@override@JsonKey() final  String lastDate;

/// Create a copy of BookingWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingWindowCopyWith<_BookingWindow> get copyWith => __$BookingWindowCopyWithImpl<_BookingWindow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingWindowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingWindow&&(identical(other.firstDate, firstDate) || other.firstDate == firstDate)&&(identical(other.lastDate, lastDate) || other.lastDate == lastDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,firstDate,lastDate);
}

@override
String toString() {
    return 'BookingWindow(firstDate: $firstDate, lastDate: $lastDate)';
}


}

/// @nodoc
abstract mixin class _$BookingWindowCopyWith<$Res> implements $BookingWindowCopyWith<$Res> {
  factory _$BookingWindowCopyWith(_BookingWindow value, $Res Function(_BookingWindow) _then) = __$BookingWindowCopyWithImpl;
@override @useResult
$Res call({
 String firstDate, String lastDate
});




}
/// @nodoc
class __$BookingWindowCopyWithImpl<$Res>
    implements _$BookingWindowCopyWith<$Res> {
  __$BookingWindowCopyWithImpl(this._self, this._then);

  final _BookingWindow _self;
  final $Res Function(_BookingWindow) _then;

/// Create a copy of BookingWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstDate = null,Object? lastDate = null,}) {
  return _then(_BookingWindow(
firstDate: null == firstDate ? _self.firstDate : firstDate // ignore: cast_nullable_to_non_nullable
as String,lastDate: null == lastDate ? _self.lastDate : lastDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SalonInfo {

 SalonDetails get salon; List<BusinessHours> get businessHours; SalonRules get rules; BookingWindow get bookingWindow;
/// Create a copy of SalonInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalonInfoCopyWith<SalonInfo> get copyWith => _$SalonInfoCopyWithImpl<SalonInfo>(this as SalonInfo, _$identity);

  /// Serializes this SalonInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SalonInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalonInfo&&(identical(other.salon, _this.salon) || other.salon == _this.salon)&&const DeepCollectionEquality().equals(other.businessHours, _this.businessHours)&&(identical(other.rules, _this.rules) || other.rules == _this.rules)&&(identical(other.bookingWindow, _this.bookingWindow) || other.bookingWindow == _this.bookingWindow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SalonInfo;
  return Object.hash(runtimeType,_this.salon,const DeepCollectionEquality().hash(_this.businessHours),_this.rules,_this.bookingWindow);
}

@override
String toString() {
  final _this = this as SalonInfo;
  return 'SalonInfo(salon: ${_this.salon}, businessHours: ${_this.businessHours}, rules: ${_this.rules}, bookingWindow: ${_this.bookingWindow})';
}


}

/// @nodoc
abstract mixin class $SalonInfoCopyWith<$Res>  {
  factory $SalonInfoCopyWith(SalonInfo value, $Res Function(SalonInfo) _then) = _$SalonInfoCopyWithImpl;
@useResult
$Res call({
 SalonDetails salon, List<BusinessHours> businessHours, SalonRules rules, BookingWindow bookingWindow
});


$SalonDetailsCopyWith<$Res> get salon;$SalonRulesCopyWith<$Res> get rules;$BookingWindowCopyWith<$Res> get bookingWindow;

}
/// @nodoc
class _$SalonInfoCopyWithImpl<$Res>
    implements $SalonInfoCopyWith<$Res> {
  _$SalonInfoCopyWithImpl(this._self, this._then);

  final SalonInfo _self;
  final $Res Function(SalonInfo) _then;

/// Create a copy of SalonInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? salon = null,Object? businessHours = null,Object? rules = null,Object? bookingWindow = null,}) {
  return _then(SalonInfo(
salon: null == salon ? _self.salon : salon // ignore: cast_nullable_to_non_nullable
as SalonDetails,businessHours: null == businessHours ? _self.businessHours : businessHours // ignore: cast_nullable_to_non_nullable
as List<BusinessHours>,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as SalonRules,bookingWindow: null == bookingWindow ? _self.bookingWindow : bookingWindow // ignore: cast_nullable_to_non_nullable
as BookingWindow,
  ));
}
/// Create a copy of SalonInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SalonDetailsCopyWith<$Res> get salon {
  
  return $SalonDetailsCopyWith<$Res>(_self.salon, (value) {
    return _then(_self.copyWith(salon: value));
  });
}/// Create a copy of SalonInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SalonRulesCopyWith<$Res> get rules {
  
  return $SalonRulesCopyWith<$Res>(_self.rules, (value) {
    return _then(_self.copyWith(rules: value));
  });
}/// Create a copy of SalonInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingWindowCopyWith<$Res> get bookingWindow {
  
  return $BookingWindowCopyWith<$Res>(_self.bookingWindow, (value) {
    return _then(_self.copyWith(bookingWindow: value));
  });
}
}


/// Adds pattern-matching-related methods to [SalonInfo].
extension SalonInfoPatterns on SalonInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalonInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalonInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalonInfo value)  $default,){
final _that = this;
switch (_that) {
case _SalonInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalonInfo value)?  $default,){
final _that = this;
switch (_that) {
case _SalonInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SalonDetails salon,  List<BusinessHours> businessHours,  SalonRules rules,  BookingWindow bookingWindow)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalonInfo() when $default != null:
return $default(_that.salon,_that.businessHours,_that.rules,_that.bookingWindow);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SalonDetails salon,  List<BusinessHours> businessHours,  SalonRules rules,  BookingWindow bookingWindow)  $default,) {final _that = this;
switch (_that) {
case _SalonInfo():
return $default(_that.salon,_that.businessHours,_that.rules,_that.bookingWindow);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SalonDetails salon,  List<BusinessHours> businessHours,  SalonRules rules,  BookingWindow bookingWindow)?  $default,) {final _that = this;
switch (_that) {
case _SalonInfo() when $default != null:
return $default(_that.salon,_that.businessHours,_that.rules,_that.bookingWindow);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalonInfo extends SalonInfo {
  const _SalonInfo({this.salon = const SalonDetails(),  List<BusinessHours> businessHours = const <BusinessHours>[], this.rules = const SalonRules(), this.bookingWindow = const BookingWindow()}): _businessHours = businessHours,super._();
  factory _SalonInfo.fromJson(Map<String, dynamic> json) => _$SalonInfoFromJson(json);

@override@JsonKey() final  SalonDetails salon;
 final  List<BusinessHours> _businessHours;
@override@JsonKey() List<BusinessHours> get businessHours {
  if (_businessHours is EqualUnmodifiableListView) return _businessHours;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_businessHours);
}

@override@JsonKey() final  SalonRules rules;
@override@JsonKey() final  BookingWindow bookingWindow;

/// Create a copy of SalonInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalonInfoCopyWith<_SalonInfo> get copyWith => __$SalonInfoCopyWithImpl<_SalonInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalonInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalonInfo&&(identical(other.salon, salon) || other.salon == salon)&&const DeepCollectionEquality().equals(other.businessHours, _businessHours)&&(identical(other.rules, rules) || other.rules == rules)&&(identical(other.bookingWindow, bookingWindow) || other.bookingWindow == bookingWindow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,salon,const DeepCollectionEquality().hash(_businessHours),rules,bookingWindow);
}

@override
String toString() {
    return 'SalonInfo(salon: $salon, businessHours: $businessHours, rules: $rules, bookingWindow: $bookingWindow)';
}


}

/// @nodoc
abstract mixin class _$SalonInfoCopyWith<$Res> implements $SalonInfoCopyWith<$Res> {
  factory _$SalonInfoCopyWith(_SalonInfo value, $Res Function(_SalonInfo) _then) = __$SalonInfoCopyWithImpl;
@override @useResult
$Res call({
 SalonDetails salon, List<BusinessHours> businessHours, SalonRules rules, BookingWindow bookingWindow
});


@override $SalonDetailsCopyWith<$Res> get salon;@override $SalonRulesCopyWith<$Res> get rules;@override $BookingWindowCopyWith<$Res> get bookingWindow;

}
/// @nodoc
class __$SalonInfoCopyWithImpl<$Res>
    implements _$SalonInfoCopyWith<$Res> {
  __$SalonInfoCopyWithImpl(this._self, this._then);

  final _SalonInfo _self;
  final $Res Function(_SalonInfo) _then;

/// Create a copy of SalonInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? salon = null,Object? businessHours = null,Object? rules = null,Object? bookingWindow = null,}) {
  return _then(_SalonInfo(
salon: null == salon ? _self.salon : salon // ignore: cast_nullable_to_non_nullable
as SalonDetails,businessHours: null == businessHours ? _self._businessHours : businessHours // ignore: cast_nullable_to_non_nullable
as List<BusinessHours>,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as SalonRules,bookingWindow: null == bookingWindow ? _self.bookingWindow : bookingWindow // ignore: cast_nullable_to_non_nullable
as BookingWindow,
  ));
}

/// Create a copy of SalonInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SalonDetailsCopyWith<$Res> get salon {
  
  return $SalonDetailsCopyWith<$Res>(_self.salon, (value) {
    return _then(_self.copyWith(salon: value));
  });
}/// Create a copy of SalonInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SalonRulesCopyWith<$Res> get rules {
  
  return $SalonRulesCopyWith<$Res>(_self.rules, (value) {
    return _then(_self.copyWith(rules: value));
  });
}/// Create a copy of SalonInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingWindowCopyWith<$Res> get bookingWindow {
  
  return $BookingWindowCopyWith<$Res>(_self.bookingWindow, (value) {
    return _then(_self.copyWith(bookingWindow: value));
  });
}
}

// dart format on
