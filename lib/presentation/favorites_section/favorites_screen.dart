import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/core/service_locator.dart';
import 'package:test_project/data/database/character_local_data_source.dart';
import 'package:test_project/presentation/favorites_section/cubit/favorites_cubit.dart';
import 'package:test_project/presentation/favorites_section/cubit/favorites_state.dart';
import 'package:test_project/data/data_base_model/character_hive.dart';
import 'package:test_project/presentation/favorites_section/widgets/favorites_search_widget.dart';
import 'package:test_project/presentation/widgets/character_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _searchController = TextEditingController();
  final _listKey = GlobalKey<AnimatedListState>();
  List<CharacterHive> _visual = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyAnimatedChange(FavoritesState s) {
    switch (s.lastOp) {
      case FavoritesListOp.insert:
        if (s.opIndex >= 0 && s.opItem != null) {
          _visual.insert(s.opIndex, s.opItem!);
          _listKey.currentState?.insertItem(
            s.opIndex,
            duration: const Duration(milliseconds: 220),
          );
        } else {
          _resetVisual(s.items);
        }
        break;
      case FavoritesListOp.remove:
        if (s.opIndex >= 0 && s.opIndex < _visual.length) {
          final removed = _visual.removeAt(s.opIndex);
          _listKey.currentState?.removeItem(
            s.opIndex,
                (ctx, anim) => SizeTransition(
              sizeFactor: anim,
              child: FadeTransition(
                opacity: anim,
                child: CharacterCard(
                  item: removed,
                  isFavorite: true,
                  onToggleFavorite: () =>
                      context.read<FavoritesCubit>().toggleFavorite(removed.id),
                ),
              ),
            ),
            duration: const Duration(milliseconds: 220),
          );
        } else {
          _resetVisual(s.items);
        }
        break;
      case FavoritesListOp.replace:
      case FavoritesListOp.none:
        _resetVisual(s.items);
        break;
    }
  }

  void _resetVisual(List<CharacterHive> items) {
    _visual = List<CharacterHive>.from(items);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoritesCubit(getIt<CharacterLocalDataSource>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Избранное')),
        body: Column(
          children: [
            FavoritesSearchBar(
              controller: _searchController,
              onChanged: (v) => context.read<FavoritesCubit>().setQuery(v),
            ),
            Expanded(
              child: BlocConsumer<FavoritesCubit, FavoritesState>(
                listener: (context, state) {
                  if (state.status == FavoritesStatus.success) {
                    _applyAnimatedChange(state);
                  }
                },
                builder: (context, state) {
                  if (state.status == FavoritesStatus.initial ||
                      state.status == FavoritesStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == FavoritesStatus.failure) {
                    return Center(child: Text(state.error ?? 'Ошибка'));
                  }

                  if (_visual.isEmpty) {
                    return const Center(child: Text('Пусто'));
                  }

                  return AnimatedList(
                    key: _listKey,
                    initialItemCount: _visual.length,
                    padding: const EdgeInsets.only(top: 8),
                    itemBuilder: (context, index, animation) {
                      final item = _visual[index];
                      return SizeTransition(
                        sizeFactor: animation,
                        child: CharacterCard(
                          item: item,
                          isFavorite: true,
                          onToggleFavorite: () => context
                              .read<FavoritesCubit>()
                              .toggleFavorite(item.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}