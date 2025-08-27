import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_project/data/data_base_model/character_hive.dart';

part 'characters_state.freezed.dart';

enum CharactersStatus { initial, loading, success, failure, loadingMore }

@freezed
class CharactersState with _$CharactersState {
  const factory CharactersState({
    @Default(CharactersStatus.initial) CharactersStatus status,
    @Default(<CharacterHive>[]) List<CharacterHive> items,
    @Default(1) int page,
    @Default(true) bool hasMore,
    String? error,
    @Default(<int>{}) Set<int> favoriteIds,
  }) = _CharactersState;
}