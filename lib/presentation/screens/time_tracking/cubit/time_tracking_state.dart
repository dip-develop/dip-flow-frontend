part of 'time_tracking_cubit.dart';

@immutable
abstract class TimeTrackingState {
  final PaginationModel<TimeTrackingModel> timeTracks;

  const TimeTrackingState(this.timeTracks);
}

class TimeTrackingInitial extends TimeTrackingState {
  TimeTrackingInitial() : super(PaginationModel<TimeTrackingModel>.empty());
}

class TimeTracksUpdated extends TimeTrackingState {
  const TimeTracksUpdated(super.timeTracks);
}

class TimeTick extends TimeTrackingState {
  const TimeTick(super.timeTracks);
}
