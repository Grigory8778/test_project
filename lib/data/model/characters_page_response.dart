import 'package:freezed_annotation/freezed_annotation.dart';
import 'character_response.dart';

part 'characters_page_response.freezed.dart';
part 'characters_page_response.g.dart';

@freezed
class CharactersPageResponse with _$CharactersPageResponse {
  const factory CharactersPageResponse({
    required PageInfo info,
    required List<CharacterResponse> results,
  }) = _CharactersPageResponse;

  factory CharactersPageResponse.fromJson(Map<String, dynamic> json) =>
      _$CharactersPageResponseFromJson(json);
}

@freezed
class PageInfo with _$PageInfo {
  const factory PageInfo({
    required int count,
    required int pages,
    String? next,
    String? prev,
  }) = _PageInfo;

  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      _$PageInfoFromJson(json);
}