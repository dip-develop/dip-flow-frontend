import 'package:data_table_2/data_table_2.dart';
import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../core/cubits/timer_cubit.dart';
import 'cubit/time_tracking_cubit.dart';

class TimeTrackingScreen extends StatefulWidget {
  const TimeTrackingScreen({super.key});

  @override
  State<TimeTrackingScreen> createState() => _TimeTrackingScreenState();
}

class _TimeTrackingScreenState extends State<TimeTrackingScreen> {
  final _searchController = TextEditingController();

  int? _expandedTimeTrackId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimeTrackingCubit()..loadData(),
      child: BlocBuilder<TimeTrackingCubit, TimeTrackingState>(
        builder: (context, state) {
          return BlocBuilder<TimerCubit, TimerState>(
            buildWhen: (previous, current) =>
                current is TimeTick &&
                state.timeTracks.items.any((element) => element.isStarted),
            builder: (context, timeTick) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                        alignment: WrapAlignment.end,
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8.0,
                        children: [
                          if (state.filter.start == null ||
                              state.filter.end == null)
                            IconButton(
                                onPressed: () {
                                  showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(2023, 1, 1),
                                    lastDate: DateTime.now(),
                                  ).then((value) {
                                    if (value == null) {
                                      context
                                          .read<TimeTrackingCubit>()
                                          .loadData(
                                            filter: state.filter.clear(
                                              start: true,
                                              end: true,
                                            ),
                                          );
                                    } else if (state.filter.start !=
                                            value.start &&
                                        state.filter.end != value.end) {
                                      context
                                          .read<TimeTrackingCubit>()
                                          .loadData(
                                            limit: state.timeTracks.limit,
                                            offset: state.timeTracks.offset,
                                            filter: state.filter.copyWith(
                                                start: value.start,
                                                end: value.end.add(
                                                    const Duration(
                                                        hours: 23,
                                                        minutes: 59,
                                                        seconds: 59))),
                                          );
                                    }
                                  });
                                },
                                icon: const Icon(Icons.date_range),
                                tooltip: state.filter.start != null &&
                                        state.filter.end != null
                                    ? '${DateFormat.yMd().format(state.filter.start!)} - ${DateFormat.yMd().format(state.filter.end!)}'
                                    : AppLocalizations.of(context)!.dateRange),
                          if (state.filter.start != null &&
                              state.filter.end != null)
                            Chip(
                              avatar: const Icon(Icons.date_range),
                              label: Text(
                                  '${DateFormat.yMd().format(state.filter.start!)} - ${DateFormat.yMd().format(state.filter.end!)}'),
                              onDeleted: () {
                                context.read<TimeTrackingCubit>().loadData(
                                      filter: state.filter.clear(
                                        start: true,
                                        end: true,
                                      ),
                                    );
                              },
                            ),
                          ConstrainedBox(
                              constraints:
                                  const BoxConstraints(maxWidth: 220.0),
                              child: TextField(
                                textInputAction: TextInputAction.search,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  border: const OutlineInputBorder(),
                                  filled: true,
                                  prefixIcon: const Icon(Icons.search),
                                  labelText:
                                      AppLocalizations.of(context)!.search,
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        context
                                            .read<TimeTrackingCubit>()
                                            .loadData(
                                              limit: state.timeTracks.limit,
                                              offset: state.timeTracks.offset,
                                              filter: state.filter
                                                  .clear(search: true),
                                            );
                                        _searchController.clear();
                                      },
                                      icon: const Icon(Icons.clear)),
                                ),
                                onSubmitted: (value) {
                                  context.read<TimeTrackingCubit>().loadData(
                                        limit: state.timeTracks.limit,
                                        offset: state.timeTracks.offset,
                                        filter: state.filter.copyWith(
                                            search: _searchController.text),
                                      );
                                },
                                controller: _searchController,
                              )),
                        ]),
                    Expanded(
                      child: DataTable2(
                        horizontalMargin: 0.0,
                        checkboxHorizontalMargin: 0.0,
                        fixedTopRows: 1,
                        columnSpacing: 0.0,
                        bottomMargin: 0.0,
                        showBottomBorder: true,
                        dataRowHeight: 72.0,
                        minWidth: 600.0,
                        columns: <DataColumn2>[
                          DataColumn2(
                            fixedWidth: 64.0,
                            label: Text(
                              AppLocalizations.of(context)!.status,
                            ),
                          ),
                          DataColumn2(
                            fixedWidth: 84.0,
                            label: Text(
                              AppLocalizations.of(context)!.duration,
                            ),
                          ),
                          DataColumn2(
                            fixedWidth: 100.0,
                            label: Text(
                              AppLocalizations.of(context)!.task,
                            ),
                          ),
                          DataColumn2(
                            size: ColumnSize.L,
                            label: Text(
                              AppLocalizations.of(context)!.title,
                            ),
                          ),
                          const DataColumn2(
                            fixedWidth: 40.0,
                            label: SizedBox.shrink(),
                          ),
                        ],
                        rows: List<DataRow2>.generate(
                            state.timeTracks.items.length, (index) {
                          final timeTrack = state.timeTracks.items[index];
                          return DataRow2(
                              selected: _expandedTimeTrackId == timeTrack.id,
                              specificRowHeight:
                                  _expandedTimeTrackId == timeTrack.id
                                      ? 200
                                      : null,
                              onTap: () {
                                setState(() {
                                  if (_expandedTimeTrackId == timeTrack.id) {
                                    _expandedTimeTrackId = null;
                                  } else {
                                    _expandedTimeTrackId = timeTrack.id;
                                  }
                                });
                              },
                              cells: <DataCell>[
                                DataCell(
                                  IconButton(
                                    onPressed: () => timeTrack.isStarted
                                        ? context
                                            .read<TimeTrackingCubit>()
                                            .stopTrack(timeTrack)
                                        : context
                                            .read<TimeTrackingCubit>()
                                            .startTrack(timeTrack),
                                    icon: Icon(
                                      timeTrack.isStarted
                                          ? Icons.stop
                                          : Icons.play_arrow,
                                      color: timeTrack.isStarted
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                      size: 32.0,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    prettyDuration(timeTrack.duration,
                                        spacer: ' ',
                                        delimiter: ' ',
                                        conjunction: ' ',
                                        tersity: DurationTersity.minute,
                                        upperTersity: DurationTersity.hour,
                                        abbreviated: true),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                      timeTrack.taskId != null
                                          ? '#${timeTrack.taskId}'
                                          : '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary)),
                                ),
                                DataCell(
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(timeTrack.title ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis),
                                      if (timeTrack.description != null)
                                        Text(timeTrack.description ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis)
                                    ],
                                  ),
                                ),
                                DataCell(
                                  PopupMenuButton<int>(
                                    onSelected: (value) {
                                      switch (value) {
                                        case 1:
                                          context
                                              .read<TimeTrackingCubit>()
                                              .deleteTimeTrack(timeTrack);
                                          break;
                                        default:
                                      }
                                    },
                                    itemBuilder: (context) =>
                                        <PopupMenuEntry<int>>[
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
                                ),
                              ]);
                        }),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
