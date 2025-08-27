import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:test_project/data/model/character_response.dart';
import 'package:test_project/data/model/characters_page_response.dart';


part 'character_api.g.dart';

@RestApi()
abstract class CharacterApi {
  factory CharacterApi(Dio dio, {String baseUrl}) = _CharacterApi;

  /// GET character?page={page}
  @GET('character')
  Future<CharactersPageResponse> getCharacters(@Query('page') int page);
}