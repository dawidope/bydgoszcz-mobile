// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monument.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MonumentImpl _$$MonumentImplFromJson(Map json) => $checkedCreate(
  r'_$MonumentImpl',
  json,
  ($checkedConvert) {
    final val = _$MonumentImpl(
      id: $checkedConvert('id', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String),
      shortDescription: $checkedConvert(
        'short_description',
        (v) => v as String,
      ),
      facts: $checkedConvert('facts', (v) => v as String),
      imageUrl: $checkedConvert('image_url', (v) => v as String),
      story: $checkedConvert('story', (v) => v as String?),
      funFact: $checkedConvert('fun_fact', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'shortDescription': 'short_description',
    'imageUrl': 'image_url',
    'funFact': 'fun_fact',
  },
);

Map<String, dynamic> _$$MonumentImplToJson(_$MonumentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'short_description': instance.shortDescription,
      'facts': instance.facts,
      'image_url': instance.imageUrl,
      'story': instance.story,
      'fun_fact': instance.funFact,
    };
