// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_stop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RouteStop _$RouteStopFromJson(Map<String, dynamic> json) {
  return _RouteStop.fromJson(json);
}

/// @nodoc
mixin _$RouteStop {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  String get shortStory => throw _privateConstructorUsedError;
  String get funFact => throw _privateConstructorUsedError;
  bool get visited => throw _privateConstructorUsedError;
  String? get userPhotoPath => throw _privateConstructorUsedError;

  /// Serializes this RouteStop to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RouteStop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteStopCopyWith<RouteStop> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteStopCopyWith<$Res> {
  factory $RouteStopCopyWith(RouteStop value, $Res Function(RouteStop) then) =
      _$RouteStopCopyWithImpl<$Res, RouteStop>;
  @useResult
  $Res call({
    String id,
    String name,
    int order,
    String shortStory,
    String funFact,
    bool visited,
    String? userPhotoPath,
  });
}

/// @nodoc
class _$RouteStopCopyWithImpl<$Res, $Val extends RouteStop>
    implements $RouteStopCopyWith<$Res> {
  _$RouteStopCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteStop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? order = null,
    Object? shortStory = null,
    Object? funFact = null,
    Object? visited = null,
    Object? userPhotoPath = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
            shortStory: null == shortStory
                ? _value.shortStory
                : shortStory // ignore: cast_nullable_to_non_nullable
                      as String,
            funFact: null == funFact
                ? _value.funFact
                : funFact // ignore: cast_nullable_to_non_nullable
                      as String,
            visited: null == visited
                ? _value.visited
                : visited // ignore: cast_nullable_to_non_nullable
                      as bool,
            userPhotoPath: freezed == userPhotoPath
                ? _value.userPhotoPath
                : userPhotoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RouteStopImplCopyWith<$Res>
    implements $RouteStopCopyWith<$Res> {
  factory _$$RouteStopImplCopyWith(
    _$RouteStopImpl value,
    $Res Function(_$RouteStopImpl) then,
  ) = __$$RouteStopImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    int order,
    String shortStory,
    String funFact,
    bool visited,
    String? userPhotoPath,
  });
}

/// @nodoc
class __$$RouteStopImplCopyWithImpl<$Res>
    extends _$RouteStopCopyWithImpl<$Res, _$RouteStopImpl>
    implements _$$RouteStopImplCopyWith<$Res> {
  __$$RouteStopImplCopyWithImpl(
    _$RouteStopImpl _value,
    $Res Function(_$RouteStopImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RouteStop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? order = null,
    Object? shortStory = null,
    Object? funFact = null,
    Object? visited = null,
    Object? userPhotoPath = freezed,
  }) {
    return _then(
      _$RouteStopImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        shortStory: null == shortStory
            ? _value.shortStory
            : shortStory // ignore: cast_nullable_to_non_nullable
                  as String,
        funFact: null == funFact
            ? _value.funFact
            : funFact // ignore: cast_nullable_to_non_nullable
                  as String,
        visited: null == visited
            ? _value.visited
            : visited // ignore: cast_nullable_to_non_nullable
                  as bool,
        userPhotoPath: freezed == userPhotoPath
            ? _value.userPhotoPath
            : userPhotoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RouteStopImpl implements _RouteStop {
  const _$RouteStopImpl({
    required this.id,
    required this.name,
    required this.order,
    required this.shortStory,
    required this.funFact,
    this.visited = false,
    this.userPhotoPath,
  });

  factory _$RouteStopImpl.fromJson(Map<String, dynamic> json) =>
      _$$RouteStopImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int order;
  @override
  final String shortStory;
  @override
  final String funFact;
  @override
  @JsonKey()
  final bool visited;
  @override
  final String? userPhotoPath;

  @override
  String toString() {
    return 'RouteStop(id: $id, name: $name, order: $order, shortStory: $shortStory, funFact: $funFact, visited: $visited, userPhotoPath: $userPhotoPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteStopImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.shortStory, shortStory) ||
                other.shortStory == shortStory) &&
            (identical(other.funFact, funFact) || other.funFact == funFact) &&
            (identical(other.visited, visited) || other.visited == visited) &&
            (identical(other.userPhotoPath, userPhotoPath) ||
                other.userPhotoPath == userPhotoPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    order,
    shortStory,
    funFact,
    visited,
    userPhotoPath,
  );

  /// Create a copy of RouteStop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteStopImplCopyWith<_$RouteStopImpl> get copyWith =>
      __$$RouteStopImplCopyWithImpl<_$RouteStopImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RouteStopImplToJson(this);
  }
}

abstract class _RouteStop implements RouteStop {
  const factory _RouteStop({
    required final String id,
    required final String name,
    required final int order,
    required final String shortStory,
    required final String funFact,
    final bool visited,
    final String? userPhotoPath,
  }) = _$RouteStopImpl;

  factory _RouteStop.fromJson(Map<String, dynamic> json) =
      _$RouteStopImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get order;
  @override
  String get shortStory;
  @override
  String get funFact;
  @override
  bool get visited;
  @override
  String? get userPhotoPath;

  /// Create a copy of RouteStop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteStopImplCopyWith<_$RouteStopImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
