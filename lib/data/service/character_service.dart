import 'package:dio/dio.dart';
import 'package:test_project/data/model/characters_page_response.dart';
import 'package:test_project/data/network/character_api.dart';
import '../../core/service/api_client.dart' as core show DioClient;

class CharacterService {
  late final CharacterApi _api;

  CharacterService({Dio? dio}) {
    final client = dio ?? core.DioClient().dio;
    _api = CharacterApi(client);
  }

  Future<CharactersPageResponse> getCharactersPage(int page) {
    return _api.getCharacters(page);
  }
}
