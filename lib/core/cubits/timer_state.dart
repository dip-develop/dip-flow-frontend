part of 'timer_cubit.dart';

@immutable
abstract class TimerState {
  int get tick;
}

class TimerInitial extends TimerState {
  @override
  int get tick => 0;
}

class TimeTick extends TimerState {
  @override
  final int tick;
  TimeTick(this.tick);
}
