/// The `object` of the one info record a [TJev] client logs per Request,
/// when the Request ends.
final class TJevRequestSummary {
  const TJevRequestSummary({
    required this.method,
    required this.path,
    required this.status,
    required this.requestId,
    required this.retries,
    required this.timeouts,
    required this.aborted,
    required this.elapsed,
  });

  // ⚡️ OVERRIDES

  @override
  String toString() =>
      '$method $path ${aborted ? 'aborted' : '<- ${status ?? 'no response'}'} '
      'in ${elapsed.inMilliseconds}ms after $retries retries and $timeouts '
      'timeouts (request ${requestId ?? '-'})';

  // 🎩 STATE

  /// The HTTP method.
  final String method;

  /// The path of the endpoint, without the base URL.
  final String path;

  /// The HTTP status of the last response, or `null` when no attempt got
  /// one.
  final int? status;

  /// The id TypeSafe gave the last response, if it sent one.
  final String? requestId;

  /// How many retries were sent.
  final int retries;

  /// How many attempts ran out of time.
  final int timeouts;

  /// Whether the abort trigger stopped the Request.
  final bool aborted;

  /// How long the Request took, its retries and waits included.
  final Duration elapsed;
}
