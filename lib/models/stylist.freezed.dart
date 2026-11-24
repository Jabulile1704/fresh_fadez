// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stylist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Stylist {

 String get id; String get userId; String? get fullName; String get title; String get specialization; String get bio; int get experienceYears; double get rating; int get reviewCount; String? get imageAsset; bool get active; List<Service> get services; List<StylistSchedule> get schedule;
/// Create a copy of Stylist
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StylistCopyWith<Stylist> get copyWith => _$StylistCopyWithImpl<Stylist>(this as Stylist, _$identity);

  /// Serializes this Stylist to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Stylist;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Stylist&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.specialization, _this.specialization) || other.specialization == _this.specialization)&&(identical(other.bio, _this.bio) || other.bio == _this.bio)&&(identical(other.experienceYears, _this.experienceYears) || other.experienceYears == _this.experienceYears)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.reviewCount, _this.reviewCount) || other.reviewCount == _this.reviewCount)&&(identical(other.imageAsset, _this.imageAsset) || other.imageAsset == _this.imageAsset)&&(identical(other.active, _this.active) || other.active == _this.active)&&const DeepCollectionEquality().equals(other.services, _this.services)&&const DeepCollectionEquality().equals(other.schedule, _this.schedule));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Stylist;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.fullName,_this.title,_this.specialization,_this.bio,_this.experienceYears,_this.rating,_this.reviewCount,_this.imageAsset,_this.active,const DeepCollectionEquality().hash(_this.services),const DeepCollectionEquality().hash(_this.schedule));
}

@override
String toString() {
  final _this = this as Stylist;
  return 'Stylist(id: ${_this.id}, userId: ${_this.userId}, fullName: ${_this.fullName}, title: ${_this.title}, specialization: ${_this.specialization}, bio: ${_this.bio}, experienceYears: ${_this.experienceYears}, rating: ${_this.rating}, reviewCount: ${_this.reviewCount}, imageAsset: ${_this.imageAsset}, active: ${_this.active}, services: ${_this.services}, schedule: ${_this.schedule})';
}


}

/// @nodoc
abstract mixin class $StylistCopyWith<$Res>  {
  factory $StylistCopyWith(Stylist value, $Res Function(Stylist) _then) = _$StylistCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? fullName, String title, String specialization, String bio, int experienceYears, double rating, int reviewCount, String? imageAsset, bool active, List<Service> services, List<StylistSchedule> schedule
});




}
/// @nodoc
class _$StylistCopyWithImpl<$Res>
    implements $StylistCopyWith<$Res> {
  _$StylistCopyWithImpl(this._self, this._then);

  final Stylist _self;
  final $Res Function(Stylist) _then;

/// Create a copy of Stylist
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? fullName = freezed,Object? title = null,Object? specialization = null,Object? bio = null,Object? experienceYears = null,Object? rating = null,Object? reviewCount = null,Object? imageAsset = freezed,Object? active = null,Object? services = null,Object? schedule = null,}) {
  return _then(Stylist(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,specialization: null == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,experienceYears: null == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,imageAsset: freezed == imageAsset ? _self.imageAsset : imageAsset // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<Service>,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as List<StylistSchedule>,
  ));
}

}


