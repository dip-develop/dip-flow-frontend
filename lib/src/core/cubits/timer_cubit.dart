import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'timer_state.dart';

@singleton
class TimerCubit extends Cubit<TimerState> {
  late final Timer timer;

  TimerCubit() : super(TimerInitial()) {
    timer = Timer.periodic(const Duration(seconds: 1), timeTrack);
  }

  void timeTrack(Timer timer) {
    if (!isClosed) {
      emit(TimeTick(timer.tick));
    }
  }

  @override
  Future<void> close() {
    timer.cancel();
    return super.close();
  }
}
