import 'package:freezed_annotation/freezed_annotation.dart';

part 'monument.freezed.dart';
part 'monument.g.dart';

@freezed
class Monument with _$Monument {
  const factory Monument({
    required String id,
    required String name,
    required String shortDescription,
    required String facts,
    required String imageUrl,
    required String googleMapsUrl,
    String? story,
    String? funFact,
  }) = _Monument;

  factory Monument.fromJson(Map<String, dynamic> json) =>
      _$MonumentFromJson(json);
}
