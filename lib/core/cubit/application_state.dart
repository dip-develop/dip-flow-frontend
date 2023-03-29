part of 'application_cubit.dart';

abstract class ApplicationState extends Equatable {
  AuthState get auth;
  ThemeMode get themeMode;
  AppTheme get theme;
  bool get isLoading;
  ConnectivityResult? get connection;
  Exception? get exception;

  @override
  List<Object> get props => [themeMode, theme, isLoading];
}

class ApplicationInitial extends ApplicationState {
  @override
  final AuthState auth = AuthState.unknown;
  @override
  final ThemeMode themeMode;
  @override
  final AppTheme theme;
  @override
  final bool isLoading = false;
  @override
  final ConnectivityResult? connection = null;
  @override
  final Exception? exception = null;

  ApplicationInitial()
      : themeMode = ThemeMode.system,
        theme = SchedulerBinding.instance.window.platformBrightness ==
                Brightness.dark
            ? const DarkAppThemeImpl()
            : const LightAppThemeImpl();
}

class ThemeChanged extends ApplicationState {
  final AppTheme _theme;
  final bool _isLoading;
  final ConnectivityResult? _connection;
  final Exception? _exception;
  final AuthState _auth;

  @override
  AuthState get auth => _auth;
  @override
  final ThemeMode themeMode;
  @override
  AppTheme get theme => _theme;
  @override
  bool get isLoading => _isLoading;
  @override
  ConnectivityResult? get connection => _connection;
  @override
  Exception? get exception => _exception;

  ThemeChanged(ApplicationState state, this.themeMode)
      : _connection = state.connection,
        _theme = themeMode == ThemeMode.dark ||
                (themeMode == ThemeMode.system &&
                    SchedulerBinding.instance.window.platformBrightness ==
                        Brightness.dark)
            ? const DarkAppThemeImpl()
            : const LightAppThemeImpl(),
        _isLoading = state.isLoading,
        _exception = state.exception,
        _auth = state.auth;
}

class IsLoadingChanged extends ApplicationState {
  final ThemeMode _themeMode;
  final AppTheme _theme;
  final ConnectivityResult? _connection;
  final Exception? _exception;
  final AuthState _auth;

  @override
  AuthState get auth => _auth;
  @override
  ThemeMode get themeMode => _themeMode;
  @override
  AppTheme get theme => _theme;
  @override
  final bool isLoading;
  @override
  ConnectivityResult? get connection => _connection;
  @override
  Exception? get exception => _exception;

  IsLoadingChanged(ApplicationState state, this.isLoading)
      : _connection = state.connection,
        _themeMode = state.themeMode,
        _theme = state.theme,
        _exception = state.exception,
        _auth = state.auth;

  @override
  List<Object> get props => [isLoading];
}

class ExceptionOccurred extends ApplicationState {
  final ThemeMode _themeMode;
  final AppTheme _theme;
  final bool _isLoading;
  final ConnectivityResult? _connection;
  final AuthState _auth;

  @override
  AuthState get auth => _auth;
  @override
  ThemeMode get themeMode => _themeMode;
  @override
  AppTheme get theme => _theme;
  @override
  ConnectivityResult? get connection => _connection;
  @override
  bool get isLoading => _isLoading;
  @override
  final Exception exception;

  ExceptionOccurred(ApplicationState state, this.exception)
      : _connection = state.connection,
        _themeMode = state.themeMode,
        _theme = state.theme,
        _isLoading = state.isLoading,
        _auth = state.auth;

  @override
  List<Object> get props => [exception];
}

class NetworkChanged extends ApplicationState {
  final ThemeMode _themeMode;
  final AppTheme _theme;
  final bool _isLoading;
  final Exception? _exception;
  final AuthState _auth;

  @override
  AuthState get auth => _auth;
  @override
  ThemeMode get themeMode => _themeMode;
  @override
  AppTheme get theme => _theme;
  @override
  bool get isLoading => _isLoading;
  @override
  final ConnectivityResult connection;
  @override
  Exception? get exception => _exception;

  NetworkChanged(ApplicationState state, this.connection)
      : _themeMode = state.themeMode,
        _theme = state.theme,
        _isLoading = state.isLoading,
        _exception = state.exception,
        _auth = state.auth;

  @override
  List<Object> get props => [connection];
}

class AuthChanged extends ApplicationState {
  final ThemeMode _themeMode;
  final AppTheme _theme;
  final bool _isLoading;
  final ConnectivityResult? _connection;
  final Exception? _exception;

  @override
  final AuthState auth;
  @override
  ThemeMode get themeMode => _themeMode;
  @override
  AppTheme get theme => _theme;
  @override
  bool get isLoading => _isLoading;
  @override
  ConnectivityResult? get connection => _connection;
  @override
  Exception? get exception => _exception;

  AuthChanged(ApplicationState state, this.auth)
      : _themeMode = state.themeMode,
        _theme = state.theme,
        _isLoading = state.isLoading,
        _connection = state.connection,
        _exception = state.exception;

  @override
  List<Object> get props => [auth];
}
