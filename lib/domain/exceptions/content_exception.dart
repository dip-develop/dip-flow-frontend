import 'app_exception.dart';

class ContentException extends AppException {
  final String? reason;

  const ContentException(super.message, [this.reason]);

  factory ContentException.notFound([String? reason]) {
    return ContentException('Content not found', reason);
  }

  @override
  bool operator ==(other) =>
      other is ContentException &&
      other.message == message &&
      other.reason == reason;

  @override
  int get hashCode => [message, reason].join().hashCode;
}
