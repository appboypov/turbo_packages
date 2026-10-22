/// Thrown when a timeout is zero or negative.
final class TJevInvalidTimeoutException implements Exception {
  const TJevInvalidTimeoutException({required this.timeout});

  /// The timeout that was given.
  final Duration timeout;

  @override
  String toString() =>
      'TJevInvalidTimeoutException{timeout: $timeout, '
      'reason: A timeout must be positive.}';
}
