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
  Future<TokenModel> signInWithEmail(
      {required String email, required String password});
  Future<TokenModel> signUpWithEmail(
      {required String email, required String password, required String name});
  Future<TokenModel> refreshToken(String token);
  Future<void> restorePassword(String token, String email);
}

abstract class ProfileApiRepository extends ApiRepository {
  Future<ProfileModel> getProfile(String token);
  Future<void> updateProfile(String token, ProfileModel profile);
  Future<void> deleteProfile(String token);
}

abstract class TimeTrackingRepository extends ApiRepository {
  Future<TimeTrackingModel> getTimeTrack(String token, int id);
  Future<PaginationModel<TimeTrackingModel>> getTimeTracks(
    String token, {
    int? limit,
    int? offset,
    String? search,
    DateTime? start,
    DateTime? end,
  });
  Future<TimeTrackingModel> addTimeTrack(
      String token, TimeTrackingModel timeTrack);
  Future<TimeTrackingModel> updateTimeTrack(
      String token, TimeTrackingModel timeTrack);
  Future<void> deleteTimeTrack(String token, int id);
  Future<TimeTrackingModel> startTrack(String token, int id);
  Future<TimeTrackingModel> stopTrack(String token, int id);
  Future<TimeTrackingModel> deleteTrack(
      String token, int timeTrackId, int trackId);
}
