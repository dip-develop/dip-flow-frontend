import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:collection/collection.dart';

part 'time_tracking_model.g.dart';

abstract class TimeTrackingModel
    implements Built<TimeTrackingModel, TimeTrackingModelBuilder> {
  int? get id;
  int? get userId;
  String? get task;
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

abstract class TrackModel implements Built<TrackModel, TrackModelBuilder> {
  int? get id;
  DateTime get start;
  DateTime? get end;

  TrackModel._();
  factory TrackModel([void Function(TrackModelBuilder) updates]) = _$TrackModel;

  bool get isStarted => end == null;

  bool get isFinished => !isStarted;

  Duration get duration =>
      end?.difference(start) ?? DateTime.now().difference(start.toLocal());
}
