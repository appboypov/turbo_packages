part of 't_jev_failure.dart';

/// A failure TypeSafe answered with a non-2xx HTTP status.
sealed class TJevHttpFailure extends TJevFailure {
  const TJevHttpFailure({
    required this.status,
    required this.requestId,
    required this.headers,
    required this.body,
  });

  /// The failure for a non-2xx [response].
  @internal
  factory TJevHttpFailure.fromResponse(http.Response response) {
    final requestId = response.headers[TJevHttp.requestIdHeader];
    final body = _decodeBody(response);
    return TJevApiStatusFailure(
      status: response.statusCode,
      requestId: requestId,
      headers: response.headers,
      body: body,
    );
  }

  /// The HTTP status code.
  final int status;

  /// The id TypeSafe gave the Request, if it sent one.
  final String? requestId;

  /// The response headers, with lowercase names.
  final Map<String, String> headers;

  /// The response body: decoded JSON, else its text.
  final Object? body;

  static Object? _decodeBody(http.Response response) {
    final text = utf8.decode(response.bodyBytes, allowMalformed: true);
    try {
      return jsonDecode(text);
    } on FormatException {
      return text;
    }
  }

  @override
  String toString() =>
      '$runtimeType{status: $status, requestId: $requestId, body: $body}';
}
