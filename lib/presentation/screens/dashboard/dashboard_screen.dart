import 'package:flutter/material.dart';

import '../../widgets/time_tracking_widget.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
