extension TDurationExtension on Duration {
  Duration tAdd(Duration? duration) =>
      Duration(milliseconds: inMilliseconds + (duration?.inMilliseconds ?? 0));
  Future<void> get tAsFuture async => await Future.delayed(this);
}
