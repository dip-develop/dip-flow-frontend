import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../repositories/repositories.dart';

abstract class AppUseCase {
  Future<bool> isFirstRun();
  Future<ThemeMode> getThemeMode();
  Future<void> saveThemeMode(ThemeMode mode);
}

@Singleton(as: AppUseCase)
class AppUseCaseImpl implements AppUseCase {
  final PreferencesRepository _prefsRepo;

  const AppUseCaseImpl(this._prefsRepo);

  @override
  Future<bool> isFirstRun() => _prefsRepo.isFirstRun();

  @override
  Future<ThemeMode> getThemeMode() =>
      _prefsRepo.getThemeMode().then((value) => ThemeMode.values[value]);

  @override
  Future<void> saveThemeMode(ThemeMode mode) =>
      _prefsRepo.saveThemeMode(mode.index);
}
