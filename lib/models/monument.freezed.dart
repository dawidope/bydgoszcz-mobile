// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monument.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Monument _$MonumentFromJson(Map<String, dynamic> json) {
  return _Monument.fromJson(json);
}

/// @nodoc
mixin _$Monument {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get shortDescription => throw _privateConstructorUsedError;
  String get facts => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get googleMapsUrl => throw _privateConstructorUsedError;
  String? get story => throw _privateConstructorUsedError;
  String? get funFact => throw _privateConstructorUsedError;

  /// Serializes this Monument to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Monument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonumentCopyWith<Monument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonumentCopyWith<$Res> {
  factory $MonumentCopyWith(Monument value, $Res Function(Monument) then) =
      _$MonumentCopyWithImpl<$Res, Monument>;
  @useResult
  $Res call({
    String id,
    String name,
    String shortDescription,
    String facts,
    String imageUrl,
    String googleMapsUrl,
    String? story,
    String? funFact,
  });
}

/// @nodoc
class _$MonumentCopyWithImpl<$Res, $Val extends Monument>
    implements $MonumentCopyWith<$Res> {
  _$MonumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Monument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? shortDescription = null,
    Object? facts = null,
    Object? imageUrl = null,
    Object? googleMapsUrl = null,
    Object? story = freezed,
    Object? funFact = freezed,
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
            shortDescription: null == shortDescription
                ? _value.shortDescription
                : shortDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            facts: null == facts
                ? _value.facts
                : facts // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            googleMapsUrl: null == googleMapsUrl
                ? _value.googleMapsUrl
                : googleMapsUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            story: freezed == story
                ? _value.story
                : story // ignore: cast_nullable_to_non_nullable
                      as String?,
            funFact: freezed == funFact
                ? _value.funFact
                : funFact // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MonumentImplCopyWith<$Res>
    implements $MonumentCopyWith<$Res> {
  factory _$$MonumentImplCopyWith(
    _$MonumentImpl value,
    $Res Function(_$MonumentImpl) then,
  ) = __$$MonumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String shortDescription,
    String facts,
    String imageUrl,
    String googleMapsUrl,
    String? story,
    String? funFact,
  });
}

/// @nodoc
class __$$MonumentImplCopyWithImpl<$Res>
    extends _$MonumentCopyWithImpl<$Res, _$MonumentImpl>
    implements _$$MonumentImplCopyWith<$Res> {
  __$$MonumentImplCopyWithImpl(
    _$MonumentImpl _value,
    $Res Function(_$MonumentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Monument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? shortDescription = null,
    Object? facts = null,
    Object? imageUrl = null,
    Object? googleMapsUrl = null,
    Object? story = freezed,
    Object? funFact = freezed,
  }) {
    return _then(
      _$MonumentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        shortDescription: null == shortDescription
            ? _value.shortDescription
            : shortDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        facts: null == facts
            ? _value.facts
            : facts // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        googleMapsUrl: null == googleMapsUrl
            ? _value.googleMapsUrl
            : googleMapsUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        story: freezed == story
            ? _value.story
            : story // ignore: cast_nullable_to_non_nullable
                  as String?,
        funFact: freezed == funFact
            ? _value.funFact
            : funFact // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MonumentImpl implements _Monument {
  const _$MonumentImpl({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.facts,
    required this.imageUrl,
    required this.googleMapsUrl,
    this.story,
    this.funFact,
  });

  factory _$MonumentImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonumentImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String shortDescription;
  @override
  final String facts;
  @override
  final String imageUrl;
  @override
  final String googleMapsUrl;
  @override
  final String? story;
  @override
  final String? funFact;

  @override
  String toString() {
    return 'Monument(id: $id, name: $name, shortDescription: $shortDescription, facts: $facts, imageUrl: $imageUrl, googleMapsUrl: $googleMapsUrl, story: $story, funFact: $funFact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonumentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.facts, facts) || other.facts == facts) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.googleMapsUrl, googleMapsUrl) ||
                other.googleMapsUrl == googleMapsUrl) &&
            (identical(other.story, story) || other.story == story) &&
            (identical(other.funFact, funFact) || other.funFact == funFact));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    shortDescription,
    facts,
    imageUrl,
    googleMapsUrl,
    story,
    funFact,
  );

  /// Create a copy of Monument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonumentImplCopyWith<_$MonumentImpl> get copyWith =>
      __$$MonumentImplCopyWithImpl<_$MonumentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonumentImplToJson(this);
  }
}

abstract class _Monument implements Monument {
  const factory _Monument({
    required final String id,
    required final String name,
    required final String shortDescription,
    required final String facts,
    required final String imageUrl,
    required final String googleMapsUrl,
    final String? story,
    final String? funFact,
  }) = _$MonumentImpl;

  factory _Monument.fromJson(Map<String, dynamic> json) =
      _$MonumentImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get shortDescription;
  @override
  String get facts;
  @override
  String get imageUrl;
  @override
  String get googleMapsUrl;
  @override
  String? get story;
  @override
  String? get funFact;

  /// Create a copy of Monument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonumentImplCopyWith<_$MonumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
