import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:collection/collection.dart';

import 'models.dart';

part 'time_tracking_model.g.dart';

abstract class TimeTrackingModel
    implements BaseModel, Built<TimeTrackingModel, TimeTrackingModelBuilder> {
  @override
  String? get id;
  String? get userId;
  String? get taskId;
  String? get title;
  String? get description;
  BuiltList<TrackModel> get tracks;

  TimeTrackingModel._();
  factory TimeTrackingModel([void Function(TimeTrackingModelBuilder) updates]) =
      _$TimeTrackingModel;

  bool get isStarted => tracks.any((element) => element.isStarted);

  Duration get duration {
    final milliseconds = tracks.map((e) => e.duration.inMilliseconds).sum;
    return Duration(milliseconds: milliseconds);
  }
}

abstract class TrackModel
    implements BaseModel, Built<TrackModel, TrackModelBuilder> {
  @override
  String? get id;
  DateTime get start;
  DateTime? get end;

  TrackModel._();
  factory TrackModel([void Function(TrackModelBuilder) updates]) = _$TrackModel;

  bool get isStarted => end == null;

  bool get isFinished => !isStarted;

  Duration get duration =>
      end?.difference(start) ?? DateTime.now().difference(start.toLocal());
}
