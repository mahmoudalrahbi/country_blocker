// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'country_blocking_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CountryBlockingState {
  List<BlockedCountry> get blockedCountries =>
      throw _privateConstructorUsedError;
  int get blockedCallsCount => throw _privateConstructorUsedError;
  bool get isBlockingActive => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of CountryBlockingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CountryBlockingStateCopyWith<CountryBlockingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CountryBlockingStateCopyWith<$Res> {
  factory $CountryBlockingStateCopyWith(
    CountryBlockingState value,
    $Res Function(CountryBlockingState) then,
  ) = _$CountryBlockingStateCopyWithImpl<$Res, CountryBlockingState>;
  @useResult
  $Res call({
    List<BlockedCountry> blockedCountries,
    int blockedCallsCount,
    bool isBlockingActive,
    bool isLoading,
    String? errorMessage,
  });
}

/// @nodoc
class _$CountryBlockingStateCopyWithImpl<
  $Res,
  $Val extends CountryBlockingState
>
    implements $CountryBlockingStateCopyWith<$Res> {
  _$CountryBlockingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CountryBlockingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blockedCountries = null,
    Object? blockedCallsCount = null,
    Object? isBlockingActive = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            blockedCountries: null == blockedCountries
                ? _value.blockedCountries
                : blockedCountries // ignore: cast_nullable_to_non_nullable
                      as List<BlockedCountry>,
            blockedCallsCount: null == blockedCallsCount
                ? _value.blockedCallsCount
                : blockedCallsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isBlockingActive: null == isBlockingActive
                ? _value.isBlockingActive
                : isBlockingActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CountryBlockingStateImplCopyWith<$Res>
    implements $CountryBlockingStateCopyWith<$Res> {
  factory _$$CountryBlockingStateImplCopyWith(
    _$CountryBlockingStateImpl value,
    $Res Function(_$CountryBlockingStateImpl) then,
  ) = __$$CountryBlockingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<BlockedCountry> blockedCountries,
    int blockedCallsCount,
    bool isBlockingActive,
    bool isLoading,
    String? errorMessage,
  });
}

/// @nodoc
class __$$CountryBlockingStateImplCopyWithImpl<$Res>
    extends _$CountryBlockingStateCopyWithImpl<$Res, _$CountryBlockingStateImpl>
    implements _$$CountryBlockingStateImplCopyWith<$Res> {
  __$$CountryBlockingStateImplCopyWithImpl(
    _$CountryBlockingStateImpl _value,
    $Res Function(_$CountryBlockingStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CountryBlockingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blockedCountries = null,
    Object? blockedCallsCount = null,
    Object? isBlockingActive = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$CountryBlockingStateImpl(
        blockedCountries: null == blockedCountries
            ? _value._blockedCountries
            : blockedCountries // ignore: cast_nullable_to_non_nullable
                  as List<BlockedCountry>,
        blockedCallsCount: null == blockedCallsCount
            ? _value.blockedCallsCount
            : blockedCallsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isBlockingActive: null == isBlockingActive
            ? _value.isBlockingActive
            : isBlockingActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CountryBlockingStateImpl implements _CountryBlockingState {
  const _$CountryBlockingStateImpl({
    final List<BlockedCountry> blockedCountries = const [],
    this.blockedCallsCount = 0,
    this.isBlockingActive = true,
    this.isLoading = false,
    this.errorMessage,
  }) : _blockedCountries = blockedCountries;

  final List<BlockedCountry> _blockedCountries;
  @override
  @JsonKey()
  List<BlockedCountry> get blockedCountries {
    if (_blockedCountries is EqualUnmodifiableListView)
      return _blockedCountries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blockedCountries);
  }

  @override
  @JsonKey()
  final int blockedCallsCount;
  @override
  @JsonKey()
  final bool isBlockingActive;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'CountryBlockingState(blockedCountries: $blockedCountries, blockedCallsCount: $blockedCallsCount, isBlockingActive: $isBlockingActive, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CountryBlockingStateImpl &&
            const DeepCollectionEquality().equals(
              other._blockedCountries,
              _blockedCountries,
            ) &&
            (identical(other.blockedCallsCount, blockedCallsCount) ||
                other.blockedCallsCount == blockedCallsCount) &&
            (identical(other.isBlockingActive, isBlockingActive) ||
                other.isBlockingActive == isBlockingActive) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_blockedCountries),
    blockedCallsCount,
    isBlockingActive,
    isLoading,
    errorMessage,
  );

  /// Create a copy of CountryBlockingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CountryBlockingStateImplCopyWith<_$CountryBlockingStateImpl>
  get copyWith =>
      __$$CountryBlockingStateImplCopyWithImpl<_$CountryBlockingStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CountryBlockingState implements CountryBlockingState {
  const factory _CountryBlockingState({
    final List<BlockedCountry> blockedCountries,
    final int blockedCallsCount,
    final bool isBlockingActive,
    final bool isLoading,
    final String? errorMessage,
  }) = _$CountryBlockingStateImpl;

  @override
  List<BlockedCountry> get blockedCountries;
  @override
  int get blockedCallsCount;
  @override
  bool get isBlockingActive;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of CountryBlockingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CountryBlockingStateImplCopyWith<_$CountryBlockingStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
