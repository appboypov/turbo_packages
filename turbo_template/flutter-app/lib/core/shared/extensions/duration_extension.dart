extension DurationExtension on Duration {
  Duration add(Duration? duration) =>
      Duration(milliseconds: inMilliseconds + (duration?.inMilliseconds ?? 0));
  Future<void> get asFuture async => await Future.delayed(this);
}
