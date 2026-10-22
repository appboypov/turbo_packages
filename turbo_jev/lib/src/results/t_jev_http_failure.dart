part of 't_jev_failure.dart';

/// A failure TypeSafe answered with a non-2xx HTTP status.
sealed class TJevHttpFailure extends TJevFailure {
  const TJevHttpFailure({
    required this.status,
    required this.message,
    required this.requestId,
    required this.headers,
    required this.body,
  });

  /// The failure for a non-2xx [response], typed by its status.
  @internal
  factory TJevHttpFailure.fromResponse(http.Response response) {
    final status = response.statusCode;
    final body = _decodeBody(response);
    final details = _validationDetailsOf(body);
    final message = _messageOf(body, details);
    final requestId = response.headers[TJevHttp.requestIdHeader];
    final headers = response.headers;
    return switch (status) {
      400 => TJevBadRequestFailure._(
        status: status,
        message: message,
        requestId: requestId,
        headers: headers,
        body: body,
      ),
      401 => TJevAuthenticationFailure._(
        status: status,
        message: message,
        requestId: requestId,
        headers: headers,
        body: body,
      ),
      403 => TJevPermissionDeniedFailure._(
        status: status,
        message: message,
        requestId: requestId,
        headers: headers,
        body: body,
      ),
      404 => TJevNotFoundFailure._(
        status: status,
        message: message,
        requestId: requestId,
        headers: headers,
        body: body,
      ),
      422 => TJevUnprocessableEntityFailure._(
        status: status,
        message: message,
        requestId: requestId,
        headers: headers,
        body: body,
        details: details,
      ),
      429 => TJevRateLimitFailure._(
        status: status,
        message: message,
        requestId: requestId,
        headers: headers,
        body: body,
        retryAfter: retryAfterOf(headers),
      ),
      >= 500 => TJevInternalServerFailure._(
        status: status,
        message: message,
        requestId: requestId,
        headers: headers,
        body: body,
      ),
      _ => TJevOtherStatusFailure._(
        status: status,
        message: message,
        requestId: requestId,
        headers: headers,
        body: body,
      ),
    };
  }

  /// The longest raw body, in characters, that [message] holds uncut.
  static const _maxRawBodyLength = 200;

  /// The HTTP status code.
  final int status;

  /// Why TypeSafe failed the Request, read from [body].
  ///
  /// It is the first of: an `error` string, `error.message`, `message`, a
  /// `detail` string, `detail.message`, and the entries of a `detail` list
  /// as `path: message` joined with `; `. Without any of these it is the
  /// text of [body], cut at 200 characters.
  final String message;

  /// The id TypeSafe gave the Request, if it sent one.
  final String? requestId;

  /// The response headers, with lowercase names.
  final Map<String, String> headers;

  /// The response body: decoded JSON, else its text, or `null` when empty.
  final Object? body;

  static Object? _decodeBody(http.Response response) {
    final text = utf8.decode(response.bodyBytes, allowMalformed: true);
    if (text.isEmpty) return null;
    try {
      return jsonDecode(text);
    } on FormatException {
      return text;
    }
  }

  static String _messageOf(Object? body, List<TJevValidationDetail> details) {
    final message = switch (body) {
      String() when body.isNotEmpty => body,
      {'error': final String error} => error,
      {'error': {'message': final String message}} => message,
      {'message': final String message} => message,
      {'detail': final String detail} => detail,
      {'detail': {'message': final String message}} => message,
      {'detail': List()} when details.isNotEmpty => details.join('; '),
      _ => null,
    };
    if (message != null) return message;
    if (body == null) return 'status code (no body)';
    final raw = body is String ? body : jsonEncode(body);
    final characters = raw.runes;
    return characters.length > _maxRawBodyLength
        ? '${String.fromCharCodes(characters.take(_maxRawBodyLength))}…'
        : raw;
  }

  /// The entries of a `detail` list in [body] that hold a `msg` string.
  static List<TJevValidationDetail> _validationDetailsOf(Object? body) => [
    if (body case {'detail': final List<Object?> detail})
      for (final entry in detail)
        if (entry case {'msg': final String message})
          TJevValidationDetail(
            location: switch (entry) {
              {'loc': final List<Object?> location} => location,
              _ => const [],
            },
            message: message,
          ),
  ];

  @override
  String toString() =>
      '$runtimeType{status: $status, message: $message, '
      'requestId: $requestId}';
}
