import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState {
  final ThemeMode mode;
  const ThemeState(this.mode);
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.system));

  static const _key = 'theme_mode';

  Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    final idx = sp.getInt(_key);
    emit(ThemeState(ThemeMode.values[idx ?? ThemeMode.system.index]));
  }

  Future<void> setMode(ThemeMode mode) async {
    emit(ThemeState(mode));
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_key, mode.index);
  }
}