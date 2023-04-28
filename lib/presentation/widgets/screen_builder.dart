import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animations/loading_animations.dart';

import '../../core/app_route.dart';
import '../../core/cubits/application_cubit.dart';

class ScreenBuilder extends StatelessWidget {
  final BuildContext context;
  final Widget? child;

  const ScreenBuilder({super.key, required this.context, this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApplicationCubit, ApplicationState>(
        listenWhen: (previous, current) =>
            current is ExceptionOccurred &&
            previous.exception != current.exception,
        listener: (context, state) {
          final cntx = GetIt.I<AppRoute>()
              .route
              .routerDelegate
              .navigatorKey
              .currentState
              ?.overlay
              ?.context;
          if (cntx != null) {
            showDialog(
              context: cntx,
              builder: (context) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.oops),
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                content: Text(
                  state.exception.toString(),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
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
        },
        child: Stack(
          children: [
            child ?? const SizedBox.shrink(),
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
        ));
  }
}
