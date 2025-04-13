part of 'time_tracking_cubit.dart';

@immutable
abstract class TimeTrackingState extends Equatable {
  final FilterTimeTracks filter;
  final PaginationModel<TimeTrackingModel> timeTracks;

  const TimeTrackingState(this.timeTracks,
      {this.filter = const FilterTimeTracks()});

  @override
  List<Object?> get props => [filter, timeTracks];
}

class TimeTrackingInitial extends TimeTrackingState {
  TimeTrackingInitial()
      : super(PaginationModel<TimeTrackingModel>.empty(),
            filter: FilterTimeTracks(
              start: DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day)
                  .subtract(Duration(
                      days: DateTime(DateTime.now().year, DateTime.now().month,
                                  DateTime.now().day)
                              .weekday -
                          1)),
            ));
}

class TimeTracksUpdated extends TimeTrackingState {
  const TimeTracksUpdated(super.timeTracks, FilterTimeTracks filter)
      : super(filter: filter);
}

class FilterTimeTracks {
  final DateTime? start;
  final DateTime? end;
  final String? search;

  const FilterTimeTracks({this.start, this.end, this.search});

  FilterTimeTracks copyWith({DateTime? start, DateTime? end, String? search}) =>
      FilterTimeTracks(
        search: search ?? this.search,
        start: start ?? this.start,
        end: end ?? this.end,
      );

  FilterTimeTracks clear(
          {bool search = false, bool start = false, bool end = false}) =>
      FilterTimeTracks(
        search: search ? null : this.search,
        start: start ? null : this.start,
        end: end ? null : this.end,
      );
}
