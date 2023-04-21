import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/extensions.dart';
import 'cubit/time_tracking_cubit.dart';

class TimeTrackingScreen extends StatelessWidget {
  const TimeTrackingScreen({super.key});

  final _rowHeight = 64.0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimeTrackingCubit()..loadData(),
      child: BlocBuilder<TimeTrackingCubit, TimeTrackingState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Table(
              columnWidths: const <int, TableColumnWidth>{
                0: IntrinsicColumnWidth(),
                1: FixedColumnWidth(96),
                2: FixedColumnWidth(128.0),
                3: FlexColumnWidth(),
                4: FixedColumnWidth(64),
              },
              textBaseline: TextBaseline.alphabetic,
              children: [
                TableRow(
                    decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.secondaryContainer),
                    children: [
                      TableCell(
                        child: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.status,
                              style: Theme.of(context).textTheme.labelLarge,
                            )),
                      ),
                      TableCell(
                        child: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.duration,
                              style: Theme.of(context).textTheme.labelLarge,
                            )),
                      ),
                      TableCell(
                        child: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.task,
                              style: Theme.of(context).textTheme.labelLarge,
                            )),
                      ),
                      TableCell(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppLocalizations.of(context)!.title,
                              style: Theme.of(context).textTheme.labelLarge,
                            )),
                      ),
                      TableCell(
                        child: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const SizedBox.shrink()),
                      ),
                    ]),
                ...List.generate(state.timeTracks.items.length, (index) {
                  final timeTrack = state.timeTracks.items[index];

                  return TableRow(children: [
                    TableCell(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        height: _rowHeight,
                        child: IconButton(
                          onPressed: () => timeTrack.isStarted
                              ? context
                                  .read<TimeTrackingCubit>()
                                  .stopTrack(timeTrack)
                              : context
                                  .read<TimeTrackingCubit>()
                                  .startTrack(timeTrack),
                          icon: Icon(
                            timeTrack.isStarted ? Icons.stop : Icons.play_arrow,
                            color: timeTrack.isStarted
                                ? Theme.of(context).colorScheme.primary
                                : null,
                            size: 32.0,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          height: _rowHeight,
                          child: Text(timeTrack.duration.format())),
                    ),
                    TableCell(
                        child: InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        height: _rowHeight,
                        child: Text(
                            timeTrack.task != null ? '#${timeTrack.task}' : '',
                            style: Theme.of(context).textTheme.labelMedium),
                      ),
                    )),
                    TableCell(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.centerLeft,
                          height: _rowHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(timeTrack.title ?? '',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis),
                              if (timeTrack.description != null)
                                Text(timeTrack.description ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)
                            ],
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        height: _rowHeight,
                        child: PopupMenuButton<int>(
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
                                title:
                                    Text(AppLocalizations.of(context)!.delete),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]);
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
