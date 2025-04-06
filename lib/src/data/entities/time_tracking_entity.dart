import 'package:built_collection/built_collection.dart';

import '../../domain/models/models.dart';
import 'generated/time_tracking_models.pb.dart';

class TimeTrackingEntity {
  final String id;
  final String userId;
  final String? taskId;
  final String? title;
  final String? description;
  final List<TrackEntity> tracks;

  const TimeTrackingEntity(
      {required this.id,
      required this.userId,
      this.taskId,
      this.title,
      this.description,
      this.tracks = const <TrackEntity>[]});

  factory TimeTrackingEntity.fromGrpc(TimeTrackingReply timeTrack) =>
      TimeTrackingEntity(
          id: timeTrack.id,
          userId: timeTrack.userId,
          taskId: timeTrack.hasTaskId() ? timeTrack.taskId : null,
          title: timeTrack.hasTitle() && timeTrack.title.isNotEmpty
              ? timeTrack.title
              : null,
          description:
              timeTrack.hasDescription() && timeTrack.description.isNotEmpty
                  ? timeTrack.description
                  : null,
          tracks:
              timeTrack.tracks.map((e) => TrackEntity.fromGrpc(e)).toList());

  TimeTrackingModel toModel() => TimeTrackingModel(
        (p0) => p0
          ..id = id
          ..userId = userId
          ..taskId = taskId
          ..title = title
          ..description = description
          ..tracks = ListBuilder(tracks.map((e) => e.toModel())),
      );
}

class TrackEntity {
  final String id;
  final DateTime start;
  final DateTime? end;

  TrackEntity({required this.id, required this.start, this.end});

  factory TrackEntity.fromGrpc(TrackReply track) => TrackEntity(
      id: track.id,
      start: track.start.toDateTime(),
      end: track.hasEnd() ? track.end.toDateTime() : null);

  TrackModel toModel() => TrackModel(
        (p0) => p0
          ..id = id
          ..start = start.toLocal()
          ..end = end?.toLocal(),
      );
}
