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

  void updateTimeTracking(TimeTrackingModel timeTrack) {
    final items = List<TimeTrackingModel>.from(state.timeTracks.items);
    final index = items.indexWhere((element) => element.id == timeTrack.id);
    if (index >= 0) {
      items[index] = timeTrack;
      emit(TimeTracksUpdated(
          PaginationModel<TimeTrackingModel>(
              count: state.timeTracks.count,
              limit: state.timeTracks.limit,
              offset: state.timeTracks.offset,
              items: items),
          state.filter));
    }
  }

  void startTrack(TimeTrackingModel timeTrack) {
    _timeTrackingUseCase.startTrack(timeTrack.id!).then(updateTimeTracking);
  }

  void stopTrack(TimeTrackingModel timeTrack) {
    _timeTrackingUseCase.stopTrack(timeTrack.id!).then(updateTimeTracking);
  }

  void deleteTimeTrack(TimeTrackingModel timeTrack) {
    _timeTrackingUseCase
        .deleteTimeTracking(timeTrack.id!)
        .whenComplete(loadData);
  }
}
