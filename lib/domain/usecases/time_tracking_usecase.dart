import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../core/cubits/content_changed_cubit.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';
import 'usecases.dart';

abstract class TimeTrackingUseCase {
  Future<TimeTrackingModel> getTimeTracking(String id);
  Future<PaginationModel<TimeTrackingModel>> getTimeTrackings({
    int? limit,
    int? offset,
    String? search,
    DateTime? start,
    DateTime? end,
  });
  Future<TimeTrackingModel> addTimeTracking(TimeTrackingModel timeTrack);
  Future<TimeTrackingModel> updateTimeTracking(TimeTrackingModel timeTrack);
  Future<void> deleteTimeTracking(String id);
  Future<TimeTrackingModel> startTrack(String id);
  Future<TimeTrackingModel> stopTrack(String id);
  Future<void> deleteTrack(String timeTrackId, String trackId);
}

@LazySingleton(as: TimeTrackingUseCase)
class TimeTrackingUseCaseImpl implements TimeTrackingUseCase {
  final TimeTrackingRepository _api;
  final AuthUseCase _authUseCase;
  final ContentChangedCubit _contentCubit;

  const TimeTrackingUseCaseImpl(
      this._api, this._authUseCase, this._contentCubit);

  @override
  Future<TimeTrackingModel> getTimeTracking(String id) => getApiRequest(
      _prepare.then((token) => _api.getTimeTracking(token, getDeviceId(), id)),
      _onRetry);

  @override
  Future<PaginationModel<TimeTrackingModel>> getTimeTrackings({
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
          _onRetry);

  @override
  Future<TimeTrackingModel> addTimeTracking(TimeTrackingModel timeTrack) =>
      getApiRequest(
          _prepare
              .then((token) =>
                  _api.addTimeTracking(token, getDeviceId(), timeTrack))
              .then((value) {
            _contentCubit.timeTrackingsChanged();
            return value;
          }),
          _onRetry);

  @override
  Future<TimeTrackingModel> updateTimeTracking(TimeTrackingModel timeTrack) =>
      getApiRequest(
          _prepare
              .then((token) =>
                  _api.updateTimeTracking(token, getDeviceId(), timeTrack))
              .then((value) {
            _contentCubit.timeTrackChanged(value);
            return value;
          }),
          _onRetry);

  @override
  Future<void> deleteTimeTracking(String id) => getApiRequest(
      _prepare
          .then((token) => _api.deleteTimeTracking(token, getDeviceId(), id))
          .then((_) {
        _contentCubit.timeTrackingsChanged();
      }),
      _onRetry);

  @override
  Future<TimeTrackingModel> startTrack(String id) => getApiRequest(
      _prepare
          .then((token) => _api.startTrack(token, getDeviceId(), id))
          .then((value) {
        _contentCubit.timeTrackChanged(value);
        return value;
      }),
      _onRetry);

  @override
  Future<TimeTrackingModel> stopTrack(String id) => getApiRequest(
        _prepare
            .then((token) => _api.stopTrack(token, getDeviceId(), id))
            .then((value) {
          _contentCubit.timeTrackChanged(value);
          return value;
        }),
        _onRetry,
      );

  @override
  Future<void> deleteTrack(String timeTrackId, String trackId) => getApiRequest(
        _prepare
            .then((token) => _api.deleteTrack(token, getDeviceId(), trackId))
            .then((_) => getTimeTracking(timeTrackId)
                .then((value) => _contentCubit.timeTrackChanged(value))),
        _onRetry,
      );

  Future<String> get _prepare => checkConnectionFuture
      .then((_) => loadingStart.then((value) => _authUseCase.getAPIToken()));

  FutureOr<void> _onRetry(Exception exception) => _authUseCase.getToken().then(
      (token) => _authUseCase.checkAuth(token).then((_) => Future.value()));
}
