import 'package:flutter/material.dart';

import '../../widgets/daily_time.dart';
import '../../widgets/time_tracking_widget.dart';
import '../../widgets/weekly_time.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            runSpacing: 8.0,
            spacing: 8.0,
            children: [
              ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 260.0),
                  child: const DailyTime()),
              ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 260.0),
                  child: const WeeklyTime()),
              ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520.0 + 16),
                  child: const TimeTrackingWidget())
            ],
          ),
        ),
      ),
    );
  }
}
