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
      .then((token) => _api.getProfile(
            token,
            getDeviceId(),
          ))
      .catchError(exception)
      .whenComplete(loadingEnd);

  @override
  Future<void> updateProfile(ProfileModel profile) => _prepare
      .then((token) => _api.updateProfile(token, getDeviceId(), profile))
      .catchError(exception)
      .whenComplete(loadingEnd);

  @override
  Future<void> deleteProfile() => _prepare
      .then((token) => _api.deleteProfile(
            token,
            getDeviceId(),
          ))
      .catchError(exception)
      .whenComplete(() => _authUseCase.signOut())
      .whenComplete(loadingEnd);

  Future<String> get _prepare => checkConnectionFuture
      .then((_) => loadingStart.then((value) => _authUseCase.getAPIToken()));
}
