import 'package:grpc/grpc_connection_interface.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/models/models.dart';
import '../../../domain/repositories/repositories.dart';
import '../../entities/entities.dart';
import '../../entities/generated/auth_models.pb.dart';
import '../../entities/generated/gate_service.pbgrpc.dart';

@LazySingleton(as: AuthApiRepository)
class AuthGRPCApiRepository
    with ApiRepositoryMixin
    implements AuthApiRepository {
  final ClientChannelBase _channel;

  const AuthGRPCApiRepository(this._channel);

  @override
  Future<TokenModel> signInWithEmail(
          {required String email, required String password}) =>
      _client()
          .signInByEmail(SignInEmailRequest(email: email, password: password))
          .then((auth) => TokenEntity.fromGrpc(auth).toModel())
          .catchError(checkException<TokenModel>);

  @override
  Future<TokenModel> signUpWithEmail(
          {required String email,
          required String password,
          required String name}) =>
      _client()
          .signUpByEmail(
              SignUpEmailRequest(email: email, password: password, name: name))
          .then((auth) => TokenEntity.fromGrpc(auth).toModel())
          .catchError(checkException<TokenModel>);

  @override
  Future<TokenModel> refreshToken(String token) => _client()
      .refreshToken(RefreshTokenRequest(token: token))
      .then((auth) => TokenEntity.fromGrpc(auth).toModel())
      .catchError(checkException<TokenModel>);

  @override
  Future<void> restorePassword(String token, String email) => _client(token)
      .restorePassword(RestorePasswordRequest(email: email))
      .catchError(checkException<TokenModel>);

  AuthGateServiceClient _client([String? token]) =>
      AuthGateServiceClient(_channel,
          options: CallOptions(
              timeout: const Duration(seconds: 4),
              metadata: token != null ? {'authorization': token} : null));
}
