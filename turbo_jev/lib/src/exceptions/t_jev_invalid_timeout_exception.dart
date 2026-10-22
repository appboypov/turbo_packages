part of '../abstracts/t_jev_exception.dart';

/// Thrown when a timeout is zero or negative.
final class TJevInvalidTimeoutException extends TJevException {
  const TJevInvalidTimeoutException({
    required this.message,
    required this.timeout,
  });

  // ⚡️ OVERRIDES

  /// What is wrong with the timeout.
  @override
  final String message;

  @override
  String toString() =>
      'TJevInvalidTimeoutException{message: $message, timeout: $timeout}';

  // 🎩 STATE

  /// The timeout that was given.
  final Duration timeout;
}
