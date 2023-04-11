import 'package:built_collection/built_collection.dart';

import '../../domain/models/models.dart';
import 'generated/time_tracking_models.pb.dart';

class TimeTrackingEntity {
  final int id;
  final int userId;
  final String? task;
  final String? title;
  final String? description;
  final List<TrackEntity> tracks;

  const TimeTrackingEntity(
      {required this.id,
      required this.userId,
      this.task,
      this.title,
      this.description,
      this.tracks = const <TrackEntity>[]});

  factory TimeTrackingEntity.fromGrpc(TimeTrackReply timeTrack) =>
      TimeTrackingEntity(
          id: timeTrack.id,
          userId: timeTrack.userId,
          task: timeTrack.task.isNotEmpty ? timeTrack.task : null,
          title: timeTrack.title.isNotEmpty ? timeTrack.title : null,
          description:
              timeTrack.description.isNotEmpty ? timeTrack.description : null,
          tracks:
              timeTrack.tracks.map((e) => TrackEntity.fromGrpc(e)).toList());

  TimeTrackingModel toModel() => TimeTrackingModel(
        (p0) => p0
          ..id = id
          ..userId = userId
          ..task = task
          ..title = title
          ..description = description
          ..tracks = ListBuilder(tracks.map((e) => e.toModel())),
      );
}

class TrackEntity {
  final int id;
  final DateTime start;
  final DateTime? end;

  TrackEntity({required this.id, required this.start, this.end});

  factory TrackEntity.fromGrpc(TrackReply track) => TrackEntity(
      id: track.id,
      start: track.start.toDateTime(),
      end: track.end.seconds.isZero && track.end.nanos == 0
          ? null
          : track.end.toDateTime());

  TrackModel toModel() => TrackModel(
        (p0) => p0
          ..id = id
          ..start = start
          ..end = end,
      );
}
