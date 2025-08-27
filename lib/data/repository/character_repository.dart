import 'package:test_project/data/data_base_model/character_hive.dart';
import 'package:test_project/data/service/character_service.dart';
import 'package:test_project/data/database/character_local_data_source.dart';

class CharacterRepository {
  final CharacterService _service;
  final CharacterLocalDataSource _local;

  CharacterRepository({
    required CharacterService service,
    required CharacterLocalDataSource local,
  })  : _service = service,
        _local = local;

  Future<RepoResult> loadPage({required int page, bool append = false}) async {
    bool fromCache = false;
    bool hasMore = false;

    try {
      final res = await _service.getCharactersPage(page);
      final mapped = res.results.map(CharacterHive.fromResponse).toList();
      await _local.upsertAllPreserveFavorite(mapped);
      hasMore = res.info.next != null;
    } catch (_) {
      fromCache = true;
    }

    final items = await _local.getAll();
    final favorites = _local.favoriteIds();

    return RepoResult(
      items: append ? items : items,
      page: page,
      hasMore: hasMore,
      fromCache: fromCache,
      favoriteIds: favorites,
    );
  }

  Future<Set<int>> toggleFavorite(int id) async {
    await _local.toggleFavorite(id);
    return _local.favoriteIds();
  }

  Future<RepoResult> readAllFromDb({int page = 1}) async {
    final items = await _local.getAll();
    return RepoResult(
      items: items,
      page: page,
      hasMore: false,
      fromCache: true,
      favoriteIds: _local.favoriteIds(),
    );
  }
}

class RepoResult {
  final List<CharacterHive> items;
  final int page;
  final bool hasMore;
  final bool fromCache;
  final Set<int> favoriteIds;

  const RepoResult({
    required this.items,
    required this.page,
    required this.hasMore,
    required this.fromCache,
    required this.favoriteIds,
  });
}