// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_stop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RouteStopImpl _$$RouteStopImplFromJson(Map json) => $checkedCreate(
  r'_$RouteStopImpl',
  json,
  ($checkedConvert) {
    final val = _$RouteStopImpl(
      id: $checkedConvert('id', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String),
      order: $checkedConvert('order', (v) => (v as num).toInt()),
      shortStory: $checkedConvert('short_story', (v) => v as String),
      funFact: $checkedConvert('fun_fact', (v) => v as String),
      quiz: $checkedConvert(
        'quiz',
        (v) => QuizQuestion.fromJson(Map<String, dynamic>.from(v as Map)),
      ),
      visited: $checkedConvert('visited', (v) => v as bool? ?? false),
      quizCompleted: $checkedConvert(
        'quiz_completed',
        (v) => v as bool? ?? false,
      ),
      userPhotoPath: $checkedConvert('user_photo_path', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'shortStory': 'short_story',
    'funFact': 'fun_fact',
    'quizCompleted': 'quiz_completed',
    'userPhotoPath': 'user_photo_path',
  },
);

Map<String, dynamic> _$$RouteStopImplToJson(_$RouteStopImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
      'short_story': instance.shortStory,
      'fun_fact': instance.funFact,
      'quiz': instance.quiz,
      'visited': instance.visited,
      'quiz_completed': instance.quizCompleted,
      'user_photo_path': instance.userPhotoPath,
    };
