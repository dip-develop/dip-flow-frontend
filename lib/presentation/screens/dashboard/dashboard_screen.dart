import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/usecases/auth_usecase.dart';
import '../../widgets/time_tracking_widget.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () => GetIt.I<AuthUseCase>().signOut(),
                  child: Text(AppLocalizations.of(context)!.signOut)),
              const SizedBox(
                  width: 400.0, height: 400.0, child: TimeTrackingWidget())
            ],
          ),
        ),
      )),
    );
  }
}
