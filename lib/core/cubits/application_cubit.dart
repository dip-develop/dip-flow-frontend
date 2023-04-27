import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:launch_at_startup/launch_at_startup.dart';

import '../../domain/exceptions/auth_exception.dart';
import '../../domain/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../resources/themes/theme.dart';

part 'application_state.dart';

@singleton
class ApplicationCubit extends Cubit<ApplicationState> {
  final _connectivity = Connectivity();
  final AppUseCase _appUseCase;

  ApplicationCubit(this._appUseCase) : super(ApplicationInitial()) {
    _appUseCase.getThemeMode().then((value) {
      if (value != state.themeMode) {
        if (value == ThemeMode.light) {
          toLightTheme();
        } else if (value == ThemeMode.dark) {
          toDarkTheme();
        }
      }
    });

    _connectivity.checkConnectivity().then((value) {
      emit(NetworkChanged(state, value));
    });

    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      emit(NetworkChanged(state, result));
    });
  }

  void toDarkTheme() {
    emit(ThemeChanged(state, ThemeMode.dark));
    _appUseCase.saveThemeMode(ThemeMode.dark);
  }

  void toLightTheme() {
    emit(ThemeChanged(state, ThemeMode.light));
    _appUseCase.saveThemeMode(ThemeMode.light);
  }

  void loadingShow() => !isClosed ? emit(IsLoadingChanged(state, true)) : null;

  void loadingHide() => !isClosed ? emit(IsLoadingChanged(state, false)) : null;

  void switchTheme() =>
      state.themeMode == ThemeMode.dark ? toLightTheme() : toDarkTheme();

  Future<void> checkLaunchAtStartup() => launchAtStartup
      .isEnabled()
      .then((value) => emit(LaunchAtStartupChanged(state, value)));

  Future<void> switchLaunchAtStartup() {
    loadingShow();
    return (state.launchAtStartup
            ? launchAtStartup.disable()
            : launchAtStartup.isEnabled())
        .then((value) {
          debugPrint(value.toString());
          return launchAtStartup.isEnabled();
        })
        .then((value) => emit(LaunchAtStartupChanged(state, value)))
        .whenComplete(() => loadingHide());
  }

  dynamic exception([dynamic exception]) {
    if (exception == null) {
      emit(ExceptionOccurred(state));
    } else if (exception is GrpcError) {
      if (exception.code == StatusCode.unauthenticated) {
        auth(AuthState.unauthorized);
      } else if (exception.code == StatusCode.unavailable ||
          exception.code == StatusCode.deadlineExceeded) {
        emit(ExceptionOccurred(state, exception));
      }
    } else if (exception is AuthException) {
      auth(AuthState.unauthorized);
      emit(ExceptionOccurred(state, exception));
    } else if (exception is Exception) {
      debugPrint(onError.toString());
      emit(ExceptionOccurred(state, exception));
    }
    throw exception;
  }

  void auth(AuthState auth) =>
      !isClosed ? emit(AuthChanged(state, auth)) : null;
}
