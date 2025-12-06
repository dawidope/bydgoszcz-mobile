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
    @Default(false) bool visited,
    String? userPhotoPath,
  }) = _RouteStop;

  factory RouteStop.fromJson(Map<String, dynamic> json) =>
      _$RouteStopFromJson(json);
}
