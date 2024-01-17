class Utils {
  static String formatTime(int seconds) {
    var t = Duration(seconds: seconds);
    if (t.inHours > 0) {
      return '${t.inHours}h:${t.inMinutes.remainder(60)}m:${t.inSeconds.remainder(60)}s';
    }
    return t.inMinutes > 0
        ? '${t.inMinutes}m:${t.inSeconds.remainder(60)}s'
        : '${t.inSeconds}s';
  }
}
