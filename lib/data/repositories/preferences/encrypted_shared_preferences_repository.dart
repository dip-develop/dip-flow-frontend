import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/models/models.dart';
import '../../../domain/repositories/repositories.dart';

@LazySingleton(as: EncryptedPreferencesRepository)
class EncryptedSharedPreferences implements EncryptedPreferencesRepository {
  late final FlutterSecureStorage _storage;

  get _androidOptions => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  final _iosOptions =
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  EncryptedSharedPreferences() {
    _storage =
        FlutterSecureStorage(aOptions: _androidOptions, iOptions: _iosOptions);
  }

  @override
  Future<TokenModel?> readToken() =>
      _storage.read(key: 'tokens').then((value) => value != null
          ? serializers.fromJson(TokenModel.serializer, value)
          : null);

  @override
  Future<void> writeToken(TokenModel token) => _storage.write(
      key: 'tokens', value: serializers.toJson(TokenModel.serializer, token));

  @override
  Future<void> cleanToken() => _storage.delete(key: 'tokens');
}
