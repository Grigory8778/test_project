import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/core/service_locator.dart';
import 'package:test_project/data/repository/character_repository.dart';
import 'package:test_project/presentation/home_section/cubit/characters_cubit.dart';
import 'package:test_project/presentation/home_section/cubit/characters_state.dart';
import 'package:test_project/presentation/widgets/character_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = ScrollController();
  late CharactersCubit _cubit;

  @override
  void initState() {
    super.initState();

    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final state = _cubit.state;
    if (!state.hasMore || state.status == CharactersStatus.loadingMore) return;

    const threshold = 200.0;
    if (_controller.position.pixels + threshold >=
        _controller.position.maxScrollExtent) {
      _cubit.loadMore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CharactersCubit>(
      create: (_) =>
          CharactersCubit(getIt<CharacterRepository>())..loadInitial(),
      child: Builder(
        builder: (innerCtx) {
          _cubit = innerCtx.read<CharactersCubit>();
          return BlocBuilder<CharactersCubit, CharactersState>(
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(title: const Text('Персонажи')),
                body: switch (state.status) {
                  CharactersStatus.loading =>
                    const Center(child: CircularProgressIndicator()),
                  CharactersStatus.failure =>
                    Center(child: Text(state.error ?? 'Ошибка')),
                  _ => RefreshIndicator(
                      onRefresh: () => _cubit.refresh(),
                      child: ListView.builder(
                        controller: _controller,
                        itemCount: state.items.length + (state.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= state.items.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final item = state.items[index];
                          final isFav = state.favoriteIds.contains(item.id);
                          return CharacterCard(
                            item: item,
                            isFavorite: isFav,
                            onToggleFavorite: () =>
                                _cubit.toggleFavorite(item.id),
                          );
                        },
                      ),
                    ),
                },
              );
            },
          );
        },
      ),
    );
  }
}
