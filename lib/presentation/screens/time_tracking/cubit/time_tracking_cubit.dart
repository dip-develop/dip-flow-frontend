import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../domain/models/models.dart';
import '../../../../domain/usecases/usecases.dart';

part 'time_tracking_state.dart';

class TimeTrackingCubit extends Cubit<TimeTrackingState> {
  final _timeTrackingUseCase = GetIt.I<TimeTrackingUseCase>();

  TimeTrackingCubit() : super(TimeTrackingInitial());

  void loadData({
    int? limit,
    int? offset,
    FilterTimeTracks? filter,
  }) {
    _timeTrackingUseCase
        .getTimeTracks(
            limit: limit,
            offset: offset,
            search: filter?.search,
            start: filter?.start,
            end: filter?.end)
        .then((value) => emit(TimeTracksUpdated(
            state.timeTracks.from(value),
            FilterTimeTracks(
              search: filter?.search,
              start: filter?.start,
              end: filter?.end,
            ))));
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
    _timeTrackingUseCase.deleteTimeTrack(timeTrack.id!).whenComplete(loadData);
  }
}
