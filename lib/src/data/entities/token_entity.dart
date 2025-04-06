import '../../domain/models/models.dart';
import 'generated/auth_models.pb.dart';

class TokenEntity {
  final String accessToken;
  final String refreshToken;

  const TokenEntity({required this.accessToken, required this.refreshToken});

  factory TokenEntity.fromGrpc(AuthReply auth) => TokenEntity(
      accessToken: auth.accessToken, refreshToken: auth.refreshToken);

  TokenModel toModel() => TokenModel(
        (p0) => p0
          ..accessToken = accessToken
          ..refreshToken = refreshToken,
      );
}
