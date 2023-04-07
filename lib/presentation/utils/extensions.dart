extension DurationExtension on Duration {
  String format() => toString().split('.').first.padLeft(8, '0');
}
