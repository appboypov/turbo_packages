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
import '../results/t_jev_failure.dart';
import 'redacted_headers.dart';

/// Follows one Request from its first attempt to its end and logs it to the
/// [TJevLogging.loggerName] logger: each attempt and response at debug and
/// one [TJevRequestSummary] at info when it ends.
///
/// It skips records below its [TJevLogLevel] and builds a record only when
/// the logger takes it.
final class TJevRequestTrace {
  TJevRequestTrace({
    required TJevLogLevel level,
    required String method,
    required String path,
    required List<int>? body,
  }) : _level = level,
       _method = method,
       _path = path,
       _body = body;

  // 🧩 DEPENDENCIES

  static final _logger = Logger(TJevLogging.loggerName);

  final TJevLogLevel _level;
  final String _method;
  final String _path;

  /// The body before compression.
  final List<int>? _body;

  // 🎩 STATE

  final _elapsed = clock.stopwatch()..start();
  var _attempts = 0;
  var _timeouts = 0;
  int? _status;
  String? _requestId;

  // 🪄 MUTATORS

  /// Counts the attempt that sends [request] and logs it at debug.
  void sent(http.BaseRequest request) {
    final attempt = ++_attempts;
    _log(TJevLogLevel.debug, () {
      final (:body, :omittedBytes) = _cut(_body);
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
      final (:body, :omittedBytes) = _cut(response.bodyBytes);
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

  // 🏗️ HELPERS

  /// Logs the record [build] makes at [level], unless the trace or the
  /// logger skips [level].
  void _log(TJevLogLevel level, Object Function() build) {
    if (level.level < _level.level) return;
    _logger.log(level.level, build);
  }

  /// [bytes] as text cut at [TJevLogging.maxLoggedBodyBytes] bytes, with the
  /// number of bytes it leaves out.
  static ({String? body, int omittedBytes}) _cut(List<int>? bytes) {
    if (bytes == null || bytes.isEmpty) return (body: null, omittedBytes: 0);
    const maxBytes = TJevLogging.maxLoggedBodyBytes;
    return (
      body: utf8.decode(
        bytes.length > maxBytes ? bytes.sublist(0, maxBytes) : bytes,
        allowMalformed: true,
      ),
      omittedBytes: max(bytes.length - maxBytes, 0),
    );
  }
}
