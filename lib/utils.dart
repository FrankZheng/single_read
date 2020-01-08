String formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes % 60;
  int seconds = duration.inSeconds % 60;
  if (hours > 0) {
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  } else {
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

int safeParseInt(dynamic data, {int radix, int fallbackValue = 0}) {
  return int.tryParse(data.toString(), radix: radix) ?? fallbackValue;
}
