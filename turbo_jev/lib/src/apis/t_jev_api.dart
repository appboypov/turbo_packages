import 'dart:async';
import 'dart:math';

import 'package:clock/clock.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_response/turbo_response.dart';

import '../config/t_jev_config.dart';
import '../config/t_jev_retry_policy.dart';
import '../constants/t_jev_http.dart';
import '../constants/t_jev_messages.dart';
import '../enums/t_jev_http_method.dart';
import '../models/t_jev_image.dart';
import '../results/t_jev_failure.dart';
import '../services/t_jev_request_content_service.dart';
import '../services/t_jev_request_platform_service.dart';
import '../services/t_jev_request_trace_service.dart';
import '../typedefs/t_jev_response_parser.dart';

/// Sends Requests to TypeSafe and turns each outcome into a `TurboResponse`:
/// a 2xx response into a success, or into a [TJevResponseValidationFailure]
/// when its body does not parse, any other into a [TJevHttpFailure], a
/// connection error into a [TJevConnectionFailure], an attempt that runs
/// out of time into a [TJevTimeoutFailure] and an aborted Request into a
/// [TJevAbortedFailure]. It logs each Request through its
/// [TJevRequestTraceService].
final class TJevApi {
  const TJevApi({
    required TJevConfig config,
    required http.Client httpClient,
    required TJevRequestTraceService trace,
    required Random random,
  }) : _config = config,
       _httpClient = httpClient,
       _trace = trace,
       _random = random;

  // 🧩 DEPENDENCIES

  final TJevConfig _config;
  final http.Client _httpClient;
  final TJevRequestTraceService _trace;

  /// The source of the jitter in retry delays.
  final Random _random;

  // 🛠 UTIL

  static const _contentService = TJevRequestContentService();
  static const _platformService = TJevRequestPlatformService();

  // 🏗️ HELPERS

  /// Sends [request] once and succeeds with its whole response when it
  /// arrives within [timeout].
  ///
  /// When [timeout] passes or [aborted] completes first, it completes
  /// [abortAttempt] to abort [request] and fails with a
  /// [TJevTimeoutFailure] or a [TJevAbortedFailure]. A connection error
  /// fails with a [TJevConnectionFailure], or a [TJevAbortedFailure] once
  /// [aborted] completed.
  Future<TurboResponse<http.Response>> _attempt(
    http.BaseRequest request, {
    required Completer<void> abortAttempt,
    required Duration timeout,
    required Completer<void> aborted,
  }) async {
    final timedOut = Completer<void>();
    final timer = Timer(timeout, timedOut.complete);
    try {
      final response = await Future.any([
        _receive(request),
        timedOut.future.then((_) => null),
        aborted.future.then((_) => null),
      ]);
      if (response != null) return TurboResponse.success(result: response);
      abortAttempt.complete();
      return TurboResponse.fail(
        error: aborted.isCompleted
            ? const TJevAbortedFailure()
            : TJevTimeoutFailure(timeout: timeout),
      );
    } on Exception catch (error) {
      final reason = switch (error) {
        http.ClientException(:final message) => message,
        _ when _platformService.isUnwrappedConnectionError(error) => '$error',
        _ => null,
      };
      if (reason == null) rethrow;
      return TurboResponse.fail(
        error: aborted.isCompleted
            ? const TJevAbortedFailure()
            : TJevConnectionFailure(
                message: TJevMessages.connectionError(reason),
              ),
      );
    } finally {
      timer.cancel();
    }
  }

  /// Waits [delay] and returns `false`, or returns `true` as soon as
  /// [aborted] completes.
  static Future<bool> _waitUnlessAborted(
    Duration delay,
    Completer<void> aborted,
  ) {
    final waited = Completer<void>();
    final timer = Timer(delay, waited.complete);
    return Future.any([
      waited.future.then((_) => false),
      aborted.future.then((_) => true),
    ]).whenComplete(timer.cancel);
  }

  /// Sends [request] and reads its whole response.
  Future<http.Response> _receive(http.BaseRequest request) async =>
      http.Response.fromStream(await _httpClient.send(request));

  TurboResponse<T> _toTurboResponse<T>(
    http.Response response,
    TJevResponseParser<T> onSuccess,
  ) {
    final status = response.statusCode;
    if (status >= TJevHttp.minSuccessStatus &&
        status <= TJevHttp.maxSuccessStatus) {
      try {
        return TurboResponse.success(result: onSuccess(response));
      } on FormatException catch (error) {
        return TurboResponse.fail(
          error: TJevResponseValidationFailure.fromResponse(
            response,
            reason: error.message,
          ),
        );
      } on CheckedFromJsonException catch (error) {
        return TurboResponse.fail(
          error: TJevResponseValidationFailure.fromResponse(
            response,
            reason: TJevMessages.fieldMessage(error.key, error.message),
          ),
        );
      }
    }
    return TurboResponse.fail(error: TJevHttpFailure.fromResponse(response));
  }

