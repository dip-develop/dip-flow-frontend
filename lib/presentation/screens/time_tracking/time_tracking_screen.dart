import 'package:collection/collection.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../core/cubits/timer_cubit.dart';
import '../../../domain/usecases/usecases.dart';
import 'cubit/time_tracking_cubit.dart';

class TimeTrackingScreen extends StatefulWidget {
  const TimeTrackingScreen({super.key});

  @override
  State<TimeTrackingScreen> createState() => _TimeTrackingScreenState();
}

class _TimeTrackingScreenState extends State<TimeTrackingScreen> {
  final _searchController = TextEditingController();

  String? _expandedTimeTrackId;

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
                        runSpacing: 8.0,
                        verticalDirection: VerticalDirection.up,
                        children: [
                          if (state.filter.start == null &&
                              state.filter.end == null)
                            IconButton(
                                onPressed: () {
                                  final cubit =
                                      context.read<TimeTrackingCubit>();
                                  showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(2023, 1, 1),
                                    lastDate: DateTime.now(),
                                  ).then((value) {
                                    if (value == null) {
                                      cubit.loadData(
                                        filter: state.filter.clear(
                                          start: true,
                                          end: true,
                                        ),
                                      );
                                    } else if (state.filter.start !=
                                            value.start &&
                                        state.filter.end != value.end) {
                                      cubit.loadData(
                                        limit: state.timeTracks.limit,
                                        offset: state.timeTracks.offset,
                                        filter: state.filter.copyWith(
                                            start: value.start,
                                            end: value.end.add(const Duration(
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
                                    ? AppLocalizations.of(context)!
                                        .dateRangeFormat(state.filter.start!,
                                            state.filter.end!)
                                    : state.filter.start != null
                                        ? AppLocalizations.of(context)!
                                            .dateRangeAfter(state.filter.start!)
                                        : state.filter.end != null
                                            ? AppLocalizations.of(context)!
                                                .dateRangeBefore(
                                                    state.filter.end!)
                                            : AppLocalizations.of(context)!
                                                .dateRange),
                          if (state.filter.start != null ||
                              state.filter.end != null)
                            Chip(
                              padding: const EdgeInsets.all(14.0),
                              avatar: const Icon(Icons.date_range),
                              label: Text(state.filter.start != null &&
                                      state.filter.end != null
                                  ? AppLocalizations.of(context)!
                                      .dateRangeFormat(state.filter.start!,
                                          state.filter.end!)
                                  : state.filter.start != null
                                      ? AppLocalizations.of(context)!
                                          .dateRangeAfter(state.filter.start!)
                                      : state.filter.end != null
                                          ? AppLocalizations.of(context)!
                                              .dateRangeBefore(
                                                  state.filter.end!)
                                          : AppLocalizations.of(context)!
                                              .dateRange),
                              onDeleted: () {
                                context.read<TimeTrackingCubit>().loadData(
                                      filter: state.filter.clear(
                                        start: true,
                                        end: true,
                                      ),
                                      clean: true,
                                    );
                              },
                            ),
                          ConstrainedBox(
                              constraints:
                                  const BoxConstraints(maxWidth: 400.0),
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
                                              /* limit: state.timeTracks.limit,
                                              offset: state.timeTracks.offset, */
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
                        fixedLeftColumns: 1,
                        columnSpacing: 0.0,
                        bottomMargin: 0.0,
                        showBottomBorder: true,
                        dataRowHeight: 58.0,
                        minWidth: 600.0,
                        columns: <DataColumn2>[
                          DataColumn2(
                            fixedWidth: 54.0,
                            label: Center(
                              child: Text(
                                AppLocalizations.of(context)!.status,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataColumn2(
                            fixedWidth: 92.0,
                            label: Center(
                              child: Text(
                                AppLocalizations.of(context)!.duration,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataColumn2(
                            fixedWidth: 100.0,
                            label: Center(
                              child: Text(
                                AppLocalizations.of(context)!.task,
                              ),
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
                          final timeTracking = state.timeTracks.items[index];
                          final isExpanded =
                              _expandedTimeTrackId == timeTracking.id;
                          final finishedTracks = timeTracking.tracks
                              .where((p0) => p0.isFinished)
                              .toList();
                          return DataRow2.byIndex(
                              index: index,
                              selected: isExpanded,
                              specificRowHeight: isExpanded ? 400 : null,
                              cells: <DataCell>[
                                DataCell(
                                  Center(
                                    child: IconButton(
                                      onPressed: () => timeTracking.isStarted
                                          ? context
                                              .read<TimeTrackingCubit>()
                                              .stopTrack(timeTracking)
                                          : context
                                              .read<TimeTrackingCubit>()
                                              .startTrack(timeTracking),
                                      icon: Icon(
                                        timeTracking.isStarted
                                            ? Icons.stop
                                            : Icons.play_arrow,
                                        color: timeTracking.isStarted
                                            ? Theme.of(context)
                                                .colorScheme
                                                .tertiary
                                            : null,
                                        size: 32.0,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  onTap: () {
                                    setState(() {
                                      if (isExpanded) {
                                        _expandedTimeTrackId = null;
                                      } else {
                                        _expandedTimeTrackId = timeTracking.id;
                                      }
                                    });
                                  },
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        border: timeTracking.isStarted
                                            ? Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiaryContainer,
                                              )
                                            : null),
                                    alignment: Alignment.center,
                                    child: Text(
                                      prettyDuration(timeTracking.duration,
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
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                        timeTracking.taskId != null
                                            ? '#${timeTracking.taskId}'
                                            : '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary)),
                                  ),
                                ),
                                DataCell(
                                  onTap: () {
                                    setState(() {
                                      if (isExpanded) {
                                        _expandedTimeTrackId = null;
                                      } else {
                                        _expandedTimeTrackId = timeTracking.id;
                                      }
                                    });
                                  },
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (isExpanded)
                                          const SizedBox(
                                            height: 9.0,
                                          ),
                                        Text(timeTracking.title ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis),
                                        if (timeTracking.description != null)
                                          Text(timeTracking.description ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                        if (isExpanded)
                                          const SizedBox(
                                            height: 9.0,
                                          ),
                                        if (isExpanded) const Divider(),
                                        if (isExpanded)
                                          Expanded(
                                            child: ListView.builder(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0),
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                final track =
                                                    finishedTracks[index];
                                                return ListTile(
                                                  title: Text(
                                                    prettyDuration(
                                                        track.duration,
                                                        spacer: ' ',
                                                        delimiter: ' ',
                                                        conjunction: ' ',
                                                        tersity: DurationTersity
                                                            .minute,
                                                        upperTersity:
                                                            DurationTersity
                                                                .hour,
                                                        abbreviated: true),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                                  ),
                                                  subtitle: RichText(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines:
                                                        isExpanded ? 3 : 1,
                                                    text: TextSpan(
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall,
                                                        children: [
                                                          TextSpan(
                                                            text: DateFormat(
                                                                    'y/M/d ')
                                                                .format(track
                                                                    .start),
                                                          ),
                                                          TextSpan(
                                                              text: DateFormat(
                                                                      'H:m')
                                                                  .format(track
                                                                      .start),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .labelMedium
                                                                  ?.copyWith(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary)),
                                                          const TextSpan(
                                                            text: ' - ',
                                                          ),
                                                          TextSpan(
                                                            text: DateFormat(
                                                                    'y/M/d ')
                                                                .format(
                                                                    track.end!),
                                                          ),
                                                          TextSpan(
                                                              text: DateFormat(
                                                                      'H:m')
                                                                  .format(track
                                                                      .end!),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .labelMedium
                                                                  ?.copyWith(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary)),
                                                        ]),
                                                  ),
                                                  trailing: IconButton(
                                                      onPressed: () => GetIt.I<
                                                              TimeTrackingUseCase>()
                                                          .deleteTrack(
                                                              timeTracking.id!,
                                                              track.id!),
                                                      icon: const Icon(
                                                          Icons.delete)),
                                                );
                                              },
                                              itemCount: finishedTracks.length,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  PopupMenuButton<int>(
                                    onSelected: (value) {
                                      switch (value) {
                                        case 1:
                                          context
                                              .read<TimeTrackingCubit>()
                                              .deleteTimeTrack(timeTracking);
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
                    ListTile(
                      selected: true,
                      leading: const Icon(Icons.av_timer),
                      title: Text(AppLocalizations.of(context)!.total(
                          prettyDuration(
                              Duration(
                                  milliseconds: state.timeTracks.items
                                      .map((e) => e.duration.inMilliseconds)
                                      .sum),
                              spacer: ' ',
                              delimiter: ' ',
                              conjunction: ' ',
                              tersity: DurationTersity.minute,
                              upperTersity: DurationTersity.hour,
                              abbreviated: true))),
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
