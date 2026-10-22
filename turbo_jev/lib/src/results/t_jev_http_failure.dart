part of '../abstracts/t_jev_failure.dart';

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
    final (:status, :requestId, :headers, :body) = _responseFieldsOf(
      response,
    );
    final details = _validationDetailsOf(body);
    final message = _messageOf(body, details);
    return switch (status) {
      TJevHttp.badRequestStatus => TJevBadRequestFailure._(
        status: status,
        message: message,
        requestId: requestId,
        headers: headers,
        body: body,
      ),
      TJevHttp.unauthorizedStatus => TJevAuthenticationFailure._(
        status: status,
        message: message,
        requestId: requestId,
        headers: headers,
        body: body,
      ),
      TJevHttp.forbiddenStatus => TJevPermissionDeniedFailure._(
        status: status,
        message: message,
        requestId: requestId,
        headers: headers,
        body: body,
      ),
      TJevHttp.notFoundStatus => TJevNotFoundFailure._(
        status: status,
        message: message,
        requestId: requestId,
        headers: headers,
        body: body,
      ),
      TJevHttp.unprocessableEntityStatus => TJevUnprocessableEntityFailure._(
        status: status,
        message: message,
        requestId: requestId,
        headers: headers,
        body: body,
        details: details,
      ),
      TJevHttp.tooManyRequestsStatus => TJevRateLimitFailure._(
        status: status,
        message: message,
        requestId: requestId,
        headers: headers,
        body: body,
        retryAfter: const TJevRetryAfterService().delayOf(headers),
      ),
      >= TJevHttp.minServerErrorStatus => TJevInternalServerFailure._(
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

  /// The HTTP status code.
  final int status;

  /// Why TypeSafe failed the Request, read from [body].
  ///
  /// It is the first of: an `error` string, `error.message`, `message`, a
  /// `detail` string, `detail.message`, and the entries of a `detail` list
  /// as `path: message` joined with `; `. Without any of these it is the
  /// text of [body], cut at 200 characters.
  @override
  final String message;

  /// The id TypeSafe gave the Request, if it sent one.
  final String? requestId;

  /// The response headers, with lowercase names.
  final Map<String, String> headers;

  /// The response body: decoded JSON, else its text, or `null` when empty.
  final Object? body;

  /// The fields of [response] every failure of a response holds.
  static TJevResponseFields _responseFieldsOf(http.Response response) {
    final text = utf8.decode(response.bodyBytes, allowMalformed: true);
    Object? body;
    if (text.isNotEmpty) {
      try {
        body = jsonDecode(text);
      } on FormatException {
        body = text;
      }
    }
    return (
      status: response.statusCode,
      requestId: response.headers[TJevHttp.requestIdHeader],
      headers: response.headers,
      body: body,
    );
  }

  static String _messageOf(Object? body, List<TJevValidationDetail> details) {
    final message = switch (body) {
      String() when body.isNotEmpty => body,
      {TJevHttp.errorKey: final String error} => error,
      {TJevHttp.errorKey: {TJevHttp.messageKey: final String message}} =>
        message,
      {TJevHttp.messageKey: final String message} => message,
      {TJevHttp.detailKey: final String detail} => detail,
      {TJevHttp.detailKey: {TJevHttp.messageKey: final String message}} =>
        message,
      {TJevHttp.detailKey: List()} when details.isNotEmpty => details.join(
        TJevMessages.validationDetailSeparator,
      ),
      _ => null,
    };
    if (message != null) return message;
    if (body == null) return TJevMessages.noBody;
    final raw = body is String ? body : jsonEncode(body);
    final characters = raw.runes;
    return characters.length > TJevLimits.maxRawBodyLength
        ? '${String.fromCharCodes(characters.take(TJevLimits.maxRawBodyLength))}'
              '${TJevMessages.cutMarker}'
        : raw;
  }

  /// The entries of a `detail` list in [body] that hold a `msg` string.
  static List<TJevValidationDetail> _validationDetailsOf(Object? body) => [
    if (body case {TJevHttp.detailKey: final List<Object?> detail})
      for (final entry in detail)
        if (entry case {TJevHttp.detailMessageKey: final String message})
          TJevValidationDetail(
            location: switch (entry) {
              {TJevHttp.detailLocationKey: final List<Object?> location} =>
                location,
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
