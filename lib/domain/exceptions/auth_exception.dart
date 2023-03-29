import 'app_exception.dart';

class AuthException extends AppException {
  final String? reason;

  const AuthException(super.message, this.reason);

  factory AuthException.invalidData(String? reason) =>
      AuthException('Invalid Email or Password', reason);
}
