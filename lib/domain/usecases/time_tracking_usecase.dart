import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../core/cubits/content_changed_cubit.dart';
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
  final AuthUseCase _authUseCase;
  final ContentChangedCubit _contentCubit;

  const TimeTrackingUseCaseImpl(
      this._api, this._authUseCase, this._contentCubit);

  @override
  Future<TimeTrackingModel> getTimeTrack(int id) => getApiRequest(
        _prepare.then((token) => _api.getTimeTrack(token, getDeviceId(), id)),
        _onRetry,
      );

  @override
  Future<PaginationModel<TimeTrackingModel>> getTimeTracks({
    int? limit,
    int? offset,
    String? search,
    DateTime? start,
    DateTime? end,
  }) =>
      getApiRequest(
        _prepare.then((token) => _api.getTimeTracks(
              token,
              getDeviceId(),
              limit: limit,
              offset: offset,
              search: search,
              start: start,
              end: end,
            )),
        _onRetry,
      );

  @override
  Future<TimeTrackingModel> addTimeTrack(TimeTrackingModel timeTrack) =>
      getApiRequest(
        _prepare
            .then((token) => _api.addTimeTrack(token, getDeviceId(), timeTrack))
            .then((value) {
          _contentCubit.timeTracksChanged();
          return value;
        }),
        _onRetry,
      );

  @override
  Future<TimeTrackingModel> updateTimeTrack(TimeTrackingModel timeTrack) =>
      getApiRequest(
        _prepare
            .then((token) =>
                _api.updateTimeTrack(token, getDeviceId(), timeTrack))
            .then((value) {
          _contentCubit.timeTrackChanged(value);
          return value;
        }),
        _onRetry,
      );

  @override
  Future<void> deleteTimeTrack(int id) => getApiRequest(
        _prepare
            .then((token) => _api.deleteTimeTrack(token, getDeviceId(), id))
            .then((_) {
          _contentCubit.timeTracksChanged();
        }),
        _onRetry,
      );

  @override
  Future<TimeTrackingModel> startTrack(int id) => getApiRequest(
        _prepare
            .then((token) => _api.startTrack(token, getDeviceId(), id))
            .then((value) {
          _contentCubit.timeTrackChanged(value);
          return value;
        }),
        _onRetry,
      );

  @override
  Future<TimeTrackingModel> stopTrack(int id) => getApiRequest(
        _prepare
            .then((token) => _api.stopTrack(token, getDeviceId(), id))
            .then((value) {
          _contentCubit.timeTrackChanged(value);
          return value;
        }),
        _onRetry,
      );

  @override
  Future<TimeTrackingModel> deleteTrack(int timeTrackId, int trackId) =>
      getApiRequest(
        _prepare
            .then((token) =>
                _api.deleteTrack(token, getDeviceId(), timeTrackId, trackId))
            .then((value) {
          _contentCubit.timeTrackChanged(value);
          return value;
        }),
        _onRetry,
      );

  Future<String> get _prepare => checkConnectionFuture
      .then((_) => loadingStart.then((value) => _authUseCase.getAPIToken()));

  FutureOr<void> _onRetry(Exception exception) => _authUseCase.getToken().then(
      (token) => _authUseCase.checkAuth(token).then((_) => Future.value()));
}
