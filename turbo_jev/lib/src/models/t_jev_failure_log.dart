import '../abstracts/t_jev_failure.dart';

/// The `object` of the error record a [TJev] client logs when a Request
/// ends in a [TJevFailure] other than a [TJevAbortedFailure].
final class TJevFailureLog {
  const TJevFailureLog({
    required this.method,
    required this.path,
    required this.attempt,
    required this.failureType,
    required this.message,
    required this.status,
    required this.requestId,
  });

  // ⚡️ OVERRIDES

  @override
  String toString() =>
      '$method $path failed with $failureType '
      '(${status ?? 'no response'}) after $attempt attempts: $message '
      '(request ${requestId ?? '-'})';

  // 🎩 STATE

  /// The HTTP method.
  final String method;

  /// The path of the endpoint, without the base URL.
  final String path;

  /// The number of the last attempt: 1 for the first send, 2 for the first
  /// retry.
  final int attempt;

  /// The type of the [TJevFailure] the Request ended with.
  final Type failureType;

  /// The message of the failure. With body redaction on, a message taken
  /// from a JSON body has each secret field value replaced.
  final String message;

  /// The HTTP status of the last attempt, or `null` when it got no
  /// response.
  final int? status;

  /// The id TypeSafe gave the last attempt, if it sent one.
  final String? requestId;
}
