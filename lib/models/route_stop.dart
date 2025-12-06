import 'package:bydgoszcz/models/quiz_question.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_stop.freezed.dart';
part 'route_stop.g.dart';

@freezed
class RouteStop with _$RouteStop {
  const factory RouteStop({
    required String id,
    required String name,
    required int order,
    required String shortStory,
    required String funFact,
    required QuizQuestion quiz,
    @Default(false) bool visited,
    @Default(false) bool quizCompleted,
    String? userPhotoPath,
  }) = _RouteStop;

  factory RouteStop.fromJson(Map<String, dynamic> json) =>
      _$RouteStopFromJson(json);
}
