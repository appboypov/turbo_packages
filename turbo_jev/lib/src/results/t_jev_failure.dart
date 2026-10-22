import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../constants/t_jev_http.dart';
import '../models/t_jev_validation_detail.dart';
import '../utils/retry_after.dart';

part 't_jev_aborted_failure.dart';
part 't_jev_authentication_failure.dart';
part 't_jev_bad_request_failure.dart';
part 't_jev_connection_failure.dart';
part 't_jev_http_failure.dart';
part 't_jev_internal_server_failure.dart';
part 't_jev_not_found_failure.dart';
part 't_jev_other_status_failure.dart';
part 't_jev_permission_denied_failure.dart';
part 't_jev_rate_limit_failure.dart';
part 't_jev_response_validation_failure.dart';
part 't_jev_timeout_failure.dart';
part 't_jev_unprocessable_entity_failure.dart';

/// Why a call to Jev failed in normal use.
///
/// [TJev] returns it as the error of a `TurboResponse` fail, so callers
/// switch on its type instead of catching exceptions.
sealed class TJevFailure {
  const TJevFailure();
}

/// The status, request id, headers and body of [response], the fields every
/// failure of a response holds.
///
/// The body is decoded JSON, else its text, or `null` when empty.
({int status, String? requestId, Map<String, String> headers, Object? body})
_responseFieldsOf(http.Response response) {
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
