// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizQuestionImpl _$$QuizQuestionImplFromJson(Map json) => $checkedCreate(
  r'_$QuizQuestionImpl',
  json,
  ($checkedConvert) {
    final val = _$QuizQuestionImpl(
      question: $checkedConvert('question', (v) => v as String),
      answers: $checkedConvert(
        'answers',
        (v) => (v as List<dynamic>).map((e) => e as String).toList(),
      ),
      correctAnswerIndex: $checkedConvert(
        'correct_answer_index',
        (v) => (v as num).toInt(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {'correctAnswerIndex': 'correct_answer_index'},
);

Map<String, dynamic> _$$QuizQuestionImplToJson(_$QuizQuestionImpl instance) =>
    <String, dynamic>{
      'question': instance.question,
      'answers': instance.answers,
      'correct_answer_index': instance.correctAnswerIndex,
    };
