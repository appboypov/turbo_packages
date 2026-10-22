part of '../abstracts/t_jev_failure.dart';

/// A 2xx response whose body does not fit the Request: no JSON, a missing or
/// mistyped field, a missing Answer, or an Answer whose type or keys do not
/// fit its Question.
final class TJevResponseValidationFailure extends TJevFailure {
  const TJevResponseValidationFailure({
    required this.message,
    required this.status,
    required this.requestId,
    required this.headers,
    required this.body,
  });

  /// The failure for a 2xx [response] whose body does not fit, as [message]
  /// says.
  @internal
  factory TJevResponseValidationFailure.fromResponse(
    http.Response response, {
    required String message,
  }) {
    final (:status, :requestId, :headers, :body) =
        TJevHttpFailure._responseFieldsOf(response);
    return TJevResponseValidationFailure(
      message: message,
      status: status,
      requestId: requestId,
      headers: headers,
      body: body,
    );
  }

  // ⚡️ OVERRIDES

  @override
  String toString() =>
      'TJevResponseValidationFailure{message: $message, status: $status, '
      'requestId: $requestId}';

  // 🎩 STATE

  /// The path of the field that does not fit and what is wrong with it.
  @override
  final String message;

  /// The HTTP status code.
  final int status;

  /// The id TypeSafe gave the Request, if it sent one.
  final String? requestId;

  /// The response headers, with lowercase names.
  final Map<String, String> headers;

  /// The response body: decoded JSON, else its text.
  final Object? body;
}
