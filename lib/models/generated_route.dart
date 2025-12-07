import 'package:bydgoszcz/models/route_stop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated_route.freezed.dart';
part 'generated_route.g.dart';

enum MedalType { gold, silver, bronze }

@freezed
class GeneratedRoute with _$GeneratedRoute {
  const factory GeneratedRoute({
    required String id,
    required String title,
    required String narration,
    required List<RouteStop> stops,
    @Default(false) bool completed,
    MedalType? medal,
    DateTime? createdAt,
    DateTime? completedAt,
    String? coverImageBase64,
  }) = _GeneratedRoute;

  factory GeneratedRoute.fromJson(Map<String, dynamic> json) =>
      _$GeneratedRouteFromJson(json);
}
