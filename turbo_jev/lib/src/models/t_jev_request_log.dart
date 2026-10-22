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

  /// The body before compression as text, cut at
  /// [TJevLogging.maxLoggedBodyBytes] bytes, or `null` without a body. With
  /// body redaction on, a JSON body, or the `request` part of a multipart
  /// body, has each secret field value replaced by [TJevLogging.redactedValue]
  /// before the cut. The other parts of a multipart body stay as they are,
  /// the bytes of its Images included.
  final String? body;

  /// How many bytes of the body [body] leaves out.
  final int omittedBodyBytes;
}
