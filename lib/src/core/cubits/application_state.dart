part of 'application_cubit.dart';

abstract class ApplicationState extends Equatable {
  AuthState get auth;
  ThemeMode get themeMode;
  bool get isLoading;
  ConnectivityResult? get connection;
  Exception? get exception;
  bool get launchAtStartup;

  @override
  List<Object> get props => [themeMode,isLoading];
}

class ApplicationInitial extends ApplicationState {
  @override
  final AuthState auth = AuthState.unknown;
  @override
  final ThemeMode themeMode;
  @override
  final bool isLoading = false;
  @override
  final ConnectivityResult? connection = null;
  @override
  final Exception? exception = null;
  @override
  final bool launchAtStartup = false;

  ApplicationInitial()
      : themeMode = ThemeMode.system;
}

class ThemeChanged extends ApplicationState {
  final bool _isLoading;
  final ConnectivityResult? _connection;
  final Exception? _exception;
  final AuthState _auth;
  final bool _launchAtStartup;

  @override
  AuthState get auth => _auth;
  @override
  final ThemeMode themeMode;
  @override
  bool get isLoading => _isLoading;
  @override
  ConnectivityResult? get connection => _connection;
  @override
  Exception? get exception => _exception;
  @override
  bool get launchAtStartup => _launchAtStartup;

  ThemeChanged(ApplicationState state, this.themeMode)
      : _connection = state.connection,
        _isLoading = state.isLoading,
        _exception = state.exception,
        _auth = state.auth,
        _launchAtStartup = state.launchAtStartup;
}

class IsLoadingChanged extends ApplicationState {
  final ThemeMode _themeMode;
  final ConnectivityResult? _connection;
  final Exception? _exception;
  final AuthState _auth;
  final bool _launchAtStartup;

  @override
  AuthState get auth => _auth;
  @override
  ThemeMode get themeMode => _themeMode; 
  @override
  final bool isLoading;
  @override
  ConnectivityResult? get connection => _connection;
  @override
  Exception? get exception => _exception;
  @override
  bool get launchAtStartup => _launchAtStartup;

  IsLoadingChanged(ApplicationState state, this.isLoading)
      : _connection = state.connection,
        _themeMode = state.themeMode,       
        _exception = state.exception,
        _auth = state.auth,
        _launchAtStartup = state.launchAtStartup;

  @override
  List<Object> get props => [isLoading];
}

class ExceptionOccurred extends ApplicationState {
  final ThemeMode _themeMode;
  final bool _isLoading;
  final ConnectivityResult? _connection;
  final AuthState _auth;
  final bool _launchAtStartup;

  @override
  AuthState get auth => _auth;
  @override
  ThemeMode get themeMode => _themeMode; 
  @override
  ConnectivityResult? get connection => _connection;
  @override
  bool get isLoading => _isLoading;
  @override
  final Exception? exception;
  @override
  bool get launchAtStartup => _launchAtStartup;

  ExceptionOccurred(ApplicationState state, [this.exception])
      : _connection = state.connection,
        _themeMode = state.themeMode,
              _isLoading = state.isLoading,
        _auth = state.auth,
        _launchAtStartup = state.launchAtStartup;

  @override
  List<Object> get props => [exception != null ? true : false];
}

class NetworkChanged extends ApplicationState {
  final ThemeMode _themeMode;
  final bool _isLoading;
  final Exception? _exception;
  final AuthState _auth;
  final bool _launchAtStartup;

  @override
  AuthState get auth => _auth;
  @override
  ThemeMode get themeMode => _themeMode;
   @override
  bool get isLoading => _isLoading;
  @override
  final ConnectivityResult connection;
  @override
  Exception? get exception => _exception;
  @override
  bool get launchAtStartup => _launchAtStartup;

  NetworkChanged(ApplicationState state, this.connection)
      : _themeMode = state.themeMode,
        _isLoading = state.isLoading,
        _exception = state.exception,
        _auth = state.auth,
        _launchAtStartup = state.launchAtStartup;

  @override
  List<Object> get props => [connection];
}

class AuthChanged extends ApplicationState {
  final ThemeMode _themeMode;
  final bool _isLoading;
  final ConnectivityResult? _connection;
  final Exception? _exception;
  final bool _launchAtStartup;

  @override
  final AuthState auth;
  @override
  ThemeMode get themeMode => _themeMode;
  @override
  bool get isLoading => _isLoading;
  @override
  ConnectivityResult? get connection => _connection;
  @override
  Exception? get exception => _exception;
  @override
  bool get launchAtStartup => _launchAtStartup;

  AuthChanged(ApplicationState state, this.auth)
      : _themeMode = state.themeMode,
        _isLoading = state.isLoading,
        _connection = state.connection,
        _exception = state.exception,
        _launchAtStartup = state.launchAtStartup;

  @override
  List<Object> get props => [auth];
}

class LaunchAtStartupChanged extends ApplicationState {
  final ThemeMode _themeMode;
  final bool _isLoading;
  final ConnectivityResult? _connection;
  final Exception? _exception;
  final AuthState _auth;

  @override
  AuthState get auth => _auth;
  @override
  ThemeMode get themeMode => _themeMode;
  @override
  bool get isLoading => _isLoading;
  @override
  ConnectivityResult? get connection => _connection;
  @override
  Exception? get exception => _exception;
  @override
  final bool launchAtStartup;

  LaunchAtStartupChanged(ApplicationState state, this.launchAtStartup)
      : _themeMode = state.themeMode,
        _isLoading = state.isLoading,
        _connection = state.connection,
        _auth = state.auth,
        _exception = state.exception;

  @override
  List<Object> get props => [launchAtStartup];
}
