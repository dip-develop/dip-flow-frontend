import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/generated/i18n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/app_route.dart';
import '../../../core/cubits/application_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationCubit, ApplicationState>(
      buildWhen: (_, current) => current is ThemeChanged,
      builder: (context, state) {
        return ListView(
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.profile),
              onTap: () => context.pushNamed(AppRoute.profileRouteName),
            ),
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.darkMode),
              subtitle: Text(AppLocalizations.of(context)!.theme),
              value: state.themeMode == ThemeMode.dark,
              onChanged: (_) => context.read<ApplicationCubit>().switchTheme(),
            ),
            if (defaultTargetPlatform == TargetPlatform.linux ||
                defaultTargetPlatform == TargetPlatform.windows ||
                defaultTargetPlatform == TargetPlatform.macOS)
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.launchAtStartup),
                value: state.launchAtStartup,
                onChanged: (_) =>
                    context.read<ApplicationCubit>().switchLaunchAtStartup(),
              ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.support),
              onTap: () {},
            ),
            ListTile(
                title: Text(AppLocalizations.of(context)!.version),
                subtitle: Text(
                    '${GetIt.I<PackageInfo>().version} (${GetIt.I<PackageInfo>().buildNumber})'),
                onTap: () => showAboutDialog(
                    context: context,
                    applicationIcon: Image.asset(
                      'assets/images/launch_icon.png',
                      width: 128.0,
                      height: 128.0,
                    ),
                    applicationVersion:
                        '${GetIt.I<PackageInfo>().version} (${GetIt.I<PackageInfo>().buildNumber})')),
          ],
        );
      },
    );
  }
}
