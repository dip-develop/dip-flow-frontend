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
  Future<TimeTrackingModel> getTimeTracking(
          String token, String deviceId, String id) =>
      _client(
        token: token,
        deviceId: deviceId,
      )
          .getTimeTracking(IdRequest(id: id))
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
          .getTimeTrackings(
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
  Future<TimeTrackingModel> addTimeTracking(
          String token, String deviceId, TimeTrackingModel timeTrack) =>
      _client(
        token: token,
        deviceId: deviceId,
      )
          .addTimeTracking(gate.AddTimeTrackingRequest(
              taskId: timeTrack.taskId,
              title: timeTrack.title,
              description: timeTrack.description))
          .then((reply) => TimeTrackingEntity.fromGrpc(reply).toModel())
          .catchError(checkException<TimeTrackingModel>);

  @override
  Future<TimeTrackingModel> updateTimeTracking(
          String token, String deviceId, TimeTrackingModel timeTrack) =>
      _client(
        token: token,
        deviceId: deviceId,
      )
          .updateTimeTracking(time_tracking_models.UpdateTimeTrackingRequest(
              id: timeTrack.id,
              taskId: timeTrack.taskId,
              title: timeTrack.title,
              description: timeTrack.description))
          .then((reply) => TimeTrackingEntity.fromGrpc(reply).toModel())
          .catchError(checkException<TimeTrackingModel>);

  @override
  Future<void> deleteTimeTracking(String token, String deviceId, String id) =>
      _client(
        token: token,
        deviceId: deviceId,
      )
          .deleteTimeTracking(IdRequest(id: id))
          .then((_) => Future.value())
          .catchError(checkException<void>);

  @override
  Future<TimeTrackingModel> startTrack(
          String token, String deviceId, String id) =>
      _client(
        token: token,
        deviceId: deviceId,
      )
          .startTrack(IdRequest(id: id))
          .then((reply) => TimeTrackingEntity.fromGrpc(reply).toModel())
          .catchError(checkException<TimeTrackingModel>);

  @override
  Future<TimeTrackingModel> stopTrack(
          String token, String deviceId, String id) =>
      _client(
        token: token,
        deviceId: deviceId,
      )
          .stopTrack(IdRequest(id: id))
          .then((reply) => TimeTrackingEntity.fromGrpc(reply).toModel())
          .catchError(checkException<TimeTrackingModel>);

  @override
  Future<void> deleteTrack(String token, String deviceId, String id) => _client(
        token: token,
        deviceId: deviceId,
      )
          .deleteTrack(IdRequest(id: id))
          .then((_) => Future.value())
          .catchError(checkException<void>);

  TimeTrackingGateServiceClient _client({String? token, String? deviceId}) =>
      TimeTrackingGateServiceClient(_channel,
          options: CallOptions(timeout: const Duration(seconds: 4), metadata: {
            if (token != null) 'authorization': token,
            if (deviceId != null) 'deviceId': deviceId,
          }));
}
