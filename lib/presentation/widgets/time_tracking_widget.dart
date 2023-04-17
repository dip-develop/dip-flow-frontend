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
  final _addFormKey = GlobalKey<FormState>();
  final _taskTextController = TextEditingController();
  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();

  Timer? timer;
  PaginationModel<TimeTrackingModel> _timeTracks =
      PaginationModel<TimeTrackingModel>.empty();
  bool _isAddPannelVisivle = false;

  @override
  void initState() {
    super.initState();
    _updateTimeTracks();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 8.0,
                  ),
                  Icon(
                    Icons.timer,
                    color: Theme.of(context).textTheme.titleMedium!.color,
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Text(
                    AppLocalizations.of(context)!.timeTracking,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  TextButton.icon(
                      onPressed: () => setState(() {
                            _isAddPannelVisivle = !_isAddPannelVisivle;
                          }),
                      icon: Icon(_isAddPannelVisivle ? Icons.close : Icons.add),
                      label: Text(_isAddPannelVisivle
                          ? AppLocalizations.of(context)!.hide
                          : AppLocalizations.of(context)!.add)),
                ],
              ),
              Visibility(
                visible: _isAddPannelVisivle,
                maintainAnimation: true,
                maintainState: true,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  opacity: _isAddPannelVisivle ? 1 : 0,
                  child: Form(
                    key: _addFormKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 12.0,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                controller: _taskTextController,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  label:
                                      Text(AppLocalizations.of(context)!.task),
                                  prefixIcon: const Icon(Icons.task),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Flexible(
                              flex: 2,
                              child: TextFormField(
                                controller: _titleTextController,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  label:
                                      Text(AppLocalizations.of(context)!.title),
                                  prefixIcon: const Icon(Icons.title),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _descriptionTextController,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            label:
                                Text(AppLocalizations.of(context)!.description),
                            prefixIcon: const Icon(Icons.description),
                          ),
                          maxLines: 5,
                          minLines: 2,
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton.icon(
                              onPressed: () {
                                if (_addFormKey.currentState?.validate() ??
                                    false) {
                                  GetIt.I<TimeTrackingUseCase>()
                                      .addTimeTrack(TimeTrackingModel(
                                        (p0) => p0
                                          ..task = _taskTextController
                                                  .text.isNotEmpty
                                              ? _taskTextController.text
                                              : null
                                          ..title = _titleTextController
                                                  .text.isNotEmpty
                                              ? _titleTextController.text
                                              : null
                                          ..description =
                                              _descriptionTextController
                                                      .text.isNotEmpty
                                                  ? _descriptionTextController
                                                      .text
                                                  : null,
                                      ))
                                      .then((_) => _updateTimeTracks())
                                      .then((_) => setState(() {
                                            _isAddPannelVisivle = false;
                                            _taskTextController.clear();
                                            _titleTextController.clear();
                                            _descriptionTextController.clear();
                                          }));
                                }
                              },
                              icon: const Icon(Icons.add),
                              label: Text(AppLocalizations.of(context)!.add)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _timeTracks.items.isNotEmpty,
                child: const SizedBox(
                  height: 12.0,
                ),
              ),
              ExpansionPanelList(
                expansionCallback: (panelIndex, isExpanded) => setState(() {
                  if (!isExpanded) {
                    _expandedTimeTrackings
                        .add(_timeTracks.items[panelIndex].id!);
                  } else {
                    _expandedTimeTrackings.removeWhere((element) =>
                        element == _timeTracks.items[panelIndex].id);
                  }
                }),
                children: List<ExpansionPanel>.generate(
                  _timeTracks.items.length,
                  (index) {
                    final timeTrack = _timeTracks.items[index];
                    final finishedTracks =
                        timeTrack.tracks.where((p0) => p0.isFinished).toList();
                    final isExpanded =
                        _expandedTimeTrackings.contains(timeTrack.id);
                    return ExpansionPanel(
                        isExpanded: isExpanded,
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            title: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: isExpanded ? 3 : 1,
                              text: TextSpan(children: [
                                if (timeTrack.task != null)
                                  TextSpan(
                                      text: '#${timeTrack.task}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium),
                                if (timeTrack.task != null &&
                                    timeTrack.title != null)
                                  const TextSpan(text: ' - '),
                                if (timeTrack.title != null)
                                  TextSpan(
                                      text: timeTrack.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                              ]),
                            ),
                            subtitle: timeTrack.description != null
                                ? Text(
                                    timeTrack.description ?? '',
                                    maxLines: isExpanded ? 3 : 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : null,
                            leading: IconButton(
                              onPressed: () => (timeTrack.isStarted
                                      ? _timeTrackingUseCase
                                          .stopTrack(timeTrack.id!)
                                      : _timeTrackingUseCase
                                          .startTrack(timeTrack.id!))
                                  .then(_updateTimeTracking),
                              icon: Icon(
                                timeTrack.isStarted
                                    ? Icons.stop
                                    : Icons.play_arrow,
                                color: timeTrack.isStarted
                                    ? Theme.of(context).colorScheme.secondary
                                    : null,
                                size: 32.0,
                              ),
                            ),
                            contentPadding: EdgeInsets.zero,
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
                                  itemBuilder: (context) =>
                                      <PopupMenuEntry<int>>[
                                    /* PopupMenuItem<int>(
                                      value: 0,
                                      child: ListTile(
                                        leading: const Icon(Icons.edit),
                                        title: Text(
                                            AppLocalizations.of(context)!.edit),
                                      ),
                                    ), */
                                    PopupMenuItem<int>(
                                      value: 1,
                                      child: ListTile(
                                        leading: const Icon(Icons.delete),
                                        title: Text(
                                            AppLocalizations.of(context)!
                                                .delete),
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
                                  onPressed: () =>
                                      GetIt.I<TimeTrackingUseCase>()
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
            ],
          ),
        ),
      ),
    );
  }

  void _createTimer() {
    if (_timeTracks.items.any((element) => element.isStarted)) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timeTracks.items.any((element) => element.isStarted)) {
          setState(() {});
        }
      });
    } else {
      timer?.cancel();
      timer = null;
    }
    setState(() {});
  }

  void _updateTimeTracks() {
    _timeTracks = PaginationModel<TimeTrackingModel>.empty();
    _timeTrackingUseCase
        .getTimeTracks(limit: 5)
        .then((value) => setState(() {
              _timeTracks = _timeTracks.from(value);
            }))
        .whenComplete(_createTimer);
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
      _createTimer();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
