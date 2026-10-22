import '../abstracts/t_jev_failure.dart';

/// The `object` of the warning record a [TJev] client logs each time it
/// retries a Request, before it waits.
final class TJevRetryLog {
  const TJevRetryLog({
    required this.method,
    required this.path,
    required this.attempt,
    required this.failureType,
    required this.message,
    required this.status,
    required this.requestId,
    required this.delay,
  });

  /// The HTTP method.
  final String method;

  /// The path of the endpoint, without the base URL.
  final String path;

  /// The number of the attempt that failed: 1 for the first send, 2 for the
  /// first Retry.
  final int attempt;

  /// The type of the [TJevFailure] the attempt failed with.
  final Type failureType;

  /// The message of the failure. With body redaction on, a message taken
  /// from a JSON body has each secret field value replaced.
  final String message;

  /// The HTTP status of the failed attempt, or `null` when it got no
  /// response.
  final int? status;

  /// The id TypeSafe gave the failed attempt, if it sent one.
  final String? requestId;

  /// How long the client waits before the next attempt.
  final Duration delay;

  @override
  String toString() =>
      '$method $path attempt $attempt failed with $failureType '
      '(${status ?? 'no response'}): $message; retrying in '
      '${delay.inMilliseconds}ms (request ${requestId ?? '-'})';
}
