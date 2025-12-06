// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map json) =>
    $checkedCreate(r'_$UserProfileImpl', json, ($checkedConvert) {
      final val = _$UserProfileImpl(
        name: $checkedConvert('name', (v) => v as String),
        age: $checkedConvert('age', (v) => (v as num).toInt()),
        interests: $checkedConvert(
          'interests',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'age': instance.age,
      'interests': instance.interests,
    };
