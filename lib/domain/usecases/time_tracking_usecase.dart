import 'package:injectable/injectable.dart';

import '../../core/cubit/application_cubit.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';
import 'auth_usecase.dart';

abstract class TimeTrackingUseCase {
  Future<TimeTrackingModel> getTimeTrack(int id);
  Future<PaginationModel<TimeTrackingModel>> getTimeTracks(
      {int? limit, int? offset});
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
  final ApplicationCubit _app;
  final AuthUseCase _auth;

  const TimeTrackingUseCaseImpl(this._api, this._app, this._auth);

  @override
  Future<TimeTrackingModel> getTimeTrack(int id) => _prepare
      .then((token) => _api.getTimeTrack(token, id))
      .catchError(_app.exception)
      .whenComplete(() => _app.loadingHide());

  @override
  Future<PaginationModel<TimeTrackingModel>> getTimeTracks(
          {int? limit, int? offset}) =>
      _prepare
          .then((token) =>
              _api.getTimeTracks(token, limit: limit, offset: offset))
          .catchError(_app.exception)
          .whenComplete(() => _app.loadingHide());

  @override
  Future<TimeTrackingModel> addTimeTrack(TimeTrackingModel timeTrack) =>
      _prepare
          .then((token) => _api.addTimeTrack(token, timeTrack))
          .catchError(_app.exception)
          .whenComplete(() => _app.loadingHide());

  @override
  Future<TimeTrackingModel> updateTimeTrack(TimeTrackingModel timeTrack) =>
      _prepare
          .then((token) => _api.updateTimeTrack(token, timeTrack))
          .catchError(_app.exception)
          .whenComplete(() => _app.loadingHide());

  @override
  Future<void> deleteTimeTrack(int id) => _prepare
      .then((token) => _api.deleteTimeTrack(token, id))
      .catchError(_app.exception)
      .whenComplete(() => _app.loadingHide());

  @override
  Future<TimeTrackingModel> startTrack(int id) => _prepare
      .then((token) => _api.startTrack(token, id))
      .catchError(_app.exception)
      .whenComplete(() => _app.loadingHide());

  @override
  Future<TimeTrackingModel> stopTrack(int id) => _prepare
      .then((token) => _api.stopTrack(token, id))
      .catchError(_app.exception)
      .whenComplete(() => _app.loadingHide());

  @override
  Future<TimeTrackingModel> deleteTrack(int timeTrackId, int trackId) =>
      _prepare
          .then((token) => _api.deleteTrack(token, timeTrackId, trackId))
          .catchError(_app.exception)
          .whenComplete(() => _app.loadingHide());

  Future<String> get _prepare => Future.delayed(
        Duration.zero,
        () => _app.loadingShow(),
      ).then((value) => _auth.getToken());
}
