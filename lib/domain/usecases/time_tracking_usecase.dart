import 'package:injectable/injectable.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';
import 'usecases.dart';

abstract class TimeTrackingUseCase {
  Future<TimeTrackingModel> getTimeTrack(int id);
  Future<PaginationModel<TimeTrackingModel>> getTimeTracks({
    int? limit,
    int? offset,
    String? search,
    DateTime? start,
    DateTime? end,
  });
  Future<TimeTrackingModel> addTimeTrack(TimeTrackingModel timeTrack);
  Future<TimeTrackingModel> updateTimeTrack(TimeTrackingModel timeTrack);
  Future<void> deleteTimeTrack(int id);
  Future<TimeTrackingModel> startTrack(int id);
  Future<TimeTrackingModel> stopTrack(int id);
  Future<TimeTrackingModel> deleteTrack(int timeTrackId, int trackId);
}

@LazySingleton(as: TimeTrackingUseCase)
class TimeTrackingUseCaseImpl implements TimeTrackingUseCase {
  final TimeTrackingRepository _api;
  final AuthUseCase _auth;

  const TimeTrackingUseCaseImpl(this._api, this._auth);

  @override
  Future<TimeTrackingModel> getTimeTrack(int id) => _prepare
      .then((token) => _api.getTimeTrack(token, id))
      .catchError(exception)
      .whenComplete(loadingEnd);

  @override
  Future<PaginationModel<TimeTrackingModel>> getTimeTracks({
    int? limit,
    int? offset,
    String? search,
    DateTime? start,
    DateTime? end,
  }) =>
      _prepare
          .then((token) => _api.getTimeTracks(
                token,
                limit: limit,
                offset: offset,
                search: search,
                start: start,
                end: end,
              ))
          .catchError(exception)
          .whenComplete(loadingEnd);

  @override
  Future<TimeTrackingModel> addTimeTrack(TimeTrackingModel timeTrack) =>
      _prepare
          .then((token) => _api.addTimeTrack(token, timeTrack))
          .catchError(exception)
          .whenComplete(loadingEnd);

  @override
  Future<TimeTrackingModel> updateTimeTrack(TimeTrackingModel timeTrack) =>
      _prepare
          .then((token) => _api.updateTimeTrack(token, timeTrack))
          .catchError(exception)
          .whenComplete(loadingEnd);

  @override
  Future<void> deleteTimeTrack(int id) => _prepare
      .then((token) => _api.deleteTimeTrack(token, id))
      .catchError(exception)
      .whenComplete(loadingEnd);

  @override
  Future<TimeTrackingModel> startTrack(int id) => _prepare
      .then((token) => _api.startTrack(token, id))
      .catchError(exception)
      .whenComplete(loadingEnd);

  @override
  Future<TimeTrackingModel> stopTrack(int id) => _prepare
      .then((token) => _api.stopTrack(token, id))
      .catchError(exception)
      .whenComplete(loadingEnd);

  @override
  Future<TimeTrackingModel> deleteTrack(int timeTrackId, int trackId) =>
      _prepare
          .then((token) => _api.deleteTrack(token, timeTrackId, trackId))
          .catchError(exception)
          .whenComplete(loadingEnd);

  Future<String> get _prepare => loadingStart.then((value) => _auth.getToken());
}
