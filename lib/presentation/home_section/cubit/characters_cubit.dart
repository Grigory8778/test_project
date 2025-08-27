import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/data/data_base_model/character_hive.dart';
import 'package:test_project/data/repository/character_repository.dart';
import 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharacterRepository repo;

  CharactersCubit(this.repo) : super(const CharactersState());

  Future<void> loadInitial() async {
    emit(state.copyWith(status: CharactersStatus.loading, page: 1));
    try {
      final res = await repo.loadPage(page: 1);
      emit(state.copyWith(
        status: CharactersStatus.success,
        items: res.items,
        page: 1,
        hasMore: res.hasMore,
        favoriteIds: res.favoriteIds,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CharactersStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.status == CharactersStatus.loadingMore) return;

    emit(state.copyWith(status: CharactersStatus.loadingMore));
    final nextPage = state.page + 1;

    try {
      final res = await repo.loadPage(page: nextPage);

      final merged = _mergeById(state.items, res.items);

      emit(state.copyWith(
        status: CharactersStatus.success,
        items: merged,
        page: nextPage,
        hasMore: res.hasMore,
        favoriteIds: res.favoriteIds,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CharactersStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> refresh() async {
    try {
      final res = await repo.loadPage(page: 1);
      emit(state.copyWith(
        status: CharactersStatus.success,
        items: res.items,
        page: 1,
        hasMore: res.hasMore,
        favoriteIds: res.favoriteIds,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CharactersStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> toggleFavorite(int id) async {
    final favs = await repo.toggleFavorite(id);
    emit(state.copyWith(favoriteIds: favs));
  }

  List<CharacterHive> _mergeById(
    List<CharacterHive> current,
    List<CharacterHive> incoming,
  ) {
    final map = {for (final c in current) c.id: c};
    for (final c in incoming) {
      map[c.id] = c;
    }
    return map.values.toList();
  }
}
