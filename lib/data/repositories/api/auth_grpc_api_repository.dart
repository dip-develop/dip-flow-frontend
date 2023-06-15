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
  Future<TokenModel> signInWithEmail({
    required String email,
    required String password,
    required String deviceId,
  }) =>
      _client(deviceId: deviceId)
          .signInByEmail(SignInEmailRequest(email: email, password: password))
          .then((auth) => TokenEntity.fromGrpc(auth).toModel())
          .catchError(checkException<TokenModel>);

  @override
  Future<TokenModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String deviceId,
  }) =>
      _client(deviceId: deviceId)
          .signUpByEmail(
              SignUpEmailRequest(email: email, password: password, name: name))
          .then((auth) => TokenEntity.fromGrpc(auth).toModel())
          .catchError(checkException<TokenModel>);

  @override
  Future<TokenModel> refreshToken(
    String token,
    String deviceId,
  ) =>
      _client(deviceId: deviceId)
          .refreshToken(RefreshTokenRequest(token: token))
          .then((auth) => TokenEntity.fromGrpc(auth).toModel())
          .catchError(checkException<TokenModel>);

  @override
  Future<void> restorePassword(
    String token,
    String email,
    String deviceId,
  ) =>
      _client(token: token, deviceId: deviceId)
          .restorePassword(RestorePasswordRequest(email: email))
          .catchError(checkException<TokenModel>);

  AuthGateServiceClient _client({String? token, String? deviceId}) =>
      AuthGateServiceClient(_channel,
          options: CallOptions(timeout: const Duration(seconds: 4), metadata: {
            if (token != null) 'authorization': token,
            if (deviceId != null) 'deviceId': deviceId,
          }));
}
