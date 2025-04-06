part of 'content_changed_cubit.dart';

@immutable
abstract class ContentChangedState {}

class ContentChangedInitial extends ContentChangedState {}

class TimeTracksChanged extends ContentChangedState {}

class TimeTrackChanged extends ContentChangedState {
  final TimeTrackingModel timeTrack;

  TimeTrackChanged(this.timeTrack);
}
