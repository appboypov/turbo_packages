part of 't_jev_failure.dart';

/// A 2xx response whose body does not fit the Request: no JSON, a missing or
/// mistyped field, a missing Answer, or an Answer whose type or keys do not
/// fit its Question.
final class TJevResponseValidationFailure extends TJevFailure {
  const TJevResponseValidationFailure({
    required this.reason,
    required this.status,
    required this.requestId,
    required this.headers,
    required this.body,
  });

  /// The failure for a 2xx [response] whose body does not fit for [reason].
  @internal
  factory TJevResponseValidationFailure.fromResponse(
    http.Response response, {
    required String reason,
  }) => TJevResponseValidationFailure(
    reason: reason,
    status: response.statusCode,
    requestId: response.headers[TJevHttp.requestIdHeader],
    headers: response.headers,
    body: TJevHttpFailure._decodeBody(response),
  );

  /// The path of the field that does not fit and what is wrong with it.
  final String reason;

  /// The HTTP status code.
  final int status;

  /// The id TypeSafe gave the Request, if it sent one.
  final String? requestId;

  /// The response headers, with lowercase names.
  final Map<String, String> headers;

  /// The response body: decoded JSON, else its text.
  final Object? body;

  @override
  String toString() =>
      'TJevResponseValidationFailure{reason: $reason, status: $status, '
      'requestId: $requestId}';
}
