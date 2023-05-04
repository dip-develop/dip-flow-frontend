import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:theteam_frontend/domain/exceptions/connection_exception.dart';

import '../../core/cubits/application_cubit.dart';

export 'analytics_usecase.dart';
export 'app_usecase.dart';
export 'auth_usecase.dart';
export 'profile_usecase.dart';
export 'time_tracking_usecase.dart';

Future<void> get loadingStart => Future.delayed(
      Duration.zero,
      () => GetIt.I<ApplicationCubit>().loadingShow(),
    );

FutureOr<void> loadingEnd() => Future.delayed(
    Duration.zero, () => GetIt.I<ApplicationCubit>().loadingHide());

dynamic exception(dynamic exception) =>
    GetIt.I<ApplicationCubit>().exception(exception);

Future<void> get checkConnectionFuture =>
    Future.delayed(Duration.zero, checkConnection);

void checkConnection() => throwIf(
    (GetIt.I<ApplicationCubit>().state.connection ?? ConnectivityResult.none) ==
        ConnectivityResult.none,
    ConnectionException.connectionNotFound());
