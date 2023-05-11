import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/models/models.dart';
import '../../../domain/repositories/repositories.dart';
import '../../entities/entities.dart';
import '../../entities/generated/auth_models.pb.dart';
import '../../entities/generated/gate_service.pbgrpc.dart';
import '../../entities/generated/google/protobuf/empty.pb.dart';

@LazySingleton(as: ProfileApiRepository)
class ProfileGRPCApiRepository
    with ApiRepositoryMixin
    implements ProfileApiRepository {
  final ClientChannel _channel;

  const ProfileGRPCApiRepository(this._channel);

  @override
  Future<ProfileModel> getProfile(String token) => _client(token)
      .getProfile(Empty())
      .then((p0) => ProfileEntity.fromGrpc(p0).toModel())
      .catchError(checkException<ProfileModel>);

  @override
  Future<void> updateProfile(String token, ProfileModel profile) =>
      _client(token)
          .updateProfile(UserRequest(
              name: profile.name,
              price: profile.price,
              workDays: profile.workDays))
          .catchError(checkException<TokenModel>);

  @override
  Future<void> deleteProfile(String token) => _client(token)
      .deleteProfile(Empty())
      .catchError(checkException<TokenModel>);

  ProfileGateServiceClient _client([String? token]) =>
      ProfileGateServiceClient(_channel,
          options: CallOptions(
              timeout: const Duration(seconds: 4),
              metadata: token != null ? {'authorization': token} : null));
}
