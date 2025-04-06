import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:retry/retry.dart';
import '../exceptions/connection_exception.dart';

import '../../core/cubits/application_cubit.dart';

export 'analytics_usecase.dart';
export 'app_usecase.dart';
export 'auth_usecase.dart';
export 'profile_usecase.dart';
export 'time_tracking_usecase.dart';

@override
Future<T> getApiRequest<T>(
        Future<T> fn, FutureOr<void> Function(Exception)? onRetry) =>
    retry(() => fn, onRetry: onRetry, retryIf: (exception) => false
        /* exception is AuthException &&
                exception.reason == AuthReasonException.needAuth */
        ).catchError(exception).whenComplete(loadingEnd);

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

String getDeviceId() {
  String deviceIdentifier = '';
  final deviceInfo = GetIt.I<BaseDeviceInfo>();
  if (deviceInfo is WebBrowserInfo) {
    deviceIdentifier =
        '${deviceInfo.vendor}${deviceInfo.userAgent}${deviceInfo.hardwareConcurrency}';
  } else if (deviceInfo is AndroidDeviceInfo) {
    deviceIdentifier = deviceInfo.id;
  } else if (deviceInfo is IosDeviceInfo) {
    deviceIdentifier = deviceInfo.identifierForVendor ??
        '${deviceInfo.name}${deviceInfo.model}${deviceInfo.systemVersion}';
  } else if (deviceInfo is LinuxDeviceInfo) {
    deviceIdentifier =
        deviceInfo.machineId ?? '${deviceInfo.name}${deviceInfo.id}';
  } else if (deviceInfo is MacOsDeviceInfo) {
    deviceIdentifier = deviceInfo.systemGUID ??
        '${deviceInfo.computerName}${deviceInfo.model}${deviceInfo.kernelVersion}';
  } else if (deviceInfo is WindowsDeviceInfo) {
    deviceIdentifier = deviceInfo.deviceId;
  }
  return deviceIdentifier.hashCode.toRadixString(16);
}

void checkConnection() => throwIf(
    (GetIt.I<ApplicationCubit>().state.connection ?? ConnectivityResult.none) ==
        ConnectivityResult.none,
    ConnectionException.connectionNotFound());
