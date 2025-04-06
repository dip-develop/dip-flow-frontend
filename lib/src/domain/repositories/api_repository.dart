import 'package:grpc/grpc.dart';

import '../exceptions/exceptions.dart';
import '../models/models.dart';

mixin ApiRepositoryMixin {
  Future<T> checkException<T>(dynamic onError) {
    if (onError is GrpcError) {
      if (onError.code == StatusCode.unauthenticated) {
        throw AuthException.parse(onError.message);
      } else if (onError.code == StatusCode.invalidArgument) {
        final error = AuthException.parse(onError.message);
        throw error.reason == AuthReasonException.undefined
            ? AppException(onError.message ?? onError.toString())
            : error;
      } else if (onError.code == StatusCode.unavailable) {
        throw ConnectionException.connectionNotFound(onError.message);
      } else if (onError.code == StatusCode.deadlineExceeded ||
          onError.code == StatusCode.aborted ||
          onError.code == StatusCode.cancelled) {
        throw ConnectionException.timeout(onError.message);
      } else if (onError.code == StatusCode.notFound ||
          onError.code == StatusCode.permissionDenied) {
        throw ContentException.notFound(onError.message);
      } else {
        throw AppException(onError.message ?? onError.toString());
      }
    } else {
      throw AppException(onError.toString());
    }
  }
}

abstract class ApiRepository {}

abstract class AuthApiRepository extends ApiRepository {
  Future<TokenModel> signInWithEmail({
    required String email,
    required String password,
    required String deviceId,
  });
  Future<TokenModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String deviceId,
  });
  Future<TokenModel> refreshToken(
    String token,
    String deviceId,
  );
  Future<void> restorePassword(
    String token,
    String email,
    String deviceId,
  );
}

abstract class ProfileApiRepository extends ApiRepository {
  Future<ProfileModel> getProfile(
    String token,
    String deviceId,
  );
  Future<void> updateProfile(
      String token, String deviceId, ProfileModel profile);
  Future<void> deleteProfile(
    String token,
    String deviceId,
  );
}

abstract class TimeTrackingRepository extends ApiRepository {
  Future<TimeTrackingModel> getTimeTracking(
      String token, String deviceId, String id);
  Future<PaginationModel<TimeTrackingModel>> getTimeTracks(
      String token, String deviceId,
      {int? limit,
      int? offset,
      String? search,
      DateTime? start,
      DateTime? end});
  Future<TimeTrackingModel> addTimeTracking(
      String token, String deviceId, TimeTrackingModel timeTrack);
  Future<TimeTrackingModel> updateTimeTracking(
      String token, String deviceId, TimeTrackingModel timeTrack);
  Future<void> deleteTimeTracking(String token, String deviceId, String id);
  Future<TimeTrackingModel> startTrack(
      String token, String deviceId, String id);
  Future<TimeTrackingModel> stopTrack(String token, String deviceId, String id);
  Future<void> deleteTrack(String token, String deviceId, String id);
}
