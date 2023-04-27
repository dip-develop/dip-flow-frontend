import 'app_exception.dart';

class ConnectionException extends AppException {
  final String? reason;

  const ConnectionException(super.message, [this.reason]);

  factory ConnectionException.connectionNotFound([String? reason]) {
    return ConnectionException('Establish a connection first', reason);
  }

  factory ConnectionException.timeout([String? reason]) {
    return ConnectionException('Timeout connection', reason);
  }
}
