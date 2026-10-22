/// Thrown when a timeout is zero or negative.
final class TJevInvalidTimeoutException implements Exception {
  const TJevInvalidTimeoutException({
    required this.reason,
    required this.timeout,
  });

  /// What is wrong with the timeout.
  final String reason;

  /// The timeout that was given.
  final Duration timeout;

  @override
  String toString() =>
      'TJevInvalidTimeoutException{reason: $reason, timeout: $timeout}';
}
