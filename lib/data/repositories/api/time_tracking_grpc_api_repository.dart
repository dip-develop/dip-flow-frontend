import 'package:grpc/grpc_connection_interface.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/models/models.dart';
import '../../../domain/repositories/repositories.dart';
import '../../entities/entities.dart';
import '../../entities/generated/base_models.pb.dart';
import '../../entities/generated/gate_models.pb.dart' as gate;
import '../../entities/generated/gate_service.pbgrpc.dart';
import '../../entities/generated/google/protobuf/timestamp.pb.dart';
import '../../entities/generated/time_tracking_models.pb.dart'
    as time_tracking_models;

@LazySingleton(as: TimeTrackingRepository)
class TimeTrackingGRPCApiRepository
    with ApiRepositoryMixin
    implements TimeTrackingRepository {
  final ClientChannelBase _channel;

  const TimeTrackingGRPCApiRepository(this._channel);

  @override
  Future<TimeTrackingModel> getTimeTrack(
          String token, String deviceId, int id) =>
      _client(
        token: token,
        deviceId: deviceId,
      )
          .getTimeTrack(IdRequest(id: id))
          .then((reply) => TimeTrackingEntity.fromGrpc(reply).toModel())
          .catchError(checkException<TimeTrackingModel>);

  @override
  Future<PaginationModel<TimeTrackingModel>> getTimeTracks(
    String token,
    String deviceId, {
    int? limit,
    int? offset,
    String? search,
    DateTime? start,
    DateTime? end,
  }) =>
      _client(
        token: token,
        deviceId: deviceId,
      )
          .getTimeTracks(
            gate.FilterRequest(
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
          String token, String deviceId, TimeTrackingModel timeTrack) =>
      _client(
        token: token,
        deviceId: deviceId,
      )
          .addTimeTrack(gate.AddTimeTrackRequest(
              taskId: timeTrack.taskId,
              title: timeTrack.title,
              description: timeTrack.description))
          .then((reply) => TimeTrackingEntity.fromGrpc(reply).toModel())
          .catchError(checkException<TimeTrackingModel>);

  @override
  Future<TimeTrackingModel> updateTimeTrack(
          String token, String deviceId, TimeTrackingModel timeTrack) =>
      _client(
        token: token,
        deviceId: deviceId,
      )
          .updateTimeTrack(time_tracking_models.UpdateTimeTrackRequest(
              id: timeTrack.id,
              taskId: timeTrack.taskId,
              title: timeTrack.title,
              description: timeTrack.description))
          .then((reply) => TimeTrackingEntity.fromGrpc(reply).toModel())
          .catchError(checkException<TimeTrackingModel>);

  @override
  Future<void> deleteTimeTrack(String token, String deviceId, int id) =>
      _client(
        token: token,
        deviceId: deviceId,
      )
          .deleteTimeTrack(IdRequest(id: id))
          .then((_) => Future.value())
          .catchError(checkException<void>);

  @override
  Future<TimeTrackingModel> startTrack(String token, String deviceId, int id) =>
      _client(
        token: token,
        deviceId: deviceId,
      )
          .startTrack(IdRequest(id: id))
          .then((reply) => TimeTrackingEntity.fromGrpc(reply).toModel())
          .catchError(checkException<TimeTrackingModel>);

  @override
  Future<TimeTrackingModel> stopTrack(String token, String deviceId, int id) =>
      _client(
        token: token,
        deviceId: deviceId,
      )
          .stopTrack(IdRequest(id: id))
          .then((reply) => TimeTrackingEntity.fromGrpc(reply).toModel())
          .catchError(checkException<TimeTrackingModel>);

  @override
  Future<TimeTrackingModel> deleteTrack(
          String token, String deviceId, int timeTrackId, int trackId) =>
      _client(
        token: token,
        deviceId: deviceId,
      )
          .deleteTrack(time_tracking_models.DeleteTrackRequest(
              id: timeTrackId, trackId: trackId))
          .then((reply) => TimeTrackingEntity.fromGrpc(reply).toModel())
          .catchError(checkException<TimeTrackingModel>);

  TimeTrackingGateServiceClient _client({String? token, String? deviceId}) =>
      TimeTrackingGateServiceClient(_channel,
          options: CallOptions(timeout: const Duration(seconds: 4), metadata: {
            if (token != null) 'authorization': token,
            if (deviceId != null) 'deviceId': deviceId,
          }));
}
