part of 'application_cubit.dart';

abstract class ApplicationState extends Equatable {
  ThemeMode get themeMode;
  AppTheme get theme;
  bool get isLoading;
  ConnectivityResult? get connection;

  @override
  List<Object> get props => [themeMode, theme, isLoading];
}

class ApplicationInitial extends ApplicationState {
  final ThemeMode _themeMode;
  final AppTheme _theme;

  @override
  ThemeMode get themeMode => _themeMode;
  @override
  AppTheme get theme => _theme;
  @override
  bool get isLoading => false;
  @override
  ConnectivityResult? get connection => null;

  ApplicationInitial()
      : _themeMode = ThemeMode.system,
        _theme = SchedulerBinding.instance.window.platformBrightness ==
                Brightness.dark
            ? const DarkAppThemeImpl()
            : const LightAppThemeImpl();
}

class ThemeChanged extends ApplicationState {
  final ThemeMode _themeMode;
  final AppTheme _theme;
  final bool _isLoading;
  final ConnectivityResult? _connection;

  @override
  ThemeMode get themeMode => _themeMode;
  @override
  AppTheme get theme => _theme;
  @override
  bool get isLoading => _isLoading;
  @override
  ConnectivityResult? get connection => _connection;

  ThemeChanged(ApplicationState state, ThemeMode themeMode)
      : _connection = state.connection,
        _themeMode = themeMode,
        _theme = themeMode == ThemeMode.dark ||
                (themeMode == ThemeMode.system &&
                    SchedulerBinding.instance.window.platformBrightness ==
                        Brightness.dark)
            ? const DarkAppThemeImpl()
            : const LightAppThemeImpl(),
        _isLoading = state.isLoading;
}

class IsLoadingChanged extends ApplicationState {
  final ThemeMode _themeMode;
  final AppTheme _theme;
  final bool _isLoading;
  final ConnectivityResult? _connection;

  @override
  ThemeMode get themeMode => _themeMode;
  @override
  AppTheme get theme => _theme;
  @override
  bool get isLoading => _isLoading;
  @override
  ConnectivityResult? get connection => _connection;

  IsLoadingChanged(ApplicationState state, bool isLoading)
      : _connection = state.connection,
        _themeMode = state.themeMode,
        _theme = state.theme,
        _isLoading = isLoading;
}

class ExceptionOccurred extends ApplicationState {
  final ThemeMode _themeMode;
  final AppTheme _theme;
  final bool _isLoading;
  final Exception _exception;
  final ConnectivityResult? _connection;

  @override
  ThemeMode get themeMode => _themeMode;
  @override
  AppTheme get theme => _theme;
  @override
  bool get isLoading => _isLoading;
  Exception get exception => _exception;
  @override
  ConnectivityResult? get connection => _connection;

  ExceptionOccurred(ApplicationState state, Exception exception)
      : _connection = state.connection,
        _themeMode = state.themeMode,
        _theme = state.theme,
        _isLoading = state.isLoading,
        _exception = exception;

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) => false;

  @override
  List<Object> get props => [themeMode, theme, isLoading, exception];
}

class NetworkChanged extends ApplicationState {
  final ThemeMode _themeMode;
  final AppTheme _theme;
  final bool _isLoading;

  @override
  ThemeMode get themeMode => _themeMode;
  @override
  AppTheme get theme => _theme;
  @override
  bool get isLoading => _isLoading;

  @override
  final ConnectivityResult connection;

  NetworkChanged(ApplicationState state, this.connection)
      : _themeMode = state.themeMode,
        _theme = state.theme,
        _isLoading = state.isLoading;

  @override
  List<Object> get props => [connection];
}
