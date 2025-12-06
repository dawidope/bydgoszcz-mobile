// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generated_route.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GeneratedRoute _$GeneratedRouteFromJson(Map<String, dynamic> json) {
  return _GeneratedRoute.fromJson(json);
}

/// @nodoc
mixin _$GeneratedRoute {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get narration => throw _privateConstructorUsedError;
  List<RouteStop> get stops => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  MedalType? get medal => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this GeneratedRoute to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeneratedRoute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeneratedRouteCopyWith<GeneratedRoute> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneratedRouteCopyWith<$Res> {
  factory $GeneratedRouteCopyWith(
    GeneratedRoute value,
    $Res Function(GeneratedRoute) then,
  ) = _$GeneratedRouteCopyWithImpl<$Res, GeneratedRoute>;
  @useResult
  $Res call({
    String id,
    String title,
    String narration,
    List<RouteStop> stops,
    bool completed,
    MedalType? medal,
    DateTime? createdAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class _$GeneratedRouteCopyWithImpl<$Res, $Val extends GeneratedRoute>
    implements $GeneratedRouteCopyWith<$Res> {
  _$GeneratedRouteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeneratedRoute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? narration = null,
    Object? stops = null,
    Object? completed = null,
    Object? medal = freezed,
    Object? createdAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            narration: null == narration
                ? _value.narration
                : narration // ignore: cast_nullable_to_non_nullable
                      as String,
            stops: null == stops
                ? _value.stops
                : stops // ignore: cast_nullable_to_non_nullable
                      as List<RouteStop>,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool,
            medal: freezed == medal
                ? _value.medal
                : medal // ignore: cast_nullable_to_non_nullable
                      as MedalType?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GeneratedRouteImplCopyWith<$Res>
    implements $GeneratedRouteCopyWith<$Res> {
  factory _$$GeneratedRouteImplCopyWith(
    _$GeneratedRouteImpl value,
    $Res Function(_$GeneratedRouteImpl) then,
  ) = __$$GeneratedRouteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String narration,
    List<RouteStop> stops,
    bool completed,
    MedalType? medal,
    DateTime? createdAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class __$$GeneratedRouteImplCopyWithImpl<$Res>
    extends _$GeneratedRouteCopyWithImpl<$Res, _$GeneratedRouteImpl>
    implements _$$GeneratedRouteImplCopyWith<$Res> {
  __$$GeneratedRouteImplCopyWithImpl(
    _$GeneratedRouteImpl _value,
    $Res Function(_$GeneratedRouteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GeneratedRoute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? narration = null,
    Object? stops = null,
    Object? completed = null,
    Object? medal = freezed,
    Object? createdAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$GeneratedRouteImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        narration: null == narration
            ? _value.narration
            : narration // ignore: cast_nullable_to_non_nullable
                  as String,
        stops: null == stops
            ? _value._stops
            : stops // ignore: cast_nullable_to_non_nullable
                  as List<RouteStop>,
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool,
        medal: freezed == medal
            ? _value.medal
            : medal // ignore: cast_nullable_to_non_nullable
                  as MedalType?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GeneratedRouteImpl implements _GeneratedRoute {
  const _$GeneratedRouteImpl({
    required this.id,
    required this.title,
    required this.narration,
    required final List<RouteStop> stops,
    this.completed = false,
    this.medal,
    this.createdAt,
    this.completedAt,
  }) : _stops = stops;

  factory _$GeneratedRouteImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeneratedRouteImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String narration;
  final List<RouteStop> _stops;
  @override
  List<RouteStop> get stops {
    if (_stops is EqualUnmodifiableListView) return _stops;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stops);
  }

  @override
  @JsonKey()
  final bool completed;
  @override
  final MedalType? medal;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'GeneratedRoute(id: $id, title: $title, narration: $narration, stops: $stops, completed: $completed, medal: $medal, createdAt: $createdAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeneratedRouteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.narration, narration) ||
                other.narration == narration) &&
            const DeepCollectionEquality().equals(other._stops, _stops) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.medal, medal) || other.medal == medal) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    narration,
    const DeepCollectionEquality().hash(_stops),
    completed,
    medal,
    createdAt,
    completedAt,
  );

  /// Create a copy of GeneratedRoute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeneratedRouteImplCopyWith<_$GeneratedRouteImpl> get copyWith =>
      __$$GeneratedRouteImplCopyWithImpl<_$GeneratedRouteImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GeneratedRouteImplToJson(this);
  }
}

abstract class _GeneratedRoute implements GeneratedRoute {
  const factory _GeneratedRoute({
    required final String id,
    required final String title,
    required final String narration,
    required final List<RouteStop> stops,
    final bool completed,
    final MedalType? medal,
    final DateTime? createdAt,
    final DateTime? completedAt,
  }) = _$GeneratedRouteImpl;

  factory _GeneratedRoute.fromJson(Map<String, dynamic> json) =
      _$GeneratedRouteImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get narration;
  @override
  List<RouteStop> get stops;
  @override
  bool get completed;
  @override
  MedalType? get medal;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get completedAt;

  /// Create a copy of GeneratedRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeneratedRouteImplCopyWith<_$GeneratedRouteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
