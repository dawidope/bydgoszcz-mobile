// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GeneratedRouteImpl _$$GeneratedRouteImplFromJson(Map json) => $checkedCreate(
  r'_$GeneratedRouteImpl',
  json,
  ($checkedConvert) {
    final val = _$GeneratedRouteImpl(
      id: $checkedConvert('id', (v) => v as String),
      title: $checkedConvert('title', (v) => v as String),
      narration: $checkedConvert('narration', (v) => v as String),
      stops: $checkedConvert(
        'stops',
        (v) => (v as List<dynamic>)
            .map((e) => RouteStop.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      ),
      completed: $checkedConvert('completed', (v) => v as bool? ?? false),
      medal: $checkedConvert(
        'medal',
        (v) => $enumDecodeNullable(_$MedalTypeEnumMap, v),
      ),
      createdAt: $checkedConvert(
        'created_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      completedAt: $checkedConvert(
        'completed_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      coverImageBase64: $checkedConvert(
        'cover_image_base64',
        (v) => v as String?,
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'createdAt': 'created_at',
    'completedAt': 'completed_at',
    'coverImageBase64': 'cover_image_base64',
  },
);

Map<String, dynamic> _$$GeneratedRouteImplToJson(
  _$GeneratedRouteImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'narration': instance.narration,
  'stops': instance.stops,
  'completed': instance.completed,
  'medal': _$MedalTypeEnumMap[instance.medal],
  'created_at': instance.createdAt?.toIso8601String(),
  'completed_at': instance.completedAt?.toIso8601String(),
  'cover_image_base64': instance.coverImageBase64,
};

const _$MedalTypeEnumMap = {
  MedalType.gold: 'gold',
  MedalType.silver: 'silver',
  MedalType.bronze: 'bronze',
};
