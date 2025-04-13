import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../domain/models/models.dart';
import '../../../../domain/usecases/usecases.dart';

part 'time_tracking_state.dart';

class TimeTrackingCubit extends Cubit<TimeTrackingState> {
  final _timeTrackingUseCase = GetIt.I<TimeTrackingUseCase>();

  TimeTrackingCubit() : super(TimeTrackingInitial());

  void loadData(
      {int? limit, int? offset, FilterTimeTracks? filter, bool clean = false}) {
    _timeTrackingUseCase
        .getTimeTrackings(
          limit: limit,
          offset: offset,
          search: filter?.search ?? (!clean ? state.filter.search : null),
          start: filter?.start ?? (!clean ? state.filter.start : null),
          end: filter?.end ?? (!clean ? state.filter.end : null),
        )
        .then((value) => emit(TimeTracksUpdated(
            state.timeTracks.from(value),
            FilterTimeTracks(
                search: filter?.search ?? (!clean ? state.filter.search : null),
                start: filter?.start ?? (!clean ? state.filter.start : null),
                end: filter?.end ?? (!clean ? state.filter.end : null)))));
  }

  void startTrack(TimeTrackingModel timeTrack) =>
      _timeTrackingUseCase.startTrack(timeTrack.id!).then(_updateTimeTracking);

  void stopTrack(TimeTrackingModel timeTrack) =>
      _timeTrackingUseCase.stopTrack(timeTrack.id!).then(_updateTimeTracking);

  void deleteTimeTrack(TimeTrackingModel timeTrack) {
    _timeTrackingUseCase
        .deleteTimeTracking(timeTrack.id!)
        .then((_) => _deleteTimeTracking(timeTrack));
  }

  void deleteTrack(TimeTrackingModel timeTrack, TrackModel track) {
    _timeTrackingUseCase.deleteTrack(timeTrack.id!, track.id!).then((_) =>
        _updateTimeTracking(timeTrack.rebuild((p0) =>
            p0.tracks = p0.tracks..removeWhere((p0) => p0.id == track.id))));
  }

  void _updateTimeTracking(TimeTrackingModel timeTrack) {
    final timeTracks = state.timeTracks.update(timeTrack);
    emit(TimeTracksUpdated(timeTracks, state.filter));
  }

  void _deleteTimeTracking(TimeTrackingModel timeTrack) {
    final timeTracks = state.timeTracks.delete(timeTrack);
    emit(TimeTracksUpdated(timeTracks, state.filter));
  }
}