/// Adds pattern-matching-related methods to [Stylist].
extension StylistPatterns on Stylist {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Stylist value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Stylist() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Stylist value)  $default,){
final _that = this;
switch (_that) {
case _Stylist():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Stylist value)?  $default,){
final _that = this;
switch (_that) {
case _Stylist() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? fullName,  String title,  String specialization,  String bio,  int experienceYears,  double rating,  int reviewCount,  String? imageAsset,  bool active,  List<Service> services,  List<StylistSchedule> schedule)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Stylist() when $default != null:
return $default(_that.id,_that.userId,_that.fullName,_that.title,_that.specialization,_that.bio,_that.experienceYears,_that.rating,_that.reviewCount,_that.imageAsset,_that.active,_that.services,_that.schedule);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? fullName,  String title,  String specialization,  String bio,  int experienceYears,  double rating,  int reviewCount,  String? imageAsset,  bool active,  List<Service> services,  List<StylistSchedule> schedule)  $default,) {final _that = this;
switch (_that) {
case _Stylist():
return $default(_that.id,_that.userId,_that.fullName,_that.title,_that.specialization,_that.bio,_that.experienceYears,_that.rating,_that.reviewCount,_that.imageAsset,_that.active,_that.services,_that.schedule);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? fullName,  String title,  String specialization,  String bio,  int experienceYears,  double rating,  int reviewCount,  String? imageAsset,  bool active,  List<Service> services,  List<StylistSchedule> schedule)?  $default,) {final _that = this;
switch (_that) {
case _Stylist() when $default != null:
return $default(_that.id,_that.userId,_that.fullName,_that.title,_that.specialization,_that.bio,_that.experienceYears,_that.rating,_that.reviewCount,_that.imageAsset,_that.active,_that.services,_that.schedule);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Stylist extends Stylist {
  const _Stylist({required this.id, required this.userId, this.fullName, this.title = '', this.specialization = '', this.bio = '', this.experienceYears = 0, this.rating = 0, this.reviewCount = 0, this.imageAsset, this.active = true,  List<Service> services = const <Service>[],  List<StylistSchedule> schedule = const <StylistSchedule>[]}): _services = services,_schedule = schedule,super._();
  factory _Stylist.fromJson(Map<String, dynamic> json) => _$StylistFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? fullName;
@override@JsonKey() final  String title;
@override@JsonKey() final  String specialization;
@override@JsonKey() final  String bio;
@override@JsonKey() final  int experienceYears;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int reviewCount;
@override final  String? imageAsset;
@override@JsonKey() final  bool active;
 final  List<Service> _services;
@override@JsonKey() List<Service> get services {
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_services);
}

 final  List<StylistSchedule> _schedule;
@override@JsonKey() List<StylistSchedule> get schedule {
  if (_schedule is EqualUnmodifiableListView) return _schedule;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedule);
}


/// Create a copy of Stylist
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StylistCopyWith<_Stylist> get copyWith => __$StylistCopyWithImpl<_Stylist>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StylistToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Stylist&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.title, title) || other.title == title)&&(identical(other.specialization, specialization) || other.specialization == specialization)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.imageAsset, imageAsset) || other.imageAsset == imageAsset)&&(identical(other.active, active) || other.active == active)&&const DeepCollectionEquality().equals(other.services, _services)&&const DeepCollectionEquality().equals(other.schedule, _schedule));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,fullName,title,specialization,bio,experienceYears,rating,reviewCount,imageAsset,active,const DeepCollectionEquality().hash(_services),const DeepCollectionEquality().hash(_schedule));
}

@override
String toString() {
    return 'Stylist(id: $id, userId: $userId, fullName: $fullName, title: $title, specialization: $specialization, bio: $bio, experienceYears: $experienceYears, rating: $rating, reviewCount: $reviewCount, imageAsset: $imageAsset, active: $active, services: $services, schedule: $schedule)';
}


}

/// @nodoc
abstract mixin class _$StylistCopyWith<$Res> implements $StylistCopyWith<$Res> {
  factory _$StylistCopyWith(_Stylist value, $Res Function(_Stylist) _then) = __$StylistCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? fullName, String title, String specialization, String bio, int experienceYears, double rating, int reviewCount, String? imageAsset, bool active, List<Service> services, List<StylistSchedule> schedule
});




}
/// @nodoc
class __$StylistCopyWithImpl<$Res>
    implements _$StylistCopyWith<$Res> {
  __$StylistCopyWithImpl(this._self, this._then);

  final _Stylist _self;
  final $Res Function(_Stylist) _then;

/// Create a copy of Stylist
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? fullName = freezed,Object? title = null,Object? specialization = null,Object? bio = null,Object? experienceYears = null,Object? rating = null,Object? reviewCount = null,Object? imageAsset = freezed,Object? active = null,Object? services = null,Object? schedule = null,}) {
  return _then(_Stylist(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,specialization: null == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,experienceYears: null == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,imageAsset: freezed == imageAsset ? _self.imageAsset : imageAsset // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<Service>,schedule: null == schedule ? _self._schedule : schedule // ignore: cast_nullable_to_non_nullable
as List<StylistSchedule>,
  ));
}


}


/// @nodoc
mixin _$StylistSchedule {

 int get weekday; int get startMinute; int get endMinute; String get startTime; String get endTime;
/// Create a copy of StylistSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StylistScheduleCopyWith<StylistSchedule> get copyWith => _$StylistScheduleCopyWithImpl<StylistSchedule>(this as StylistSchedule, _$identity);

  /// Serializes this StylistSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StylistSchedule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StylistSchedule&&(identical(other.weekday, _this.weekday) || other.weekday == _this.weekday)&&(identical(other.startMinute, _this.startMinute) || other.startMinute == _this.startMinute)&&(identical(other.endMinute, _this.endMinute) || other.endMinute == _this.endMinute)&&(identical(other.startTime, _this.startTime) || other.startTime == _this.startTime)&&(identical(other.endTime, _this.endTime) || other.endTime == _this.endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StylistSchedule;
  return Object.hash(runtimeType,_this.weekday,_this.startMinute,_this.endMinute,_this.startTime,_this.endTime);
}

