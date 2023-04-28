import '../models/models.dart';

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
