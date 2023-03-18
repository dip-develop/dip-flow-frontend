abstract class PreferencesRepository {
  Future<bool> isFirstRun();
  Future<void> saveNoFirstRun();

  Future<int> getThemeMode();
  Future<void> saveThemeMode(int index);
}
