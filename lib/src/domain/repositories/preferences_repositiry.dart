import '../models/models.dart';

abstract class PreferencesRepository {
  Future<bool> isFirstRun();
  Future<void> saveNoFirstRun();

  Future<int> getThemeMode();
  Future<void> saveThemeMode(int index);
}

abstract class EncryptedPreferencesRepository {
  Future<TokenModel?> readToken();
  Future<void> writeToken(TokenModel token);
  Future<void> cleanToken();
}
