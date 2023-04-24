import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../core/cubits/timer_cubit.dart';
import '../../utils/extensions.dart';
import 'cubit/time_tracking_cubit.dart';

class TimeTrackingScreen extends StatefulWidget {
  const TimeTrackingScreen({super.key});

  @override
  State<TimeTrackingScreen> createState() => _TimeTrackingScreenState();
}

class _TimeTrackingScreenState extends State<TimeTrackingScreen> {
  final _searchController = TextEditingController();

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
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Wrap(
                          runAlignment: WrapAlignment.center,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 16.0,
                          runSpacing: 16.0,
                          children: [
                            ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 220.0),
                                child: TextField(
                                  decoration: InputDecoration(
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
                                  controller: _searchController,
                                )),
                            ElevatedButton(
                                onPressed: () =>
                                    context.read<TimeTrackingCubit>().loadData(
                                          limit: state.timeTracks.limit,
                                          offset: state.timeTracks.offset,
                                          filter: state.filter.copyWith(
                                              search: _searchController.text),
                                        ),
                                child:
                                    Text(AppLocalizations.of(context)!.search)),
                            ElevatedButton(
                                onPressed: () {
                                  showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(2023, 1, 1),
                                    lastDate: DateTime.now(),
                                  ).then((value) {
                                    if (state.filter.start != value?.start &&
                                        state.filter.end != value?.end) {
                                      context
                                          .read<TimeTrackingCubit>()
                                          .loadData(
                                            limit: state.timeTracks.limit,
                                            offset: state.timeTracks.offset,
                                            filter: state.filter.copyWith(
                                                start: value?.start,
                                                end: value?.end),
                                          );
                                    }
                                  });
                                },
                                child: Text(
                                    AppLocalizations.of(context)!.dateRange)),
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
                          ]),
                      DataTable(
                        showBottomBorder: true,
                        dataRowHeight: 72.0,
                        clipBehavior: Clip.antiAlias,
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text(
                              AppLocalizations.of(context)!.status,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              AppLocalizations.of(context)!.duration,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              AppLocalizations.of(context)!.task,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              AppLocalizations.of(context)!.title,
                            ),
                          ),
                          const DataColumn(
                            label: SizedBox.shrink(),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                            state.timeTracks.items.length, (index) {
                          final timeTrack = state.timeTracks.items[index];
                          return DataRow(cells: <DataCell>[
                            /* 0: IntrinsicColumnWidth(),
                      1: FixedColumnWidth(96),
                      2: FixedColumnWidth(128.0),
                      3: FlexColumnWidth(),
                      4: FixedColumnWidth(64), */

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
                                      ? Theme.of(context).colorScheme.primary
                                      : null,
                                  size: 32.0,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(timeTrack.duration.format()),
                              onTap: () {},
                            ),
                            DataCell(
                              Text(
                                  timeTrack.task != null
                                      ? '#${timeTrack.task}'
                                      : '',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              onTap: () {},
                            ),
                            DataCell(
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                              onTap: () {},
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
                                itemBuilder: (context) => <PopupMenuEntry<int>>[
                                  PopupMenuItem<int>(
                                    value: 1,
                                    child: ListTile(
                                      leading: const Icon(Icons.delete),
                                      title: Text(
                                          AppLocalizations.of(context)!.delete),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }),
                      ),
                    ],
                  ),
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
