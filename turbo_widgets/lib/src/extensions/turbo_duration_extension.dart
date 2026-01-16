extension TurboDurationExtension on Duration {
  Duration turboAdd(Duration? duration) =>
      Duration(milliseconds: inMilliseconds + (duration?.inMilliseconds ?? 0));
  Future<void> get turboAsFuture async => await Future.delayed(this);
}
