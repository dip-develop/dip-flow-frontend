extension DurationExtension on Duration {
  String format({shot = true}) {
    String format = '';
    final second = (inSeconds % 60).toInt();
    final minutes = (inMinutes % 60).toInt();

    format += '${inHours.toString().padLeft(2, '0')}:';
    format += minutes.toString().padLeft(2, '0');
    if (!shot) format += ':${second.toString().padLeft(2, '0')}';
    return format;
  }
}
