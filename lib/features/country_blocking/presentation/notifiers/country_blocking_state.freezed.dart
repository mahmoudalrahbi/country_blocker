// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'country_blocking_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CountryBlockingState {

 List<BlockedCountry> get blockedCountries; int get blockedCallsCount; bool get isBlockingActive; bool get isLoading; String? get errorMessage;
/// Create a copy of CountryBlockingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountryBlockingStateCopyWith<CountryBlockingState> get copyWith => _$CountryBlockingStateCopyWithImpl<CountryBlockingState>(this as CountryBlockingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CountryBlockingState&&const DeepCollectionEquality().equals(other.blockedCountries, blockedCountries)&&(identical(other.blockedCallsCount, blockedCallsCount) || other.blockedCallsCount == blockedCallsCount)&&(identical(other.isBlockingActive, isBlockingActive) || other.isBlockingActive == isBlockingActive)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(blockedCountries),blockedCallsCount,isBlockingActive,isLoading,errorMessage);

@override
String toString() {
  return 'CountryBlockingState(blockedCountries: $blockedCountries, blockedCallsCount: $blockedCallsCount, isBlockingActive: $isBlockingActive, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $CountryBlockingStateCopyWith<$Res>  {
  factory $CountryBlockingStateCopyWith(CountryBlockingState value, $Res Function(CountryBlockingState) _then) = _$CountryBlockingStateCopyWithImpl;
@useResult
$Res call({
 List<BlockedCountry> blockedCountries, int blockedCallsCount, bool isBlockingActive, bool isLoading, String? errorMessage
});




}
/// @nodoc
class _$CountryBlockingStateCopyWithImpl<$Res>
    implements $CountryBlockingStateCopyWith<$Res> {
  _$CountryBlockingStateCopyWithImpl(this._self, this._then);

  final CountryBlockingState _self;
  final $Res Function(CountryBlockingState) _then;

/// Create a copy of CountryBlockingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? blockedCountries = null,Object? blockedCallsCount = null,Object? isBlockingActive = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
blockedCountries: null == blockedCountries ? _self.blockedCountries : blockedCountries // ignore: cast_nullable_to_non_nullable
as List<BlockedCountry>,blockedCallsCount: null == blockedCallsCount ? _self.blockedCallsCount : blockedCallsCount // ignore: cast_nullable_to_non_nullable
as int,isBlockingActive: null == isBlockingActive ? _self.isBlockingActive : isBlockingActive // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CountryBlockingState].
extension CountryBlockingStatePatterns on CountryBlockingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CountryBlockingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CountryBlockingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CountryBlockingState value)  $default,){
final _that = this;
switch (_that) {
case _CountryBlockingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CountryBlockingState value)?  $default,){
final _that = this;
switch (_that) {
case _CountryBlockingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BlockedCountry> blockedCountries,  int blockedCallsCount,  bool isBlockingActive,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CountryBlockingState() when $default != null:
return $default(_that.blockedCountries,_that.blockedCallsCount,_that.isBlockingActive,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BlockedCountry> blockedCountries,  int blockedCallsCount,  bool isBlockingActive,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _CountryBlockingState():
return $default(_that.blockedCountries,_that.blockedCallsCount,_that.isBlockingActive,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BlockedCountry> blockedCountries,  int blockedCallsCount,  bool isBlockingActive,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _CountryBlockingState() when $default != null:
return $default(_that.blockedCountries,_that.blockedCallsCount,_that.isBlockingActive,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _CountryBlockingState implements CountryBlockingState {
  const _CountryBlockingState({final  List<BlockedCountry> blockedCountries = const [], this.blockedCallsCount = 0, this.isBlockingActive = true, this.isLoading = false, this.errorMessage}): _blockedCountries = blockedCountries;
  

 final  List<BlockedCountry> _blockedCountries;
@override@JsonKey() List<BlockedCountry> get blockedCountries {
  if (_blockedCountries is EqualUnmodifiableListView) return _blockedCountries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blockedCountries);
}

@override@JsonKey() final  int blockedCallsCount;
@override@JsonKey() final  bool isBlockingActive;
@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;

/// Create a copy of CountryBlockingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CountryBlockingStateCopyWith<_CountryBlockingState> get copyWith => __$CountryBlockingStateCopyWithImpl<_CountryBlockingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CountryBlockingState&&const DeepCollectionEquality().equals(other._blockedCountries, _blockedCountries)&&(identical(other.blockedCallsCount, blockedCallsCount) || other.blockedCallsCount == blockedCallsCount)&&(identical(other.isBlockingActive, isBlockingActive) || other.isBlockingActive == isBlockingActive)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_blockedCountries),blockedCallsCount,isBlockingActive,isLoading,errorMessage);

@override
String toString() {
  return 'CountryBlockingState(blockedCountries: $blockedCountries, blockedCallsCount: $blockedCallsCount, isBlockingActive: $isBlockingActive, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$CountryBlockingStateCopyWith<$Res> implements $CountryBlockingStateCopyWith<$Res> {
  factory _$CountryBlockingStateCopyWith(_CountryBlockingState value, $Res Function(_CountryBlockingState) _then) = __$CountryBlockingStateCopyWithImpl;
@override @useResult
$Res call({
 List<BlockedCountry> blockedCountries, int blockedCallsCount, bool isBlockingActive, bool isLoading, String? errorMessage
});




}
/// @nodoc
class __$CountryBlockingStateCopyWithImpl<$Res>
    implements _$CountryBlockingStateCopyWith<$Res> {
  __$CountryBlockingStateCopyWithImpl(this._self, this._then);

  final _CountryBlockingState _self;
  final $Res Function(_CountryBlockingState) _then;

/// Create a copy of CountryBlockingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? blockedCountries = null,Object? blockedCallsCount = null,Object? isBlockingActive = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_CountryBlockingState(
blockedCountries: null == blockedCountries ? _self._blockedCountries : blockedCountries // ignore: cast_nullable_to_non_nullable
as List<BlockedCountry>,blockedCallsCount: null == blockedCallsCount ? _self.blockedCallsCount : blockedCallsCount // ignore: cast_nullable_to_non_nullable
as int,isBlockingActive: null == isBlockingActive ? _self.isBlockingActive : isBlockingActive // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
