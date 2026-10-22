import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:turbo_response/turbo_response.dart';

import '../config/t_jev_config.dart';
import '../constants/t_jev_http.dart';
import '../results/t_jev_failure.dart';

/// Sends Requests to TypeSafe and turns each outcome into a `TurboResponse`:
/// a 2xx response into a success, any other into a [TJevHttpFailure], a
/// connection error into a [TJevConnectionFailure] and an attempt that runs
/// out of time into a [TJevTimeoutFailure].
final class TJevApi {
  const TJevApi({required TJevConfig config, required http.Client httpClient})
    : _config = config,
      _httpClient = httpClient;

  // 🧩 DEPENDENCIES

  final TJevConfig _config;
  final http.Client _httpClient;

  // 🪄 MUTATORS

  /// Sends [json] to [path] and parses a 2xx response with [onSuccess].
  ///
  /// The whole response must arrive within [timeout]; the Request is
  /// aborted when it does not.
  Future<TurboResponse<T>> send<T>({
    required String method,
    required String path,
    required Object json,
    required Duration timeout,
    required T Function(http.Response response) onSuccess,
  }) async {
    final abort = Completer<void>();
    final request =
        http.AbortableRequest(
            method,
            Uri.parse('${_config.baseUrl}$path'),
            abortTrigger: abort.future,
          )
          ..headers.addAll({
            'Authorization': 'Bearer ${_config.apiKey}',
            'Accept': TJevHttp.jsonMediaType,
            'Content-Type': TJevHttp.jsonMediaType,
          })
          ..bodyBytes = utf8.encode(jsonEncode(json));
    final http.Response? response;
    try {
      response = await _receive(request).timeout(
        timeout,
        onTimeout: () {
          abort.complete();
          return null;
        },
      );
    } on http.ClientException catch (error) {
      return TurboResponse.fail(
        error: TJevConnectionFailure(
          message: 'Connection error: ${error.message}',
        ),
      );
    }
    if (response == null) {
      return TurboResponse.fail(error: TJevTimeoutFailure(timeout: timeout));
    }
    return _toTurboResponse(response, onSuccess);
  }

  // 🏗️ HELPERS

  /// Sends [request] and reads its whole response.
  Future<http.Response?> _receive(http.BaseRequest request) async =>
      http.Response.fromStream(await _httpClient.send(request));

  TurboResponse<T> _toTurboResponse<T>(
    http.Response response,
    T Function(http.Response response) onSuccess,
  ) {
    final status = response.statusCode;
    if (status >= 200 && status < 300) {
      return TurboResponse.success(result: onSuccess(response));
    }
    return TurboResponse.fail(error: TJevHttpFailure.fromResponse(response));
  }
}
