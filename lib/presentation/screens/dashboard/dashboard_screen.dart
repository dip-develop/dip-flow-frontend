import 'package:flutter/material.dart';

import '../../widgets/time_tracking_widget.dart';
import '../../widgets/user_button_widget.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [UserButtonWidget()],
      ),
      body: SafeArea(
          child: Center(
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
      )),
    );
  }
}
