import 'package:hive/hive.dart';
import 'package:test_project/data/data_base_model/character_hive.dart';

/// Локальный дата-сорс для работы с ЕДИНСТВЕННЫМ боксом персонажей.
class CharacterLocalDataSource {
  static const String charactersBoxName = 'charactersBox';

  late final Box<CharacterHive> _box;

  CharacterLocalDataSource._(this._box);

  /// Инициализация (открывает единственный бокс и возвращает готовый инстанс).
  static Future<CharacterLocalDataSource> open() async {
    final box = await Hive.openBox<CharacterHive>(charactersBoxName);
    return CharacterLocalDataSource._(box);
  }

  /// Закрыть бокс (например, при выходе из приложения).
  Future<void> close() async => _box.close();

  /// Сохранить/обновить одного персонажа.
  Future<void> put(CharacterHive item) async => _box.put(item.id, item);

  /// Сохранить список персонажей, НЕ затирая флаг избранного.
  Future<void> upsertAllPreserveFavorite(Iterable<CharacterHive> items) async {
    for (final i in items) {
      final existed = _box.get(i.id);
      final toSave =
      existed == null ? i : i.copyWith(isFavorite: existed.isFavorite);
      await _box.put(i.id, toSave);
    }
  }

  /// Получить персонажа по id.
  CharacterHive? get(int id) => _box.get(id);

  /// Все персонажи.
  List<CharacterHive> getAll() => _box.values.toList(growable: false);

  /// Удалить по id.
  Future<void> delete(int id) async => _box.delete(id);

  /// Очистить бокс полностью.
  Future<void> clear() async => _box.clear();

  /// Подписка на любые изменения бокса (+ мгновенный старт со снэпшотом).
  Stream<List<CharacterHive>> watchAll() {
    return _box.watch().map((_) => getAll()).startWith(getAll());
  }

  /// Набор избранных id.
  Set<int> favoriteIds() =>
      _box.values.where((e) => e.isFavorite).map((e) => e.id).toSet();

  /// Только избранные.
  List<CharacterHive> getFavorites() =>
      _box.values.where((e) => e.isFavorite).toList(growable: false);

  /// Переключить избранное.
  Future<void> toggleFavorite(int id) async {
    final item = _box.get(id);
    if (item == null) return;
    await _box.put(id, item.copyWith(isFavorite: !item.isFavorite));
  }
}

extension _StartWith<T> on Stream<T> {
  Stream<T> startWith(T value) async* {
    yield value;
    yield* this;
  }
}