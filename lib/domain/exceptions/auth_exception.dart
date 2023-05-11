import 'app_exception.dart';

class AuthException extends AppException {
  final AuthReasonException reason;

  const AuthException(super.message, this.reason);

  factory AuthException.wrongEmailData() => const AuthException(
      'Invalid Email or Password', AuthReasonException.invalidData);

  factory AuthException.needAuth() =>
      const AuthException('Need auth', AuthReasonException.needAuth);

  factory AuthException.doubleAuthData() => const AuthException(
      'Such data is already registered in the system. Perform authorization.',
      AuthReasonException.invalidData);

  factory AuthException.wrongAuthData() => const AuthException(
      'Authorization data is not correct', AuthReasonException.needAuth);

  factory AuthException.undefined() => const AuthException(
      'Undefined authorization error', AuthReasonException.undefined);

  factory AuthException.parse(String? message) {
    if (message == null) return AuthException.undefined();

    if (message.toLowerCase().contains('email')) {
      return AuthException.wrongEmailData();
    } else if (message.toLowerCase().contains('already registered')) {
      return AuthException.doubleAuthData();
    } else if (message.toLowerCase().contains('is not correct')) {
      return AuthException.wrongAuthData();
    } else {
      return AuthException.undefined();
    }
  }

  @override
  bool operator ==(other) =>
      other is AuthException &&
      other.message == message &&
      other.reason == reason;

  @override
  int get hashCode => [message, reason].join().hashCode;
}

enum AuthReasonException { undefined, invalidData, needAuth }
