import 'package:freezed_annotation/freezed_annotation.dart';

part 'character_response.freezed.dart';
part 'character_response.g.dart';

@freezed
class CharacterResponse with _$CharacterResponse {
  const factory CharacterResponse({
    required int id,
    required String name,
    required String status,
    required String species,
    required String type,
    required String gender,
    required RMRefResponse origin,
    required RMRefResponse location,
    required String image,
    required List<String> episode,
    required String url,
    required DateTime created,
  }) = _CharacterResponse;

  factory CharacterResponse.fromJson(Map<String, dynamic> json) =>
      _$CharacterResponseFromJson(json);

}

@freezed
class RMRefResponse with _$RMRefResponse {
  const factory RMRefResponse({
    required String name,
    required String url,
  }) = _RMRefResponse;

  factory RMRefResponse.fromJson(Map<String, dynamic> json) =>
      _$RMRefResponseFromJson(json);
}