@override
String toString() {
  final _this = this as StylistSchedule;
  return 'StylistSchedule(weekday: ${_this.weekday}, startMinute: ${_this.startMinute}, endMinute: ${_this.endMinute}, startTime: ${_this.startTime}, endTime: ${_this.endTime})';
}


}

/// @nodoc
abstract mixin class $StylistScheduleCopyWith<$Res>  {
  factory $StylistScheduleCopyWith(StylistSchedule value, $Res Function(StylistSchedule) _then) = _$StylistScheduleCopyWithImpl;
@useResult
$Res call({
 int weekday, int startMinute, int endMinute, String startTime, String endTime
});




}
/// @nodoc
class _$StylistScheduleCopyWithImpl<$Res>
    implements $StylistScheduleCopyWith<$Res> {
  _$StylistScheduleCopyWithImpl(this._self, this._then);

  final StylistSchedule _self;
  final $Res Function(StylistSchedule) _then;

/// Create a copy of StylistSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekday = null,Object? startMinute = null,Object? endMinute = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(StylistSchedule(
weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,startMinute: null == startMinute ? _self.startMinute : startMinute // ignore: cast_nullable_to_non_nullable
as int,endMinute: null == endMinute ? _self.endMinute : endMinute // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StylistSchedule].
extension StylistSchedulePatterns on StylistSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StylistSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StylistSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StylistSchedule value)  $default,){
final _that = this;
switch (_that) {
case _StylistSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StylistSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _StylistSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int weekday,  int startMinute,  int endMinute,  String startTime,  String endTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StylistSchedule() when $default != null:
return $default(_that.weekday,_that.startMinute,_that.endMinute,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int weekday,  int startMinute,  int endMinute,  String startTime,  String endTime)  $default,) {final _that = this;
switch (_that) {
case _StylistSchedule():
return $default(_that.weekday,_that.startMinute,_that.endMinute,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int weekday,  int startMinute,  int endMinute,  String startTime,  String endTime)?  $default,) {final _that = this;
switch (_that) {
case _StylistSchedule() when $default != null:
return $default(_that.weekday,_that.startMinute,_that.endMinute,_that.startTime,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StylistSchedule implements StylistSchedule {
  const _StylistSchedule({required this.weekday, required this.startMinute, required this.endMinute, this.startTime = '', this.endTime = ''});
  factory _StylistSchedule.fromJson(Map<String, dynamic> json) => _$StylistScheduleFromJson(json);

@override final  int weekday;
@override final  int startMinute;
@override final  int endMinute;
@override@JsonKey() final  String startTime;
@override@JsonKey() final  String endTime;

/// Create a copy of StylistSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StylistScheduleCopyWith<_StylistSchedule> get copyWith => __$StylistScheduleCopyWithImpl<_StylistSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StylistScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StylistSchedule&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.startMinute, startMinute) || other.startMinute == startMinute)&&(identical(other.endMinute, endMinute) || other.endMinute == endMinute)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,weekday,startMinute,endMinute,startTime,endTime);
}

@override
String toString() {
    return 'StylistSchedule(weekday: $weekday, startMinute: $startMinute, endMinute: $endMinute, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$StylistScheduleCopyWith<$Res> implements $StylistScheduleCopyWith<$Res> {
  factory _$StylistScheduleCopyWith(_StylistSchedule value, $Res Function(_StylistSchedule) _then) = __$StylistScheduleCopyWithImpl;
@override @useResult
$Res call({
 int weekday, int startMinute, int endMinute, String startTime, String endTime
});




}
/// @nodoc
class __$StylistScheduleCopyWithImpl<$Res>
    implements _$StylistScheduleCopyWith<$Res> {
  __$StylistScheduleCopyWithImpl(this._self, this._then);

  final _StylistSchedule _self;
  final $Res Function(_StylistSchedule) _then;

/// Create a copy of StylistSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekday = null,Object? startMinute = null,Object? endMinute = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_StylistSchedule(
weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,startMinute: null == startMinute ? _self.startMinute : startMinute // ignore: cast_nullable_to_non_nullable
as int,endMinute: null == endMinute ? _self.endMinute : endMinute // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
