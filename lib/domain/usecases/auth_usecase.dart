import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:injectable/injectable.dart';

import '../../core/cubits/application_cubit.dart';
import '../exceptions/auth_exception.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';
import 'usecases.dart';

abstract class AuthUseCase {
  Future<bool> get isAuth;
  Future<String> getToken();
  Future<void> signInWithEmail(
      {required String email, required String password});
  Future<void> signUpWithEmail(
      {required String email, required String password, required String name});
  Future<void> signOut();
  Future<void> restorePassword(String email);
}

@LazySingleton(as: AuthUseCase)
class AuthUseCaseImpl implements AuthUseCase {
  final AuthApiRepository _api;
  final AnalyticsRepository _analytics;
  final EncryptedPreferencesRepository _encrypted;
  final ApplicationCubit _app;

  const AuthUseCaseImpl(this._app, this._analytics, this._api, this._encrypted);

  @override
  Future<bool> get isAuth => loadingStart
      .then((_) => _encrypted.readToken().then((token) => _checkAuth(token)))
      .whenComplete(loadingEnd);

  @override
  Future<String> getToken() =>
      _encrypted.readToken().then((token) => _checkAuth(token).then((isValid) {
            if (!isValid) {
              throw AuthException.needAuth();
            }
            return 'Bearer ${token!.accessToken}';
          }));

  @override
  Future<void> signInWithEmail(
          {required String email, required String password}) =>
      checkConnectionFuture
          .then((_) => loadingStart
              .then((_) => _api
                  .signInWithEmail(email: email, password: password)
                  .then((token) => _checkAuth(token).then((isValid) {
                        if (isValid) {
                          _analytics
                              .logSignIn(method: 'email')
                              .catchError(exception);
                        }
                      })))
              .catchError(exception))
          .whenComplete(loadingEnd);

  @override
  Future<void> signUpWithEmail(
          {required String email,
          required String password,
          required String name}) =>
      checkConnectionFuture
          .then((_) => loadingStart
              .then((_) => _api
                  .signUpWithEmail(email: email, password: password, name: name)
                  .then((token) => _checkAuth(token).then((isValid) {
                        if (isValid) {
                          _analytics
                              .logSignUp(method: 'email')
                              .catchError(exception);
                        }
                      }))
                  .then((_) => Future.value()))
              .catchError(exception))
          .whenComplete(loadingEnd);

  @override
  Future<void> signOut() => loadingStart
      .then((_) => _encrypted
          .cleanToken()
          .then((_) => _analytics.updateUser())
          .whenComplete(() => _app.auth(AuthState.unauthorized)))
      .whenComplete(loadingEnd);

  @override
  Future<void> restorePassword(String email) => checkConnectionFuture
      .then((_) => _prepare.then((token) => _api.restorePassword(token, email)))
      .catchError(exception)
      .whenComplete(loadingEnd);

  int? _getUserId(TokenModel? token) {
    if (token == null) return null;
    final jwt = _parseToken(token.accessToken);
    final payload = jwt?.payload;
    if (payload != null && payload is Map && payload.containsKey('user')) {
      return int.tryParse(payload['user'].toString());
    } else {
      return null;
    }
  }

  Future<String> get _prepare => loadingStart.then((value) => getToken());

  Future<bool> _checkAuth(TokenModel? token) {
    if (token == null) return Future.value(false);
    final jwt = _parseToken(token.accessToken);
    if (jwt != null) {
      _app.auth(AuthState.authorized);
      return _encrypted.writeToken(token).then((_) => true).whenComplete(() {
        final userId = _getUserId(token);
        if (userId != null) {
          _analytics.updateUser(id: userId);
        }
      });
    } else if (_parseToken(token.refreshToken) != null) {
      return checkConnectionFuture
          .then((_) => _api
              .refreshToken(token.refreshToken)
              .then((value) => _checkAuth(value)))
          .catchError((onError) {
        if (onError is AuthException) {
          signOut();
        }
        return Future.value(false);
      });
    } else {
      _app.auth(AuthState.unauthorized);
      return Future.value(false);
    }
  }

  JWT? _parseToken(String token) {
    final jwt = JWT.tryDecode(token);
    if (jwt == null) return null;
    final payload = jwt.payload;
    if (payload is! Map) return null;
    if (!payload.containsKey('exp')) return null;
    final dateExpired =
        DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000, isUtc: false)
            .add(const Duration(seconds: -1));
    return dateExpired.difference(DateTime.now().toUtc()) > Duration.zero
        ? jwt
        : null;
  }
}
