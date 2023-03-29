import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../domain/usecases/usecases.dart';
import 'app_route.dart';
import 'cubit/application_cubit.dart';
import 'resources/themes/dark_theme.dart';
import 'resources/themes/light_theme.dart';

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.I.get<ApplicationCubit>(),
        ),
      ],
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
            child: MaterialApp.router(
              routeInformationProvider:
                  GetIt.I.get<AppRoute>().route.routeInformationProvider,
              routeInformationParser:
                  GetIt.I.get<AppRoute>().route.routeInformationParser,
              routerDelegate: GetIt.I.get<AppRoute>().route.routerDelegate,
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context)!.appName,
              theme: const LightAppThemeImpl().themeData,
              darkTheme: const DarkAppThemeImpl().themeData,
              themeMode: state.themeMode,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              debugShowCheckedModeBanner: false,
            ),
          );
        },
      ),
    );
  }
}

@module
abstract class ApplicationModule {
  @lazySingleton
  ApplicationCubit appCubit() => ApplicationCubit(GetIt.I.get<AppUseCase>());
  @singleton
  AppRoute appRoute() => AppRoute();
}
