import 'app_exception.dart';

class AuthException extends AppException {
  final String? reason;

  const AuthException(super.message, this.reason);

  factory AuthException.invalidData(String? reason) =>
      AuthException('Invalid Email or Password', reason);

  factory AuthException.needAuth(String? reason) =>
      AuthException('Need auth', reason);

  @override
  bool operator ==(other) =>
      other is AuthException &&
      other.message == message &&
      other.reason == reason;

  @override
  int get hashCode => [message, reason].join().hashCode;
}
