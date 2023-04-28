import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/exceptions/exceptions.dart';
import '../../../domain/models/models.dart';
import '../../../domain/repositories/repositories.dart';
import '../../entities/entities.dart';
import '../../entities/generated/auth_models.pb.dart';
import '../../entities/generated/gate_service.pbgrpc.dart';
import '../../entities/generated/google/protobuf/empty.pb.dart';

@LazySingleton(as: ProfileApiRepository)
class ProfileGRPCApiRepository implements ProfileApiRepository {
  final ClientChannel _channel;

  const ProfileGRPCApiRepository(this._channel);

  @override
  Future<ProfileModel> getProfile(String token) => _client(token)
      .getProfile(Empty())
      .then((p0) => ProfileEntity.fromGrpc(p0).toModel())
      .catchError(_checkException<ProfileModel>);

  @override
  Future<void> updateProfile(String token, ProfileModel profile) =>
      _client(token)
          .updateProfile(UserRequest(
              name: profile.name,
              price: profile.price,
              workDays: profile.workDays))
          .catchError(_checkException<TokenModel>);

  @override
  Future<void> deleteProfile(String token) => _client(token)
      .deleteProfile(Empty())
      .catchError(_checkException<TokenModel>);

  ProfileGateServiceClient _client([String? token]) =>
      ProfileGateServiceClient(_channel,
          options: CallOptions(
              timeout: const Duration(seconds: 4),
              metadata: token != null ? {'authorization': token} : null));

  Future<T> _checkException<T>(dynamic onError) {
    if (onError is GrpcError) {
      if (onError.code == StatusCode.unauthenticated) {
        throw AuthException.invalidData(onError.message);
      } else if (onError.code == StatusCode.unavailable) {
        throw ConnectionException.connectionNotFound(onError.message);
      } else if (onError.code == StatusCode.deadlineExceeded) {
        throw ConnectionException.timeout(onError.message);
      }
    }
    throw AppException(onError.toString());
  }
}
