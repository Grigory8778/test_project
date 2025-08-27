import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:test_project/core/service_locator.dart'; // должен экспортировать getIt и setupDI
import 'package:test_project/core/theme/app_theme.dart';
import 'package:test_project/core/theme/theme_cubit.dart';

import 'package:test_project/data/data_base_model/character_hive.dart';

import 'package:test_project/presentation/favorites_section/favorites_screen.dart';
import 'package:test_project/presentation/home_section/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  _registerHiveAdapters();
  await setupDI();
  final themeCubit = getIt<ThemeCubit>();
  await themeCubit.load();

  runApp(
    BlocProvider<ThemeCubit>.value(
      value: themeCubit,
      child: const MyApp(),
    ),
  );
}

void _registerHiveAdapters() {
  final adapter = CharacterHiveAdapter();
  if (!Hive.isAdapterRegistered(adapter.typeId)) {
    Hive.registerAdapter(adapter);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (_, state) {
        return MaterialApp(
          title: 'Test Project',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: state.mode,
          home: const RootTabs(),
        );
      },
    );
  }
}

class RootTabs extends StatefulWidget {
  const RootTabs({super.key});

  @override
  State<RootTabs> createState() => _RootTabsState();
}

class _RootTabsState extends State<RootTabs> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Project'),
        actions: [
          PopupMenuButton<ThemeMode>(
            icon: const Icon(Icons.color_lens),
            onSelected: (mode) {
              context.read<ThemeCubit>().setMode(mode);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: ThemeMode.system,
                child: Text('System'),
              ),
              PopupMenuItem(
                value: ThemeMode.light,
                child: Text('Light'),
              ),
              PopupMenuItem(
                value: ThemeMode.dark,
                child: Text('Dark'),
              ),
            ],
          ),
        ],
      ),
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Все'),
          NavigationDestination(icon: Icon(Icons.star), label: 'Избранное'),
        ],
      ),
    );
  }
}
