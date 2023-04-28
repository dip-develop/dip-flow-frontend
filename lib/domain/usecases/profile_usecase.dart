import 'package:injectable/injectable.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';
import 'usecases.dart';

abstract class ProfileUseCase {
  Future<ProfileModel> getProfile();
  Future<void> updateProfile(ProfileModel profile);
  Future<void> deleteProfile();
}

@LazySingleton(as: ProfileUseCase)
class ProfileUseCaseImpl implements ProfileUseCase {
  final ProfileApiRepository _api;
  final AuthUseCase _authUseCase;

  const ProfileUseCaseImpl(this._authUseCase, this._api);

  @override
  Future<ProfileModel> getProfile() => _prepare
      .then((token) => _api.getProfile(token))
      .catchError(exception)
      .whenComplete(loadingEnd);

  @override
  Future<void> updateProfile(ProfileModel profile) => _prepare
      .then((token) => _api.updateProfile(token, profile))
      .catchError(exception)
      .whenComplete(loadingEnd);

  @override
  Future<void> deleteProfile() => _prepare
      .then((token) =>
          _api.deleteProfile(token).whenComplete(() => _authUseCase.signOut()))
      .catchError(exception)
      .whenComplete(loadingEnd);

  Future<String> get _prepare =>
      loadingStart.then((value) => _authUseCase.getToken());
}
