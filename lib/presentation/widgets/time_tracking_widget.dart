import 'dart:async';

import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../domain/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../utils/extensions.dart';

class TimeTrackingWidget extends StatefulWidget {
  const TimeTrackingWidget({super.key});

  @override
  State<TimeTrackingWidget> createState() => TimeTrackingWidgetState();
}

class TimeTrackingWidgetState extends State<TimeTrackingWidget> {
  final _timeTrackingUseCase = GetIt.I<TimeTrackingUseCase>();
  final _expandedTimeTrackings = List<int>.empty(growable: true);
  late final Timer timer;

  PaginationModel<TimeTrackingModel> _timeTracks =
      PaginationModel<TimeTrackingModel>.empty();

  @override
  void initState() {
    super.initState();
    _updateTimeTracks();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeTracks.items.any((element) => element.isStarted)) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (panelIndex, isExpanded) => setState(() {
          if (!isExpanded) {
            _expandedTimeTrackings.add(_timeTracks.items[panelIndex].id!);
          } else {
            _expandedTimeTrackings.removeWhere(
                (element) => element == _timeTracks.items[panelIndex].id);
          }
        }),
        children: List<ExpansionPanel>.generate(
          _timeTracks.items.length,
          (index) {
            final timeTrack = _timeTracks.items[index];
            final finishedTracks =
                timeTrack.tracks.where((p0) => p0.isFinished).toList();
            final isExpanded = _expandedTimeTrackings.contains(timeTrack.id);
            return ExpansionPanel(
                isExpanded: isExpanded,
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Text(timeTrack.combineTitle),
                    subtitle: timeTrack.description?.isNotEmpty == true
                        ? Text(timeTrack.description ?? '')
                        : null,
                    leading: IconButton(
                      onPressed: () => (timeTrack.isStarted
                              ? _timeTrackingUseCase.stopTrack(timeTrack.id!)
                              : _timeTrackingUseCase.startTrack(timeTrack.id!))
                          .then(_updateTimeTracking),
                      icon: Icon(
                        timeTrack.isStarted ? Icons.stop : Icons.play_arrow,
                        size: 32.0,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(timeTrack.duration.format()),
                        PopupMenuButton<int>(
                          onSelected: (value) {
                            switch (value) {
                              case 0:
                                /* => GetIt.I<TimeTrackingUseCase>()
                              .updateTimeTrack()
                              .then(_updateTimeTracking) */
                                break;
                              case 1:
                                GetIt.I<TimeTrackingUseCase>()
                                    .deleteTimeTrack(timeTrack.id!)
                                    .then((_) => _updateTimeTracks());
                                break;
                              default:
                            }
                          },
                          itemBuilder: (context) => <PopupMenuEntry<int>>[
                            PopupMenuItem<int>(
                              value: 0,
                              child: ListTile(
                                leading: const Icon(Icons.edit),
                                title: Text(AppLocalizations.of(context)!.edit),
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 1,
                              child: ListTile(
                                leading: const Icon(Icons.delete),
                                title:
                                    Text(AppLocalizations.of(context)!.delete),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                body: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final track = finishedTracks[index];
                    return ListTile(
                      title: Text(
                        prettyDuration(track.duration,
                            spacer: ' ',
                            delimiter: ' ',
                            conjunction: ' ',
                            abbreviated: true),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        '${DateFormat.jms().format(track.start)} - ${DateFormat.jms().format(track.end!)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: IconButton(
                          onPressed: () => GetIt.I<TimeTrackingUseCase>()
                              .deleteTrack(timeTrack.id!, track.id!)
                              .then(_updateTimeTracking),
                          icon: const Icon(Icons.delete)),
                    );
                  },
                  itemCount: finishedTracks.length,
                ));
          },
        ),
      ),
    );
  }

  void _updateTimeTracks() {
    _timeTracks = PaginationModel<TimeTrackingModel>.empty();
    _timeTrackingUseCase.getTimeTracks().then((value) => setState(() {
          _timeTracks = _timeTracks.from(value);
        }));
  }

  void _updateTimeTracking(TimeTrackingModel timeTrack) {
    final items = List<TimeTrackingModel>.from(_timeTracks.items);
    final index = items.indexWhere((element) => element.id == timeTrack.id);
    if (index >= 0) {
      items[index] = timeTrack;
      _timeTracks = PaginationModel<TimeTrackingModel>(
          count: _timeTracks.count,
          limit: _timeTracks.limit,
          offset: _timeTracks.offset,
          items: items);
      setState(() {});
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
