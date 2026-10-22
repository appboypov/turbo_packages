import '../constants/t_jev_logging.dart';

/// The `object` of the debug record a [TJev] client logs for each response
/// it receives.
final class TJevResponseLog {
  const TJevResponseLog({
    required this.method,
    required this.path,
    required this.status,
    required this.headers,
    required this.body,
    required this.omittedBodyBytes,
  });

  // ⚡️ OVERRIDES

  @override
  String toString() =>
      '$method $path <- $status headers=$headers body=$body'
      '${omittedBodyBytes > 0 ? ' (+$omittedBodyBytes bytes)' : ''}';

  // 🎩 STATE

  /// The HTTP method of the Request.
  final String method;

  /// The path of the endpoint, without the base URL.
  final String path;

  /// The HTTP status.
  final int status;

  /// The received headers, each secret value replaced by
  /// [TJevLogging.redactedValue].
  final Map<String, String> headers;

  /// The body as text, cut at [TJevLogging.maxLoggedBodyBytes] bytes, or
  /// `null` when it is empty. With body redaction on, a JSON body has each
  /// secret field value replaced by [TJevLogging.redactedValue] before the
  /// cut.
  final String? body;

  /// How many bytes of the body [body] leaves out.
  final int omittedBodyBytes;
}
