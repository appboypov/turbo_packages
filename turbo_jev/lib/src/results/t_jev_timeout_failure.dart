part of '../abstracts/t_jev_failure.dart';

/// The whole response did not arrive within the timeout of the attempt.
final class TJevTimeoutFailure extends TJevFailure {
  @internal
  const TJevTimeoutFailure({required this.timeout});

  // ⚡️ OVERRIDES

  @override
  String get message => TJevMessages.timedOut(timeout);

  @override
  String toString() => 'TJevTimeoutFailure{timeout: $timeout}';

  // 🎩 STATE

  /// The timeout the attempt had.
  final Duration timeout;
}
