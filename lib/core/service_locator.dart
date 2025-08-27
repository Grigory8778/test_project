// lib/core/di/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'package:test_project/core/service/api_client.dart';
import 'package:test_project/core/theme/theme_cubit.dart';
import 'package:test_project/data/database/character_local_data_source.dart';
import 'package:test_project/data/service/character_service.dart';
import 'package:test_project/data/repository/character_repository.dart';

final getIt = GetIt.instance;

Future<void> setupDI() async {
  // Dio
  getIt.registerLazySingleton<Dio>(() => DioClient().dio);

  final local = await CharacterLocalDataSource.open();
  getIt.registerSingleton<CharacterLocalDataSource>(local);

  // Service
  getIt.registerLazySingleton<CharacterService>(
    () => CharacterService(
      dio: getIt<Dio>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<CharacterRepository>(
    () => CharacterRepository(
      service: getIt<CharacterService>(),
      local: getIt<CharacterLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

}
