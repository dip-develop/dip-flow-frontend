import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/repositories/repositories.dart';

const _isFirtRunKey = 'isFirstRun';
const _themeModeKey = 'themeMode';

@LazySingleton(as: PreferencesRepository)
class SharedPreferencesRepositoryImpl implements PreferencesRepository {
  final _prefs = SharedPreferences.getInstance();

  @override
  Future<bool> isFirstRun() =>
      _prefs.then((value) => value.getBool(_isFirtRunKey) ?? true);

  @override
  Future<void> saveNoFirstRun() =>
      _prefs.then((value) => value.setBool(_isFirtRunKey, false));

  @override
  Future<int> getThemeMode() =>
      _prefs.then((value) => value.getInt(_themeModeKey) ?? 0);

  @override
  Future<void> saveThemeMode(int index) =>
      _prefs.then((value) => value.setInt(_themeModeKey, index));
}
