/// The status, request id, headers and body of a response, the fields every
/// failure of a response holds.
///
/// The body is decoded JSON, else its text, or `null` when empty.
typedef TJevResponseFields = ({
  int status,
  String? requestId,
  Map<String, String> headers,
  Object? body,
});
