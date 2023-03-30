import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:injectable/injectable.dart';

import '../../core/cubit/application_cubit.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

abstract class AuthUseCase {
  Future<bool> get isAuth;
  Future<void> signInWithEmail(
      {required String email, required String password});
  Future<void> signUpWithEmail(
      {required String email, required String password, required String name});
  Future<void> signOut();
}

@LazySingleton(as: AuthUseCase)
class AuthUseCaseImpl implements AuthUseCase {
  final ApiRepository _api;
  final EncryptedPreferencesRepository _encrypted;
  final ApplicationCubit _app;

  const AuthUseCaseImpl(this._app, this._api, this._encrypted);

  @override
  Future<bool> get isAuth => Future.delayed(
        Duration.zero,
        () => _app.loadingShow(),
      )
          .then((_) => _encrypted.readToken().then((token) =>
              token != null ? _checkAuth(token) : Future.value(false)))
          .whenComplete(() => _app.loadingHide());

  @override
  Future<void> signInWithEmail(
          {required String email, required String password}) =>
      Future.delayed(
        Duration.zero,
        () => _app.loadingShow(),
      )
          .then((_) => _api
              .signInWithEmail(email: email, password: password)
              .then(_checkAuth)
              .then((_) => Future.value())
              .catchError(_app.exception))
          .whenComplete(() => _app.loadingHide());

  @override
  Future<void> signUpWithEmail(
          {required String email,
          required String password,
          required String name}) =>
      Future.delayed(
        Duration.zero,
        () => _app.loadingShow(),
      )
          .then((_) => _api
              .signUpWithEmail(email: email, password: password, name: name)
              .then(_checkAuth)
              .then((_) => Future.value())
              .catchError(_app.exception))
          .whenComplete(() => _app.loadingHide());

  @override
  Future<void> signOut() => Future.delayed(
        Duration.zero,
        () => _app.loadingShow(),
      )
          .then((_) => _encrypted
              .cleanToken()
              .whenComplete(() => _app.auth(AuthState.unauthorized)))
          .whenComplete(() => _app.loadingHide());

  Future<bool> _checkAuth(TokenModel token) {
    final jwt = _parseToken(token.accessToken);
    if (jwt != null) {
      _app.auth(AuthState.authorized);
      return _encrypted.writeToken(token).then((_) => Future.value(true));
    } else {
      return _api
          .refreshToken(token.refreshToken)
          .then((value) => _checkAuth(token))
          .catchError((onError) {
        _app.exception(onError);
        return Future.value(false);
      });
    }
  }

  JWT? _parseToken(String token) {
    final jwt = JWT.tryDecode(token);
    if (jwt == null) return null;
    final payload = jwt.payload;
    if (payload is! Map) return null;
    if (!payload.containsKey('exp')) return null;
    final dateExpired = DateTime.fromMillisecondsSinceEpoch(
        payload['exp'] * 1000,
        isUtc: false);
    return dateExpired.difference(DateTime.now().toUtc()) > Duration.zero
        ? jwt
        : null;
  }
}