  static bool _isUnprotected(MapEntry<String, String> header) =>
      !TJevHttp.protectedHeaders.contains(header.key.toLowerCase());

  // 🪄 MUTATORS

  /// Sends the [json] text, if any, to [path] and parses a 2xx response with
  /// [onSuccess], which throws a [FormatException] or a
  /// [CheckedFromJsonException] when the body does not fit.
  ///
  /// With [images], the body is multipart: the [json] in its first part and
  /// each Image in a part of the name it has in [images].
  ///
  /// The Request sends the config's default headers first and [headers]
  /// second; names are case-insensitive and the last value wins. The SDK
  /// sets the [TJevHttp.protectedHeaders] last, so neither can change them.
  /// The body is encoded once, gzip compressed from
  /// [TJevHttp.minCompressedBodyBytes] bytes on where `dart:io` exists, and
  /// every attempt sends the same bytes.
  ///
  /// The whole response of each attempt must arrive within [timeout]; the
  /// attempt is aborted when it does not. A failure [retry] retries is sent
  /// again after its delay, each retry numbered in
  /// [TJevHttp.retryCountHeader] where `dart:io` exists. When
  /// [abortTrigger] completes, the running attempt or wait stops and the
  /// Request ends with a [TJevAbortedFailure].
  Future<TurboResponse<T>> send<T>({
    required TJevHttpMethod method,
    required String path,
    String? json,
    Map<String, TJevImage> images = const {},
    required Map<String, String> headers,
    required Duration timeout,
    required TJevRetryPolicy retry,
    Future<void>? abortTrigger,
    required TJevResponseParser<T> onSuccess,
  }) async {
    final content = json == null
        ? null
        : _contentService.build(json: json, images: images);
    final body = content == null
        ? null
        : _platformService.encodeBody(content.bytes);
    final sdkHeaders = {
      TJevHttp.authorizationHeader: '${TJevHttp.bearerPrefix}${_config.apiKey}',
      TJevHttp.acceptHeader: TJevHttp.jsonMediaType,
      if (content != null) TJevHttp.contentTypeHeader: content.contentType,
      if (body?.encoding case final encoding?)
        TJevHttp.contentEncodingHeader: encoding,
      ..._platformService.platformHeaders,
    };
    final aborted = Completer<void>();
    abortTrigger?.whenComplete(() {
      if (!aborted.isCompleted) aborted.complete();
    }).ignore();
    final elapsed = clock.stopwatch()..start();
    int? status;
    String? requestId;
    var timeouts = 0;
    TurboResponse<T> ended(TurboResponse<T> response, {required int retries}) =>
        _trace.ended(
          response,
          method: method.wireValue,
          path: path,
          status: status,
          requestId: requestId,
          retries: retries,
          timeouts: timeouts,
          elapsed: elapsed.elapsed,
        );
    for (var attempt = 0; ; attempt++) {
      final abortAttempt = Completer<void>();
      final request =
          http.AbortableRequest(
              method.wireValue,
              Uri.parse('${_config.baseUrl}$path'),
              abortTrigger: abortAttempt.future,
            )
            ..headers.addEntries(
              _config.defaultHeaders.entries.where(_isUnprotected),
            )
            ..headers.addEntries(headers.entries.where(_isUnprotected))
            ..headers.addAll({
              ...sdkHeaders,
              if (attempt > 0) ..._platformService.retryHeaders(attempt),
            });
      if (body != null) request.bodyBytes = body.bytes;
      _trace.sent(
        request,
        method: method.wireValue,
        path: path,
        content: content,
        attempt: attempt + 1,
      );
      final TurboResponse<T> response;
      switch (await _attempt(
        request,
        abortAttempt: abortAttempt,
        timeout: timeout,
        aborted: aborted,
      )) {
        case Success(result: final received):
          status = received.statusCode;
          requestId = received.headers[TJevHttp.requestIdHeader];
          _trace.received(received, method: method.wireValue, path: path);
          response = _toTurboResponse(received, onSuccess);
        case Fail(:final error):
          if (error is TJevTimeoutFailure) timeouts++;
          response = TurboResponse.fail(error: error);
      }
      if (response
          case Fail(
            error: final TJevFailure failure,
          )
          when attempt < retry.maxRetries && retry.retries(failure)) {
        final delay = retry.delayAfter(
          attempt: attempt,
          failure: failure,
          random: _random,
        );
        if (retry.budget case final budget?
            when elapsed.elapsed + delay >= budget) {
          return ended(response, retries: attempt);
        }
        if (await _waitUnlessAborted(delay, aborted)) {
          return ended(
            TurboResponse.fail(error: const TJevAbortedFailure()),
            retries: attempt,
          );
        }
        continue;
      }
      return ended(response, retries: attempt);
    }
  }
}
