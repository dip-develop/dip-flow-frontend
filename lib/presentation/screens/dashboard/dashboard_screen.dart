import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/usecases/usecases.dart';
import '../../widgets/time_tracking_widget.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) {
              switch (value) {
                case 1:
                  GetIt.I<AuthUseCase>().signOut();
                  break;
                default:
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(AppLocalizations.of(context)!.signOut),
                ),
              ),
            ],
            icon: const CircleAvatar(
              child: Icon(Icons.people),
            ),
          )
          /* IconButton(
            onPressed: () {},
            icon: const CircleAvatar(
              child: Icon(Icons.people),
            ),
          ) */
        ],
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
