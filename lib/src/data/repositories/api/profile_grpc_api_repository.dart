import 'package:grpc/grpc_connection_interface.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/models/models.dart';
import '../../../domain/repositories/repositories.dart';
import '../../entities/entities.dart';
import '../../entities/generated/gate_service.pbgrpc.dart';
import '../../entities/generated/google/protobuf/empty.pb.dart';
import '../../entities/generated/user_models.pb.dart';

@LazySingleton(as: ProfileApiRepository)
class ProfileGRPCApiRepository
    with ApiRepositoryMixin
    implements ProfileApiRepository {
  final ClientChannelBase _channel;

  const ProfileGRPCApiRepository(this._channel);

  @override
  Future<ProfileModel> getProfile(
    String token,
    String deviceId,
  ) =>
      _client(
        token: token,
        deviceId: deviceId,
      )
          .getProfile(Empty())
          .then((p0) => ProfileEntity.fromGrpc(p0).toModel())
          .catchError(checkException<ProfileModel>);

  @override
  Future<void> updateProfile(
          String token, String deviceId, ProfileModel profile) =>
      _client(
        token: token,
        deviceId: deviceId,
      )
          .updateProfile(UserRequest(
              name: profile.name,
              price: profile.price,
              workDays: profile.workDays))
          .catchError(checkException<TokenModel>);

  @override
  Future<void> deleteProfile(
    String token,
    String deviceId,
  ) =>
      _client(
        token: token,
        deviceId: deviceId,
      ).deleteProfile(Empty()).catchError(checkException<TokenModel>);

  ProfileGateServiceClient _client({String? token, String? deviceId}) =>
      ProfileGateServiceClient(_channel,
          options: CallOptions(timeout: const Duration(seconds: 4), metadata: {
            if (token != null) 'authorization': token,
            if (deviceId != null) 'deviceId': deviceId,
          }));
}
