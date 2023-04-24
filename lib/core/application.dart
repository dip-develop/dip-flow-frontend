import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:mixpanel_analytics/mixpanel_analytics.dart';

import '../domain/models/models.dart';
import 'app_route.dart';
import 'cubits/application_cubit.dart';
import 'cubits/timer_cubit.dart';
import 'resources/themes/dark_theme.dart';
import 'resources/themes/light_theme.dart';

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => GetIt.I<AppRoute>(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GetIt.I.get<ApplicationCubit>(),
          ),
          BlocProvider(
            create: (context) => GetIt.I.get<TimerCubit>(),
          ),
        ],
        child: BlocListener<ApplicationCubit, ApplicationState>(
          listenWhen: (previous, current) =>
              current is AuthChanged &&
              current.auth != AuthState.authorized &&
              previous.auth == AuthState.authorized,
          listener: (context, state) {
            final route = context.read<AppRoute>().route;
            if (route.location != route.namedLocation(AppRoute.authRouteName)) {
              route.pushReplacementNamed(AppRoute.authRouteName);
            }
          },
          child: BlocBuilder<ApplicationCubit, ApplicationState>(
            buildWhen: (previous, current) => current is ThemeChanged,
            builder: (context, state) {
              return MultiRepositoryProvider(
                providers: [
                  RepositoryProvider.value(
                    value: state.theme,
                  ),
                  RepositoryProvider.value(
                    value: state.themeMode,
                  ),
                ],
                child: FlavorBanner(
                  child: MaterialApp.router(
                    routeInformationProvider:
                        context.read<AppRoute>().route.routeInformationProvider,
                    routeInformationParser:
                        context.read<AppRoute>().route.routeInformationParser,
                    routerDelegate:
                        context.read<AppRoute>().route.routerDelegate,
                    onGenerateTitle: (context) =>
                        AppLocalizations.of(context)!.appName,
                    theme: const LightAppThemeImpl().themeData,
                    darkTheme: const DarkAppThemeImpl().themeData,
                    themeMode: state.themeMode,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    debugShowCheckedModeBanner: false,
                    builder: (context, child) {
                      return BlocBuilder<ApplicationCubit, ApplicationState>(
                        buildWhen: (previous, current) =>
                            current is IsLoadingChanged &&
                                previous.isLoading != current.isLoading ||
                            current is ExceptionOccurred,
                        builder: (context, state) {
                          return Stack(
                            children: [
                              if (child != null) child,
                              Visibility(
                                  visible: state.exception != null,
                                  child: Center(
                                    child: Card(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .errorContainer,
                                      child: Container(
                                        padding: const EdgeInsets.all(16.0),
                                        constraints: const BoxConstraints(
                                            maxWidth: 320.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(AppLocalizations.of(
                                                        context)!
                                                    .oops),
                                                IconButton(
                                                    onPressed: () => GetIt.I<
                                                            ApplicationCubit>()
                                                        .exception(),
                                                    icon: const Icon(
                                                        Icons.close)),
                                              ],
                                            ),
                                            Center(
                                              child: Text(
                                                state.exception.toString(),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                              Visibility(
                                  visible: state.isLoading,
                                  child: Center(
                                    child: LoadingBouncingGrid.square(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      inverted: true,
                                    ),
                                  )),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

@module
abstract class ApplicationModule {
  @lazySingleton
  MixpanelAnalytics mixpanelAnalytics() => MixpanelAnalytics.batch(
        token: '199db839368b1b91da8de2bda30d743d',
        verbose: kDebugMode,
        uploadInterval: const Duration(seconds: 30),
        onError: (p0) {
          debugPrint(p0.toString());
        },
      );
}
