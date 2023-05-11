import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/models/models.dart';
import '../../../domain/repositories/repositories.dart';
import '../../entities/entities.dart';
import '../../entities/generated/base_models.pb.dart';
import '../../entities/generated/gate_models.pb.dart';
import '../../entities/generated/gate_service.pbgrpc.dart';
import '../../entities/generated/google/protobuf/timestamp.pb.dart';
import '../../entities/generated/time_tracking_models.pb.dart'
    as time_tracking_models;

@LazySingleton(as: TimeTrackingRepository)
class TimeTrackingGRPCApiRepository
    with ApiRepositoryMixin
    implements TimeTrackingRepository {
  final ClientChannel _channel;

  const TimeTrackingGRPCApiRepository(this._channel);

  @override
  Future<TimeTrackingModel> getTimeTrack(String token, int id) => _client(token)
      .getTimeTrack(IdRequest(id: id))
      .then((reply) => TimeTrackingEntity.fromGrpc(reply).toModel())
      .catchError(checkException<TimeTrackingModel>);

  @override
  Future<PaginationModel<TimeTrackingModel>> getTimeTracks(
    String token, {
    int? limit,
    int? offset,
    String? search,
    DateTime? start,
    DateTime? end,
  }) =>
      _client(token)
          .getTimeTracks(
            GetTimeTrackRequest(
              pagination: limit != null || offset != null
                  ? PaginationRequest(limit: limit, offset: offset)
                  : null,
              search: search != null ? SearchRequest(search: search) : null,
              dateRange: start != null || end != null
                  ? DateRangeRequest(
                      start: start != null
                          ? Timestamp.fromDateTime(start.toUtc())
                          : null,
                      end: end != null
                          ? Timestamp.fromDateTime(end.toUtc())
                          : null,
                    )
                  : null,
            ),
          )
          .then((reply) => PaginationEntity.fromGrpc(reply).toModel())
          .catchError(checkException<PaginationModel<TimeTrackingModel>>);

  @override
  Future<TimeTrackingModel> addTimeTrack(
          String token, TimeTrackingModel timeTrack) =>
      _client(token)
          .addTimeTrack(AddTimeTrackRequest(
              task: timeTrack.task,
              title: timeTrack.title,
              description: timeTrack.description))
          .then((reply) => TimeTrackingEntity.fromGrpc(reply).toModel())
          .catchError(checkException<TimeTrackingModel>);

  @override
  Future<TimeTrackingModel> updateTimeTrack(
          String token, TimeTrackingModel timeTrack) =>
      _client(token)
          .updateTimeTrack(time_tracking_models.UpdateTimeTrackRequest(
              id: timeTrack.id,
              task: timeTrack.task,
              title: timeTrack.title,
              description: timeTrack.description))
          .then((reply) => TimeTrackingEntity.fromGrpc(reply).toModel())
          .catchError(checkException<TimeTrackingModel>);

  @override
  Future<void> deleteTimeTrack(String token, int id) => _client(token)
      .deleteTimeTrack(IdRequest(id: id))
      .then((_) => Future.value())
      .catchError(checkException<void>);

  @override
  Future<TimeTrackingModel> startTrack(String token, int id) => _client(token)
      .startTrack(IdRequest(id: id))
      .then((reply) => TimeTrackingEntity.fromGrpc(reply).toModel())
      .catchError(checkException<TimeTrackingModel>);

  @override
  Future<TimeTrackingModel> stopTrack(String token, int id) => _client(token)
      .stopTrack(IdRequest(id: id))
      .then((reply) => TimeTrackingEntity.fromGrpc(reply).toModel())
      .catchError(checkException<TimeTrackingModel>);

  @override
  Future<TimeTrackingModel> deleteTrack(
          String token, int timeTrackId, int trackId) =>
      _client(token)
          .deleteTrack(time_tracking_models.DeleteTrackRequest(
              id: timeTrackId, trackId: trackId))
          .then((reply) => TimeTrackingEntity.fromGrpc(reply).toModel())
          .catchError(checkException<TimeTrackingModel>);

  TimeTrackingGateServiceClient _client(String token) =>
      TimeTrackingGateServiceClient(_channel,
          options: CallOptions(
              timeout: const Duration(seconds: 4),
              metadata: {'authorization': token}));
}
