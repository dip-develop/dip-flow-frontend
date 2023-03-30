import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/exceptions/exceptions.dart';
import '../../../domain/models/models.dart';
import '../../../domain/repositories/repositories.dart';
import '../../entities/entities.dart';
import '../../entities/generated/auth_models.pb.dart';
import '../../entities/generated/gate_service.pbgrpc.dart';

@LazySingleton(as: ApiRepository)
class GRPCApiRepository implements ApiRepository {
  late final GateServiceClient _stub;

  GRPCApiRepository() {
    final channel = ClientChannel('musmula.dipdev.studio',
        port: 8080,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));

    _stub = GateServiceClient(channel,
        options: CallOptions(timeout: const Duration(seconds: 4)));
  }

  @override
  Future<TokenModel> signInWithEmail(
          {required String email, required String password}) =>
      _stub
          .signInByEmail(SignInEmailRequest(email: email, password: password))
          .then((auth) => TokenEntity.fromGrpc(auth).toModel())
          .catchError(_checkException<TokenModel>);

  @override
  Future<TokenModel> signUpWithEmail(
          {required String email,
          required String password,
          required String name}) =>
      _stub
          .signUpByEmail(
              SignUpEmailRequest(email: email, password: password, name: name))
          .then((auth) => TokenEntity.fromGrpc(auth).toModel())
          .catchError(_checkException<TokenModel>);

  @override
  Future<TokenModel> refreshToken(String token) => _stub
      .refreshToken(RefreshTokenRequest(token: token))
      .then((auth) => TokenEntity.fromGrpc(auth).toModel())
      .catchError(_checkException<TokenModel>);

  Future<T> _checkException<T>(dynamic onError) {
    if (onError is GrpcError) {
      if (onError.code == StatusCode.unauthenticated) {
        throw AuthException.invalidData(onError.message);
      }
    }
    throw AppException(onError.toString());
  }
}
