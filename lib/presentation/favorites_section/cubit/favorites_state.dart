import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_project/data/data_base_model/character_hive.dart';

part 'favorites_state.freezed.dart';

enum FavoritesStatus { initial, loading, success, failure }
enum FavoritesListOp { none, insert, remove, replace }

@freezed
class FavoritesState with _$FavoritesState {
  const factory FavoritesState({
    @Default(FavoritesStatus.initial) FavoritesStatus status,
    @Default(<CharacterHive>[]) List<CharacterHive> items, // уже отфильтрованные
    @Default('') String query,
    // сигнал для UI-анимации:
    @Default(FavoritesListOp.none) FavoritesListOp lastOp,
    @Default(-1) int opIndex,
    CharacterHive? opItem, // для remove/insert
    String? error,
  }) = _FavoritesState;
}