import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/data/data_base_model/character_hive.dart';
import 'package:test_project/data/database/character_local_data_source.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final CharacterLocalDataSource _local;
  StreamSubscription<List<CharacterHive>>? _sub;

  List<CharacterHive> _allFavs = const [];

  FavoritesCubit(this._local) : super(const FavoritesState()) {
    emit(state.copyWith(status: FavoritesStatus.loading));

    _sub = _local.watchAll().listen((all) {
      try {
        _allFavs = all.where((e) => e.isFavorite).toList(growable: false);
        _applyFilter(diffFrom: state.items);
      } catch (e) {
        emit(state.copyWith(status: FavoritesStatus.failure, error: e.toString()));
      }
    });
  }

  Future<void> toggleFavorite(int id) async {
    await _local.toggleFavorite(id);
  }

  void setQuery(String query) {
    emit(state.copyWith(query: query));
    _applyFilter(diffFrom: state.items);
  }

  void _applyFilter({required List<CharacterHive> diffFrom}) {
    final q = state.query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? _allFavs
        : _allFavs.where((c) =>
    c.name.toLowerCase().contains(q) ||
        c.status.toLowerCase().contains(q) ||
        c.species.toLowerCase().contains(q) ||
        c.location.toLowerCase().contains(q),
    ).toList(growable: false);

    final old = diffFrom;
    final op = _calcOp(old, filtered);

    emit(state.copyWith(
      status: FavoritesStatus.success,
      items: filtered,
      lastOp: op.type,
      opIndex: op.index,
      opItem: op.item,
      error: null,
    ));
  }

  _ListOp _calcOp(List<CharacterHive> oldList, List<CharacterHive> newList) {
    // построим карты по id
    final oldIds = oldList.map((e) => e.id).toList();
    final newIds = newList.map((e) => e.id).toList();

    // одиночное удаление
    if (oldIds.length == newIds.length + 1) {
      for (int i = 0; i < oldIds.length; i++) {
        if (i >= newIds.length || oldIds[i] != newIds[i]) {
          return _ListOp(
            type: FavoritesListOp.remove,
            index: i,
            item: oldList[i],
          );
        }
      }
      // если разошлось только в конце
      return _ListOp(
        type: FavoritesListOp.remove,
        index: oldIds.length - 1,
        item: oldList.last,
      );
    }

    // одиночная вставка
    if (newIds.length == oldIds.length + 1) {
      for (int i = 0; i < newIds.length; i++) {
        if (i >= oldIds.length || newIds[i] != oldIds[i]) {
          return _ListOp(
            type: FavoritesListOp.insert,
            index: i,
            item: newList[i],
          );
        }
      }
      return _ListOp(
        type: FavoritesListOp.insert,
        index: newIds.length - 1,
        item: newList.last,
      );
    }
    return _ListOp(type: FavoritesListOp.replace);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

class _ListOp {
  final FavoritesListOp type;
  final int index;
  final CharacterHive? item;
  const _ListOp({required this.type, this.index = -1, this.item});
}