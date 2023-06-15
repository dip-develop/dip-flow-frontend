import 'dart:async';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../core/cubits/application_cubit.dart';
import '../exceptions/auth_exception.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';
import 'usecases.dart';

abstract class AuthUseCase {
  Future<bool> get isAuth;
  Future<TokenModel?> getToken();
  Future<String> getAPIToken();
  Future<void> signInWithEmail(
      {required String email, required String password});
  Future<void> signUpWithEmail(
      {required String email, required String password, required String name});
  Future<void> signOut();
  Future<void> restorePassword(String email);
  Future<bool> checkAuth(TokenModel? token);
  Future<bool> refreshToken(TokenModel? token);
}

@LazySingleton(as: AuthUseCase)
class AuthUseCaseImpl implements AuthUseCase {
  final AuthApiRepository _api;
  final AnalyticsRepository _analytics;
  final EncryptedPreferencesRepository _encrypted;
  final ApplicationCubit _app;

  AuthUseCaseImpl(this._app, this._analytics, this._api, this._encrypted);

  bool _isTokenRefreshProgress = false;

  Future<void> _waitWhile() async {
    while (_isTokenRefreshProgress) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  Future<TokenModel?> getToken() =>
      _waitWhile().then((_) => _encrypted.readToken());

  @override
  Future<bool> get isAuth => loadingStart
      .then((_) => getToken().then((token) => checkAuth(token)))
      .whenComplete(loadingEnd);

  @override
  Future<String> getAPIToken() =>
      getToken().then((token) => checkAuth(token).then((isValid) {
            if (!isValid) {
              throw AuthException.needAuth();
            }
            return 'Bearer ${token!.accessToken}';
          }));

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) =>
      checkConnectionFuture
          .then((_) => loadingStart
              .then((_) => _api
                  .signInWithEmail(
                    email: email,
                    password: password,
                    deviceId: getDeviceId(),
                  )
                  .then((token) => checkAuth(token).then((isValid) {
                        if (isValid) {
                          _analytics
                              .logSignIn(method: 'email')
                              .catchError(exception);
                        }
                      })))
              .catchError(exception))
          .whenComplete(loadingEnd);

  @override
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) =>
      checkConnectionFuture
          .then((_) => loadingStart
              .then((_) => _api
                  .signUpWithEmail(
                    email: email,
                    password: password,
                    name: name,
                    deviceId: getDeviceId(),
                  )
                  .then((token) => checkAuth(token).then((isValid) {
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
      .then((_) => _prepare
          .then((token) => _api.restorePassword(token, getDeviceId(), email)))
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

  Future<String> get _prepare => loadingStart.then((value) => getAPIToken());

  @override
  Future<bool> checkAuth(TokenModel? token) {
    if (token == null) {
      return Future.value(false);
    }
    if (_parseToken(token.accessToken) != null) {
      _app.auth(AuthState.authorized);
      return _encrypted.writeToken(token).then((_) => true).whenComplete(() {
        final userId = _getUserId(token);
        if (userId != null) {
          _analytics.updateUser(id: userId);
        }
      });
    } else {
      return refreshToken(token).then((value) {
        if (!value) {
          _app.auth(AuthState.unauthorized);
        }
        return value;
      }).catchError((onError) {
        debugPrint(onError);
        throw onError;
      });
    }
  }

  @override
  Future<bool> refreshToken(TokenModel? token) async {
    if (token == null || _parseToken(token.refreshToken) == null) {
      return Future.value(false);
    } else if (_isTokenRefreshProgress) {
      return _waitWhile()
          .then((_) => getToken().then((value) => checkAuth(token)));
    } else {
      _isTokenRefreshProgress = true;
      return checkConnectionFuture
          .then((_) => _api.refreshToken(
                token.refreshToken,
                getDeviceId(),
              ))
          .then((value) => checkAuth(value))
          .catchError((onError) {
        if (onError is AuthException &&
            onError.reason == AuthReasonException.needAuth) {
          signOut();
        }
        return Future.value(false);
      }).whenComplete(() => _isTokenRefreshProgress = false);
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
