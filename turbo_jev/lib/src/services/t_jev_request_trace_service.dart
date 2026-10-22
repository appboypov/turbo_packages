import 'dart:convert';
import 'dart:math';

import 'package:clock/clock.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:turbo_response/turbo_response.dart';

import '../constants/t_jev_http.dart';
import '../constants/t_jev_logging.dart';
import '../enums/t_jev_log_level.dart';
import '../models/t_jev_request_log.dart';
import '../models/t_jev_request_summary.dart';
import '../models/t_jev_response_log.dart';
import '../records/t_jev_request_content.dart';
import '../results/t_jev_failure.dart';
import '../utils/t_jev_redacted_headers.dart';
import '../utils/t_jev_redacted_json_body.dart';

/// Follows one Request from its first attempt to its end and logs it to the
/// [TJevLogging.loggerName] logger: each attempt and response at debug and
/// one [TJevRequestSummary] at info when it ends.
///
/// It skips records below its [TJevLogLevel] and builds a record only when
/// the logger takes it.
final class TJevRequestTraceService {
  TJevRequestTraceService({
    required TJevLogLevel level,
    required bool redactBodies,
    required String method,
    required String path,
    required TJevRequestContent? content,
  }) : _level = level,
       _redactBodies = redactBodies,
       _method = method,
       _path = path,
       _content = content;

  // 🎩 STATE

  final TJevLogLevel _level;

  /// Whether a logged body has the values of the secret fields in its JSON
  /// replaced.
  final bool _redactBodies;
  final String _method;
  final String _path;

  /// The content of the Request body, if any.
  final TJevRequestContent? _content;

  final _elapsed = clock.stopwatch()..start();
  var _attempts = 0;
  var _timeouts = 0;
  int? _status;
  String? _requestId;

  // 🛠 UTIL

  static final _logger = Logger(TJevLogging.loggerName);

  // 🏗️ HELPERS

  /// Logs the record [build] makes at [level], unless the trace or the
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

  /// Counts the attempt that sends [request] and logs it at debug.
  void sent(http.BaseRequest request) {
    final attempt = ++_attempts;
    _log(TJevLogLevel.debug, () {
      final (:body, :omittedBytes) = _loggedBodyOf(
        _content?.bytes,
        jsonStart: _content?.jsonStart ?? 0,
        jsonEnd: _content?.jsonEnd,
      );
      return TJevRequestLog(
        method: _method,
        path: _path,
        attempt: attempt,
        headers: redactedHeaders(request.headers),
        body: body,
        omittedBodyBytes: omittedBytes,
      );
    });
  }

  /// Keeps the status and request id of [response] and logs it at debug.
  void received(http.Response response) {
    _status = response.statusCode;
    _requestId = response.headers[TJevHttp.requestIdHeader];
    _log(TJevLogLevel.debug, () {
      final (:body, :omittedBytes) = _loggedBodyOf(response.bodyBytes);
      return TJevResponseLog(
        method: _method,
        path: _path,
        status: response.statusCode,
        headers: redactedHeaders(response.headers),
        body: body,
        omittedBodyBytes: omittedBytes,
      );
    });
  }

  /// Counts an attempt that ran out of time.
  void timedOut() => _timeouts++;

  /// Logs the summary of the Request that ends with [response] at info and
  /// returns [response].
  TurboResponse<T> ended<T>(TurboResponse<T> response) {
    _log(
      TJevLogLevel.info,
      () => TJevRequestSummary(
        method: _method,
        path: _path,
        status: _status,
        requestId: _requestId,
        retries: max(_attempts - 1, 0),
        timeouts: _timeouts,
        aborted: response.error is TJevAbortedFailure,
        elapsed: _elapsed.elapsed,
      ),
    );
    return response;
  }
}
