import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:clock/clock.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_response/turbo_response.dart';

import '../config/t_jev_config.dart';
import '../config/t_jev_retry_policy.dart';
import '../constants/t_jev_http.dart';
import '../results/t_jev_failure.dart';
import '../utils/request_platform.dart';

/// Sends Requests to TypeSafe and turns each outcome into a `TurboResponse`:
/// a 2xx response into a success, or into a [TJevResponseValidationFailure]
/// when its body does not parse, any other into a [TJevHttpFailure], a
/// connection error into a [TJevConnectionFailure], an attempt that runs
/// out of time into a [TJevTimeoutFailure] and an aborted call into a
/// [TJevAbortedFailure].
final class TJevApi {
  const TJevApi({required TJevConfig config, required http.Client httpClient})
    : _config = config,
      _httpClient = httpClient;

  // 🧩 DEPENDENCIES

  final TJevConfig _config;
  final http.Client _httpClient;

  // 🪄 MUTATORS

  /// Sends [json], if any, to [path] and parses a 2xx response with
  /// [onSuccess], which throws a [FormatException] or a
  /// [CheckedFromJsonException] when the body does not fit.
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
  /// call ends with a [TJevAbortedFailure].
  Future<TurboResponse<T>> send<T>({
    required String method,
    required String path,
    Object? json,
    required Map<String, String> headers,
    required Duration timeout,
    required TJevRetryPolicy retry,
    Future<void>? abortTrigger,
    required T Function(http.Response response) onSuccess,
  }) async {
    final body = json == null
        ? null
        : encodeBody(utf8.encode(jsonEncode(json)));
    final sdkHeaders = {
      TJevHttp.authorizationHeader: 'Bearer ${_config.apiKey}',
      TJevHttp.acceptHeader: TJevHttp.jsonMediaType,
      if (body != null) TJevHttp.contentTypeHeader: TJevHttp.jsonMediaType,
      if (body?.encoding case final encoding?)
        TJevHttp.contentEncodingHeader: encoding,
      ...platformHeaders,
    };
    final aborted = Completer<void>();
    abortTrigger?.whenComplete(() {
      if (!aborted.isCompleted) aborted.complete();
    }).ignore();
    final elapsed = clock.stopwatch()..start();
    for (var attempt = 0; ; attempt++) {
      final abortAttempt = Completer<void>();
      final request =
          http.AbortableRequest(
              method,
              Uri.parse('${_config.baseUrl}$path'),
              abortTrigger: abortAttempt.future,
            )
            ..headers.addEntries(
              _config.defaultHeaders.entries.where(_isUnprotected),
            )
            ..headers.addEntries(headers.entries.where(_isUnprotected))
            ..headers.addAll({
              ...sdkHeaders,
              if (attempt > 0) ...retryHeaders(attempt),
            });
      if (body != null) request.bodyBytes = body.bytes;
      final response = await _attempt(
        request,
        abortAttempt: abortAttempt,
        timeout: timeout,
        aborted: aborted,
        onSuccess: onSuccess,
      );
      if (response case Fail(
        error: final TJevFailure failure,
      ) when attempt < retry.maxRetries && retry.retries(failure)) {
        final delay = retry.delayAfter(
          attempt: attempt,
          failure: failure,
          random: _random,
        );
        if (retry.budget case final budget?
            when elapsed.elapsed + delay >= budget) {
          return response;
        }
        if (await _waitUnlessAborted(delay, aborted)) {
          return TurboResponse.fail(error: const TJevAbortedFailure());
        }
        continue;
      }
      return response;
    }
  }

  // 🏗️ HELPERS

  static final _random = Random();

  /// Sends [request] once and reads its whole response within [timeout].
  ///
  /// When [timeout] passes or [aborted] completes first, it completes
  /// [abortAttempt] to abort [request].
  Future<TurboResponse<T>> _attempt<T>(
    http.BaseRequest request, {
    required Completer<void> abortAttempt,
    required Duration timeout,
    required Completer<void> aborted,
    required T Function(http.Response response) onSuccess,
  }) async {
    final timedOut = Completer<void>();
    final timer = Timer(timeout, timedOut.complete);
    try {
      final response = await Future.any([
        _receive(request),
        timedOut.future.then((_) => null),
        aborted.future.then((_) => null),
      ]);
      if (response != null) return _toTurboResponse(response, onSuccess);
      abortAttempt.complete();
      return TurboResponse.fail(
        error: aborted.isCompleted
            ? const TJevAbortedFailure()
            : TJevTimeoutFailure(timeout: timeout),
      );
    } on http.ClientException catch (error) {
      return TurboResponse.fail(
        error: aborted.isCompleted
            ? const TJevAbortedFailure()
            : TJevConnectionFailure(
                message: 'Connection error: ${error.message}',
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
    T Function(http.Response response) onSuccess,
  ) {
    final status = response.statusCode;
    if (status >= 200 && status < 300) {
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
            reason: '${error.key}: ${error.message}',
          ),
        );
      }
    }
    return TurboResponse.fail(error: TJevHttpFailure.fromResponse(response));
  }

  static bool _isUnprotected(MapEntry<String, String> header) =>
      !TJevHttp.protectedHeaders.contains(header.key.toLowerCase());
}
