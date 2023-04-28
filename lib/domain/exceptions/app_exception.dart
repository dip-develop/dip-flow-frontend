class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;

  @override
  bool operator ==(other) => other is AppException && other.message == message;

  @override
  int get hashCode => message.hashCode;
}
