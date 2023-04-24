import 'package:flutter/material.dart';

import '../../widgets/daily_time.dart';
import '../../widgets/time_tracking_widget.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            runSpacing: 16.0,
            spacing: 16.0,
            children: [
              ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 220.0),
                  child: const DailyTime()),
              ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440.0),
                  child: const TimeTrackingWidget())
            ],
          ),
        ),
      ),
    );
  }
}
