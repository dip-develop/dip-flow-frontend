import 'package:collection/collection.dart';
import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../core/cubits/content_changed_cubit.dart';
import '../../core/cubits/timer_cubit.dart';
import '../../core/generated/i18n/app_localizations.dart';
import '../../domain/models/models.dart';
import '../../domain/usecases/usecases.dart';

class DailyTime extends StatefulWidget {
  const DailyTime({super.key});

  @override
  State<DailyTime> createState() => _DailyTimeState();
}

class _DailyTimeState extends State<DailyTime> {
  final todayStart =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final _timeTrackingUseCase = GetIt.I<TimeTrackingUseCase>();

  PaginationModel<TimeTrackingModel> _timeTracks =
      PaginationModel<TimeTrackingModel>.empty();

  @override
  void initState() {
    super.initState();
    _updateTimeTracks();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<ContentChangedCubit, ContentChangedState>(
              listenWhen: (previous, current) =>
                  current is TimeTracksChanged || current is TimeTrackChanged,
              listener: (context, state) {
                if (state is TimeTracksChanged) {
                  _updateTimeTracks();
                } else if (state is TimeTrackChanged) {
                  _updateTimeTrack(state.timeTrack);
                }
              }),
          BlocListener<TimerCubit, TimerState>(
              listenWhen: (previous, current) =>
                  current is TimeTick && current.tick % 10 == 0,
              listener: (context, state) {
                _updateTimeTracks();
              }),
        ],
        child: BlocBuilder<TimerCubit, TimerState>(
            buildWhen: (previous, current) =>
                current is TimeTick &&
                _timeTracks.items.any((element) => element.isStarted),
            builder: (context, state) {
              return Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 8.0,
                          ),
                          Icon(
                            Icons.work_history,
                            color:
                                Theme.of(context).textTheme.titleMedium!.color,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            AppLocalizations.of(context)!.today,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        prettyDuration(
                            Duration(
                                milliseconds: _timeTracks.items
                                    .expand((element) => element.tracks)
                                    .where((element) =>
                                        element.start.isAfter(todayStart) ||
                                        element.start == todayStart)
                                    .map((e) => e.duration.inMilliseconds)
                                    .sum),
                            upperTersity: DurationTersity.hour,
                            spacer: ' ',
                            delimiter: ' ',
                            conjunction: ' ',
                            abbreviated: true),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              );
            }));
  }

  void _updateTimeTracks() {
    if (!mounted) return;
    _timeTracks = PaginationModel<TimeTrackingModel>.empty();
    _timeTrackingUseCase
        .getTimeTrackings(
          start: todayStart,
        )
        .then((value) => setState(() {
              _timeTracks = _timeTracks.from(value);
            }));
  }

  void _updateTimeTrack(TimeTrackingModel timeTrack) {
    if (!mounted) return;
    setState(() {
    _timeTracks =  _timeTracks.update(timeTrack);
    });
  }
}
