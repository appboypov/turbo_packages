import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:turbo_response/turbo_response.dart';

import '../constants/t_jev_logging.dart';
import '../enums/t_jev_log_level.dart';
import '../models/t_jev_request_log.dart';
import '../models/t_jev_request_summary.dart';
import '../models/t_jev_response_log.dart';
import '../records/t_jev_request_content.dart';
import '../results/t_jev_failure.dart';
import '../utils/t_jev_redacted_headers.dart';
import '../utils/t_jev_redacted_json_body.dart';

/// Logs Requests to its [Logger]: each attempt and response at debug and one
/// [TJevRequestSummary] at info when a Request ends.
///
/// It skips records below its [TJevLogLevel] and builds a record only when
/// the logger takes it.
final class TJevRequestTraceService {
  const TJevRequestTraceService({
    required Logger logger,
    required TJevLogLevel level,
    required bool redactBodies,
  }) : _logger = logger,
       _level = level,
       _redactBodies = redactBodies;

  // 🧩 DEPENDENCIES

  final Logger _logger;
  final TJevLogLevel _level;

  /// Whether a logged body has the values of the secret fields in its JSON
  /// replaced.
  final bool _redactBodies;

  // 🏗️ HELPERS

  /// Logs the record [build] makes at [level], unless the service or the
  /// logger skips [level].
  void _log(TJevLogLevel level, Object Function() build) {
    if (level.level < _level.level) return;
    _logger.log(level.level, build);
  }

  /// [bytes] as text cut at [TJevLogging.maxLoggedBodyBytes] bytes, with the
  /// number of bytes it leaves out. With body redaction on, the values of
  /// secret fields in the JSON at bytes [jsonStart] up to [jsonEnd] are
  /// replaced before the cut.
  ({String? body, int omittedBytes}) _loggedBodyOf(
    List<int>? bytes, {
    int jsonStart = 0,
    int? jsonEnd,
  }) {
    if (bytes == null || bytes.isEmpty) return (body: null, omittedBytes: 0);
    final logged = _redactBodies
        ? redactedJsonBody(bytes, start: jsonStart, end: jsonEnd)
        : bytes;
    const maxBytes = TJevLogging.maxLoggedBodyBytes;
    return (
      body: utf8.decode(
        logged.length > maxBytes ? logged.sublist(0, maxBytes) : logged,
        allowMalformed: true,
      ),
      omittedBytes: max(logged.length - maxBytes, 0),
    );
  }

  // 🪄 MUTATORS

  /// Logs [request], attempt number [attempt] of the [method] Request to
  /// [path] with body [content], at debug.
  void sent(
    http.BaseRequest request, {
    required String method,
    required String path,
    required TJevRequestContent? content,
    required int attempt,
  }) => _log(TJevLogLevel.debug, () {
    final (:body, :omittedBytes) = _loggedBodyOf(
      content?.bytes,
      jsonStart: content?.jsonStart ?? 0,
      jsonEnd: content?.jsonEnd,
    );
    return TJevRequestLog(
      method: method,
      path: path,
      attempt: attempt,
      headers: redactedHeaders(request.headers),
      body: body,
      omittedBodyBytes: omittedBytes,
    );
  });

  /// Logs [response] to the [method] Request to [path] at debug.
  void received(
    http.Response response, {
    required String method,
    required String path,
  }) => _log(TJevLogLevel.debug, () {
    final (:body, :omittedBytes) = _loggedBodyOf(response.bodyBytes);
    return TJevResponseLog(
      method: method,
      path: path,
      status: response.statusCode,
      headers: redactedHeaders(response.headers),
      body: body,
      omittedBodyBytes: omittedBytes,
    );
  });

  /// Logs the summary of the [method] Request to [path] that ends with
  /// [response] at info and returns [response].
  ///
  /// [status] and [requestId] come from the last response the Request
  /// received, if any; [retries] and [timeouts] count its attempts and
  /// [elapsed] is the time since its first attempt.
  TurboResponse<T> ended<T>(
    TurboResponse<T> response, {
    required String method,
    required String path,
    required int? status,
    required String? requestId,
    required int retries,
    required int timeouts,
    required Duration elapsed,
  }) {
    _log(
      TJevLogLevel.info,
      () => TJevRequestSummary(
        method: method,
        path: path,
        status: status,
        requestId: requestId,
        retries: retries,
        timeouts: timeouts,
        aborted: response.error is TJevAbortedFailure,
        elapsed: elapsed,
      ),
    );
    return response;
  }
}
