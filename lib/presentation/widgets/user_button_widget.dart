import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_route.dart';
import '../../domain/usecases/usecases.dart';

class UserButtonWidget extends StatelessWidget {
  const UserButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (value) {
        switch (value) {
          case 0:
            context.goNamed(AppRoute.settingsRouteName);
            break;
          case 1:
            GetIt.I<AuthUseCase>().signOut();
            break;
          default:
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.settings),
          ),
        ),
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
    );
  }
}
