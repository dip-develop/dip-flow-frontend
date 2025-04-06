import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/generated/i18n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animations/loading_animations.dart';

import '../../core/app_route.dart';
import '../../core/cubits/application_cubit.dart';
import '../../domain/exceptions/exceptions.dart';

class ScreenBuilder extends StatelessWidget {
  final BuildContext context;
  final Widget? child;

  const ScreenBuilder({super.key, required this.context, this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApplicationCubit, ApplicationState>(
        listenWhen: (previous, current) =>
            current is ExceptionOccurred &&
            (previous.exception != current.exception ||
                current.exception is ConnectionException) &&
            current.exception is! AuthException,
        listener: (context, state) {
          final cntx = GetIt.I<AppRoute>()
              .route
              .routerDelegate
              .navigatorKey
              .currentState
              ?.overlay
              ?.context;
          if (cntx != null) {
            if (state.exception is ConnectionException) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text(AppLocalizations.of(context)!.errorConnection)));
            } else {
              showDialog(
                context: cntx,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.oops),
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  content: Text(
                    state.exception.toString(),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => context.pop(),
                        child: Text(AppLocalizations.of(context)!.close))
                  ],
                ),
              );
            }
          }
        },
        child: Material(
          child: Stack(
            children: [
              child ?? const SizedBox.shrink(),
              BlocBuilder<ApplicationCubit, ApplicationState>(
                buildWhen: (previous, current) => current is NetworkChanged,
                builder: (context, state) {
                  return Visibility(
                      visible: (state.connection ?? ConnectivityResult.none) ==
                          ConnectivityResult.none,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.errorContainer),
                          child: Text(
                            AppLocalizations.of(context)!.errorConnection,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ));
                },
              ),
              BlocBuilder<ApplicationCubit, ApplicationState>(
                buildWhen: (previous, current) =>
                    current is IsLoadingChanged &&
                    previous.isLoading != current.isLoading,
                builder: (context, state) {
                  return Visibility(
                      visible: state.isLoading,
                      child: Center(
                        child: LoadingBouncingGrid.square(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          inverted: true,
                        ),
                      ));
                },
              ),
            ],
          ),
        ));
  }
}
