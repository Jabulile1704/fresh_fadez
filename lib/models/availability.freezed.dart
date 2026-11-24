// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'availability.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AvailableSlot {

 DateTime get startsAt; DateTime get endsAt; List<String> get stylistIds;
/// Create a copy of AvailableSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvailableSlotCopyWith<AvailableSlot> get copyWith => _$AvailableSlotCopyWithImpl<AvailableSlot>(this as AvailableSlot, _$identity);

  /// Serializes this AvailableSlot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AvailableSlot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvailableSlot&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&const DeepCollectionEquality().equals(other.stylistIds, _this.stylistIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AvailableSlot;
  return Object.hash(runtimeType,_this.startsAt,_this.endsAt,const DeepCollectionEquality().hash(_this.stylistIds));
}

@override
String toString() {
  final _this = this as AvailableSlot;
  return 'AvailableSlot(startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, stylistIds: ${_this.stylistIds})';
}


}

/// @nodoc
abstract mixin class $AvailableSlotCopyWith<$Res>  {
  factory $AvailableSlotCopyWith(AvailableSlot value, $Res Function(AvailableSlot) _then) = _$AvailableSlotCopyWithImpl;
@useResult
$Res call({
 DateTime startsAt, DateTime endsAt, List<String> stylistIds
});




}
/// @nodoc
class _$AvailableSlotCopyWithImpl<$Res>
    implements $AvailableSlotCopyWith<$Res> {
  _$AvailableSlotCopyWithImpl(this._self, this._then);

  final AvailableSlot _self;
  final $Res Function(AvailableSlot) _then;

/// Create a copy of AvailableSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startsAt = null,Object? endsAt = null,Object? stylistIds = null,}) {
  return _then(AvailableSlot(
startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,stylistIds: null == stylistIds ? _self.stylistIds : stylistIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AvailableSlot].
extension AvailableSlotPatterns on AvailableSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvailableSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvailableSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvailableSlot value)  $default,){
final _that = this;
switch (_that) {
case _AvailableSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvailableSlot value)?  $default,){
final _that = this;
switch (_that) {
case _AvailableSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime startsAt,  DateTime endsAt,  List<String> stylistIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvailableSlot() when $default != null:
return $default(_that.startsAt,_that.endsAt,_that.stylistIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime startsAt,  DateTime endsAt,  List<String> stylistIds)  $default,) {final _that = this;
switch (_that) {
case _AvailableSlot():
return $default(_that.startsAt,_that.endsAt,_that.stylistIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime startsAt,  DateTime endsAt,  List<String> stylistIds)?  $default,) {final _that = this;
switch (_that) {
case _AvailableSlot() when $default != null:
return $default(_that.startsAt,_that.endsAt,_that.stylistIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AvailableSlot extends AvailableSlot {
  const _AvailableSlot({required this.startsAt, required this.endsAt,  List<String> stylistIds = const <String>[]}): _stylistIds = stylistIds,super._();
  factory _AvailableSlot.fromJson(Map<String, dynamic> json) => _$AvailableSlotFromJson(json);

@override final  DateTime startsAt;
@override final  DateTime endsAt;
 final  List<String> _stylistIds;
@override@JsonKey() List<String> get stylistIds {
  if (_stylistIds is EqualUnmodifiableListView) return _stylistIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stylistIds);
}


/// Create a copy of AvailableSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailableSlotCopyWith<_AvailableSlot> get copyWith => __$AvailableSlotCopyWithImpl<_AvailableSlot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvailableSlotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvailableSlot&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&const DeepCollectionEquality().equals(other.stylistIds, _stylistIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,startsAt,endsAt,const DeepCollectionEquality().hash(_stylistIds));
}

@override
String toString() {
    return 'AvailableSlot(startsAt: $startsAt, endsAt: $endsAt, stylistIds: $stylistIds)';
}


}

/// @nodoc
abstract mixin class _$AvailableSlotCopyWith<$Res> implements $AvailableSlotCopyWith<$Res> {
  factory _$AvailableSlotCopyWith(_AvailableSlot value, $Res Function(_AvailableSlot) _then) = __$AvailableSlotCopyWithImpl;
@override @useResult
$Res call({
 DateTime startsAt, DateTime endsAt, List<String> stylistIds
});




}
/// @nodoc
class __$AvailableSlotCopyWithImpl<$Res>
    implements _$AvailableSlotCopyWith<$Res> {
  __$AvailableSlotCopyWithImpl(this._self, this._then);

  final _AvailableSlot _self;
  final $Res Function(_AvailableSlot) _then;

/// Create a copy of AvailableSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startsAt = null,Object? endsAt = null,Object? stylistIds = null,}) {
  return _then(_AvailableSlot(
startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,stylistIds: null == stylistIds ? _self._stylistIds : stylistIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$AvailabilityRules {

 int get slotStepMinutes; int get leadTimeMinutes; int get maxDaysAhead;
/// Create a copy of AvailabilityRules
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvailabilityRulesCopyWith<AvailabilityRules> get copyWith => _$AvailabilityRulesCopyWithImpl<AvailabilityRules>(this as AvailabilityRules, _$identity);

  /// Serializes this AvailabilityRules to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AvailabilityRules;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvailabilityRules&&(identical(other.slotStepMinutes, _this.slotStepMinutes) || other.slotStepMinutes == _this.slotStepMinutes)&&(identical(other.leadTimeMinutes, _this.leadTimeMinutes) || other.leadTimeMinutes == _this.leadTimeMinutes)&&(identical(other.maxDaysAhead, _this.maxDaysAhead) || other.maxDaysAhead == _this.maxDaysAhead));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AvailabilityRules;
  return Object.hash(runtimeType,_this.slotStepMinutes,_this.leadTimeMinutes,_this.maxDaysAhead);
}

@override
String toString() {
  final _this = this as AvailabilityRules;
  return 'AvailabilityRules(slotStepMinutes: ${_this.slotStepMinutes}, leadTimeMinutes: ${_this.leadTimeMinutes}, maxDaysAhead: ${_this.maxDaysAhead})';
}


}

/// @nodoc
abstract mixin class $AvailabilityRulesCopyWith<$Res>  {
  factory $AvailabilityRulesCopyWith(AvailabilityRules value, $Res Function(AvailabilityRules) _then) = _$AvailabilityRulesCopyWithImpl;
@useResult
$Res call({
 int slotStepMinutes, int leadTimeMinutes, int maxDaysAhead
});




}
/// @nodoc
class _$AvailabilityRulesCopyWithImpl<$Res>
    implements $AvailabilityRulesCopyWith<$Res> {
  _$AvailabilityRulesCopyWithImpl(this._self, this._then);

  final AvailabilityRules _self;
  final $Res Function(AvailabilityRules) _then;

/// Create a copy of AvailabilityRules
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slotStepMinutes = null,Object? leadTimeMinutes = null,Object? maxDaysAhead = null,}) {
  return _then(AvailabilityRules(
slotStepMinutes: null == slotStepMinutes ? _self.slotStepMinutes : slotStepMinutes // ignore: cast_nullable_to_non_nullable
as int,leadTimeMinutes: null == leadTimeMinutes ? _self.leadTimeMinutes : leadTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,maxDaysAhead: null == maxDaysAhead ? _self.maxDaysAhead : maxDaysAhead // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AvailabilityRules].
extension AvailabilityRulesPatterns on AvailabilityRules {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvailabilityRules value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvailabilityRules() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvailabilityRules value)  $default,){
final _that = this;
switch (_that) {
case _AvailabilityRules():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvailabilityRules value)?  $default,){
final _that = this;
switch (_that) {
case _AvailabilityRules() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int slotStepMinutes,  int leadTimeMinutes,  int maxDaysAhead)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvailabilityRules() when $default != null:
return $default(_that.slotStepMinutes,_that.leadTimeMinutes,_that.maxDaysAhead);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int slotStepMinutes,  int leadTimeMinutes,  int maxDaysAhead)  $default,) {final _that = this;
switch (_that) {
case _AvailabilityRules():
return $default(_that.slotStepMinutes,_that.leadTimeMinutes,_that.maxDaysAhead);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int slotStepMinutes,  int leadTimeMinutes,  int maxDaysAhead)?  $default,) {final _that = this;
switch (_that) {
case _AvailabilityRules() when $default != null:
return $default(_that.slotStepMinutes,_that.leadTimeMinutes,_that.maxDaysAhead);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AvailabilityRules implements AvailabilityRules {
  const _AvailabilityRules({this.slotStepMinutes = 15, this.leadTimeMinutes = 0, this.maxDaysAhead = 60});
  factory _AvailabilityRules.fromJson(Map<String, dynamic> json) => _$AvailabilityRulesFromJson(json);

@override@JsonKey() final  int slotStepMinutes;
@override@JsonKey() final  int leadTimeMinutes;
@override@JsonKey() final  int maxDaysAhead;

/// Create a copy of AvailabilityRules
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailabilityRulesCopyWith<_AvailabilityRules> get copyWith => __$AvailabilityRulesCopyWithImpl<_AvailabilityRules>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvailabilityRulesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvailabilityRules&&(identical(other.slotStepMinutes, slotStepMinutes) || other.slotStepMinutes == slotStepMinutes)&&(identical(other.leadTimeMinutes, leadTimeMinutes) || other.leadTimeMinutes == leadTimeMinutes)&&(identical(other.maxDaysAhead, maxDaysAhead) || other.maxDaysAhead == maxDaysAhead));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,slotStepMinutes,leadTimeMinutes,maxDaysAhead);
}

@override
String toString() {
    return 'AvailabilityRules(slotStepMinutes: $slotStepMinutes, leadTimeMinutes: $leadTimeMinutes, maxDaysAhead: $maxDaysAhead)';
}


}

/// @nodoc
abstract mixin class _$AvailabilityRulesCopyWith<$Res> implements $AvailabilityRulesCopyWith<$Res> {
  factory _$AvailabilityRulesCopyWith(_AvailabilityRules value, $Res Function(_AvailabilityRules) _then) = __$AvailabilityRulesCopyWithImpl;
@override @useResult
$Res call({
 int slotStepMinutes, int leadTimeMinutes, int maxDaysAhead
});




}
/// @nodoc
class __$AvailabilityRulesCopyWithImpl<$Res>
    implements _$AvailabilityRulesCopyWith<$Res> {
  __$AvailabilityRulesCopyWithImpl(this._self, this._then);

  final _AvailabilityRules _self;
  final $Res Function(_AvailabilityRules) _then;

/// Create a copy of AvailabilityRules
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slotStepMinutes = null,Object? leadTimeMinutes = null,Object? maxDaysAhead = null,}) {
  return _then(_AvailabilityRules(
slotStepMinutes: null == slotStepMinutes ? _self.slotStepMinutes : slotStepMinutes // ignore: cast_nullable_to_non_nullable
as int,leadTimeMinutes: null == leadTimeMinutes ? _self.leadTimeMinutes : leadTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,maxDaysAhead: null == maxDaysAhead ? _self.maxDaysAhead : maxDaysAhead // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AvailabilityService {

 String get id; String get name; int get durationMinutes; int get priceCents;
/// Create a copy of AvailabilityService
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvailabilityServiceCopyWith<AvailabilityService> get copyWith => _$AvailabilityServiceCopyWithImpl<AvailabilityService>(this as AvailabilityService, _$identity);

  /// Serializes this AvailabilityService to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AvailabilityService;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvailabilityService&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes)&&(identical(other.priceCents, _this.priceCents) || other.priceCents == _this.priceCents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AvailabilityService;
  return Object.hash(runtimeType,_this.id,_this.name,_this.durationMinutes,_this.priceCents);
}

@override
String toString() {
  final _this = this as AvailabilityService;
  return 'AvailabilityService(id: ${_this.id}, name: ${_this.name}, durationMinutes: ${_this.durationMinutes}, priceCents: ${_this.priceCents})';
}


}

/// @nodoc
abstract mixin class $AvailabilityServiceCopyWith<$Res>  {
  factory $AvailabilityServiceCopyWith(AvailabilityService value, $Res Function(AvailabilityService) _then) = _$AvailabilityServiceCopyWithImpl;
@useResult
$Res call({
 String id, String name, int durationMinutes, int priceCents
});




}
/// @nodoc
class _$AvailabilityServiceCopyWithImpl<$Res>
    implements $AvailabilityServiceCopyWith<$Res> {
  _$AvailabilityServiceCopyWithImpl(this._self, this._then);

  final AvailabilityService _self;
  final $Res Function(AvailabilityService) _then;

/// Create a copy of AvailabilityService
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? durationMinutes = null,Object? priceCents = null,}) {
  return _then(AvailabilityService(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AvailabilityService].
extension AvailabilityServicePatterns on AvailabilityService {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvailabilityService value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvailabilityService() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvailabilityService value)  $default,){
final _that = this;
switch (_that) {
case _AvailabilityService():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvailabilityService value)?  $default,){
final _that = this;
switch (_that) {
case _AvailabilityService() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int durationMinutes,  int priceCents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvailabilityService() when $default != null:
return $default(_that.id,_that.name,_that.durationMinutes,_that.priceCents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int durationMinutes,  int priceCents)  $default,) {final _that = this;
switch (_that) {
case _AvailabilityService():
return $default(_that.id,_that.name,_that.durationMinutes,_that.priceCents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int durationMinutes,  int priceCents)?  $default,) {final _that = this;
switch (_that) {
case _AvailabilityService() when $default != null:
return $default(_that.id,_that.name,_that.durationMinutes,_that.priceCents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AvailabilityService implements AvailabilityService {
  const _AvailabilityService({required this.id, required this.name, required this.durationMinutes, required this.priceCents});
  factory _AvailabilityService.fromJson(Map<String, dynamic> json) => _$AvailabilityServiceFromJson(json);

@override final  String id;
@override final  String name;
@override final  int durationMinutes;
@override final  int priceCents;

/// Create a copy of AvailabilityService
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailabilityServiceCopyWith<_AvailabilityService> get copyWith => __$AvailabilityServiceCopyWithImpl<_AvailabilityService>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvailabilityServiceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvailabilityService&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,durationMinutes,priceCents);
}

@override
String toString() {
    return 'AvailabilityService(id: $id, name: $name, durationMinutes: $durationMinutes, priceCents: $priceCents)';
}


}

/// @nodoc
abstract mixin class _$AvailabilityServiceCopyWith<$Res> implements $AvailabilityServiceCopyWith<$Res> {
  factory _$AvailabilityServiceCopyWith(_AvailabilityService value, $Res Function(_AvailabilityService) _then) = __$AvailabilityServiceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int durationMinutes, int priceCents
});




}
/// @nodoc
class __$AvailabilityServiceCopyWithImpl<$Res>
    implements _$AvailabilityServiceCopyWith<$Res> {
  __$AvailabilityServiceCopyWithImpl(this._self, this._then);

  final _AvailabilityService _self;
  final $Res Function(_AvailabilityService) _then;

/// Create a copy of AvailabilityService
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? durationMinutes = null,Object? priceCents = null,}) {
  return _then(_AvailabilityService(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Availability {

 String get date; AvailabilityService get service; List<AvailableSlot> get slots; UnavailableReason? get reason; AvailabilityRules get rules;
/// Create a copy of Availability
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvailabilityCopyWith<Availability> get copyWith => _$AvailabilityCopyWithImpl<Availability>(this as Availability, _$identity);

  /// Serializes this Availability to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Availability;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Availability&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.service, _this.service) || other.service == _this.service)&&const DeepCollectionEquality().equals(other.slots, _this.slots)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.rules, _this.rules) || other.rules == _this.rules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Availability;
  return Object.hash(runtimeType,_this.date,_this.service,const DeepCollectionEquality().hash(_this.slots),_this.reason,_this.rules);
}

@override
String toString() {
  final _this = this as Availability;
  return 'Availability(date: ${_this.date}, service: ${_this.service}, slots: ${_this.slots}, reason: ${_this.reason}, rules: ${_this.rules})';
}


}

/// @nodoc
abstract mixin class $AvailabilityCopyWith<$Res>  {
  factory $AvailabilityCopyWith(Availability value, $Res Function(Availability) _then) = _$AvailabilityCopyWithImpl;
@useResult
$Res call({
 String date, AvailabilityService service, List<AvailableSlot> slots, UnavailableReason? reason, AvailabilityRules rules
});


$AvailabilityServiceCopyWith<$Res> get service;$AvailabilityRulesCopyWith<$Res> get rules;

}
/// @nodoc
class _$AvailabilityCopyWithImpl<$Res>
    implements $AvailabilityCopyWith<$Res> {
  _$AvailabilityCopyWithImpl(this._self, this._then);

  final Availability _self;
  final $Res Function(Availability) _then;

/// Create a copy of Availability
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? service = null,Object? slots = null,Object? reason = freezed,Object? rules = null,}) {
  return _then(Availability(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,service: null == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as AvailabilityService,slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as List<AvailableSlot>,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as UnavailableReason?,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as AvailabilityRules,
  ));
}
/// Create a copy of Availability
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AvailabilityServiceCopyWith<$Res> get service {
  
  return $AvailabilityServiceCopyWith<$Res>(_self.service, (value) {
    return _then(_self.copyWith(service: value));
  });
}/// Create a copy of Availability
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AvailabilityRulesCopyWith<$Res> get rules {
  
  return $AvailabilityRulesCopyWith<$Res>(_self.rules, (value) {
    return _then(_self.copyWith(rules: value));
  });
}
}


/// Adds pattern-matching-related methods to [Availability].
extension AvailabilityPatterns on Availability {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Availability value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Availability() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Availability value)  $default,){
final _that = this;
switch (_that) {
case _Availability():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Availability value)?  $default,){
final _that = this;
switch (_that) {
case _Availability() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  AvailabilityService service,  List<AvailableSlot> slots,  UnavailableReason? reason,  AvailabilityRules rules)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Availability() when $default != null:
return $default(_that.date,_that.service,_that.slots,_that.reason,_that.rules);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  AvailabilityService service,  List<AvailableSlot> slots,  UnavailableReason? reason,  AvailabilityRules rules)  $default,) {final _that = this;
switch (_that) {
case _Availability():
return $default(_that.date,_that.service,_that.slots,_that.reason,_that.rules);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  AvailabilityService service,  List<AvailableSlot> slots,  UnavailableReason? reason,  AvailabilityRules rules)?  $default,) {final _that = this;
switch (_that) {
case _Availability() when $default != null:
return $default(_that.date,_that.service,_that.slots,_that.reason,_that.rules);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Availability extends Availability {
  const _Availability({required this.date, required this.service,  List<AvailableSlot> slots = const <AvailableSlot>[], this.reason, this.rules = const AvailabilityRules()}): _slots = slots,super._();
  factory _Availability.fromJson(Map<String, dynamic> json) => _$AvailabilityFromJson(json);

@override final  String date;
@override final  AvailabilityService service;
 final  List<AvailableSlot> _slots;
@override@JsonKey() List<AvailableSlot> get slots {
  if (_slots is EqualUnmodifiableListView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slots);
}

@override final  UnavailableReason? reason;
@override@JsonKey() final  AvailabilityRules rules;

/// Create a copy of Availability
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailabilityCopyWith<_Availability> get copyWith => __$AvailabilityCopyWithImpl<_Availability>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvailabilityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Availability&&(identical(other.date, date) || other.date == date)&&(identical(other.service, service) || other.service == service)&&const DeepCollectionEquality().equals(other.slots, _slots)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.rules, rules) || other.rules == rules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,service,const DeepCollectionEquality().hash(_slots),reason,rules);
}

@override
String toString() {
    return 'Availability(date: $date, service: $service, slots: $slots, reason: $reason, rules: $rules)';
}


}

/// @nodoc
abstract mixin class _$AvailabilityCopyWith<$Res> implements $AvailabilityCopyWith<$Res> {
  factory _$AvailabilityCopyWith(_Availability value, $Res Function(_Availability) _then) = __$AvailabilityCopyWithImpl;
@override @useResult
$Res call({
 String date, AvailabilityService service, List<AvailableSlot> slots, UnavailableReason? reason, AvailabilityRules rules
});


@override $AvailabilityServiceCopyWith<$Res> get service;@override $AvailabilityRulesCopyWith<$Res> get rules;

}
/// @nodoc
class __$AvailabilityCopyWithImpl<$Res>
    implements _$AvailabilityCopyWith<$Res> {
  __$AvailabilityCopyWithImpl(this._self, this._then);

  final _Availability _self;
  final $Res Function(_Availability) _then;

/// Create a copy of Availability
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? service = null,Object? slots = null,Object? reason = freezed,Object? rules = null,}) {
  return _then(_Availability(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,service: null == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as AvailabilityService,slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as List<AvailableSlot>,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as UnavailableReason?,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as AvailabilityRules,
  ));
}

/// Create a copy of Availability
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AvailabilityServiceCopyWith<$Res> get service {
  
  return $AvailabilityServiceCopyWith<$Res>(_self.service, (value) {
    return _then(_self.copyWith(service: value));
  });
}/// Create a copy of Availability
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AvailabilityRulesCopyWith<$Res> get rules {
  
  return $AvailabilityRulesCopyWith<$Res>(_self.rules, (value) {
    return _then(_self.copyWith(rules: value));
  });
}
}

// dart format on
