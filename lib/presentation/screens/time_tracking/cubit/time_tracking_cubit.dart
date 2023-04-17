import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../domain/models/models.dart';
import '../../../../domain/usecases/usecases.dart';

part 'time_tracking_state.dart';

class TimeTrackingCubit extends Cubit<TimeTrackingState> {
  final _timeTrackingUseCase = GetIt.I<TimeTrackingUseCase>();
  Timer? timer;

  TimeTrackingCubit() : super(TimeTrackingInitial());

  void loadData({
    int? limit,
    int? offset,
    String? search,
    DateTime? start,
    DateTime? end,
  }) {
    _timeTrackingUseCase
        .getTimeTracks(
            limit: limit,
            offset: offset,
            search: search,
            start: start,
            end: end)
        .then((value) => emit(TimeTracksUpdated(state.timeTracks.from(value))))
        .whenComplete(createTimer);
  }

  void createTimer() {
    if (state.timeTracks.items.any((element) => element.isStarted)) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (state.timeTracks.items.any((element) => element.isStarted)) {
          emit(TimeTick(state.timeTracks));
        }
      });
    } else {
      timer?.cancel();
      timer = null;
    }
    emit(TimeTick(state.timeTracks));
  }

  void updateTimeTracking(TimeTrackingModel timeTrack) {
    final items = List<TimeTrackingModel>.from(state.timeTracks.items);
    final index = items.indexWhere((element) => element.id == timeTrack.id);
    if (index >= 0) {
      items[index] = timeTrack;
      emit(TimeTracksUpdated(PaginationModel<TimeTrackingModel>(
          count: state.timeTracks.count,
          limit: state.timeTracks.limit,
          offset: state.timeTracks.offset,
          items: items)));
      createTimer();
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

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }
}
