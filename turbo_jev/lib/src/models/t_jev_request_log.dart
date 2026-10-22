import '../constants/t_jev_logging.dart';

/// The `object` of the debug record a [TJev] client logs for each attempt
/// it sends.
final class TJevRequestLog {
  const TJevRequestLog({
    required this.method,
    required this.path,
    required this.attempt,
    required this.headers,
    required this.body,
    required this.omittedBodyBytes,
  });

  // ⚡️ OVERRIDES

  @override
  String toString() =>
      '$method $path -> attempt $attempt headers=$headers body=$body'
      '${omittedBodyBytes > 0 ? ' (+$omittedBodyBytes bytes)' : ''}';

  // 🎩 STATE

  /// The HTTP method.
  final String method;

  /// The path of the endpoint, without the base URL.
  final String path;

  /// The number of the attempt: 1 for the first send, 2 for the first
  /// retry.
  final int attempt;

  /// The sent headers, each secret value replaced by
  /// [TJevLogging.redactedValue].
  final Map<String, String> headers;

  /// The JSON of the body before compression as text, cut at
  /// [TJevLogging.maxLoggedBodyBytes] bytes, or `null` without a body: the
  /// whole body when it is JSON, its `request` part when it is multipart.
  /// With body redaction on, each secret field value is replaced by
  /// [TJevLogging.redactedValue] before the cut.
  final String? body;

  /// How many bytes of the body [body] leaves out: the bytes past the cut
  /// and the other parts of a multipart body, its Images included.
  final int omittedBodyBytes;
}
