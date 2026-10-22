import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:turbo_response/turbo_response.dart';

import '../config/t_jev_config.dart';
import '../constants/t_jev_http.dart';
import '../results/t_jev_failure.dart';

/// Sends Requests to TypeSafe and turns each HTTP response into a
/// `TurboResponse`: a 2xx response into a success, any other into a
/// [TJevHttpFailure].
final class TJevApi {
  const TJevApi({required TJevConfig config, required http.Client httpClient})
    : _config = config,
      _httpClient = httpClient;

  // 🧩 DEPENDENCIES

  final TJevConfig _config;
  final http.Client _httpClient;

  // 🪄 MUTATORS

  /// Sends [json] to [path] and parses a 2xx response with [onSuccess].
  Future<TurboResponse<T>> send<T>({
    required String method,
    required String path,
    required Object json,
    required T Function(http.Response response) onSuccess,
  }) async {
    final request = http.Request(method, Uri.parse('${_config.baseUrl}$path'))
      ..headers.addAll({
        'Authorization': 'Bearer ${_config.apiKey}',
        'Accept': TJevHttp.jsonMediaType,
        'Content-Type': TJevHttp.jsonMediaType,
      })
      ..bodyBytes = utf8.encode(jsonEncode(json));
    final response = await http.Response.fromStream(
      await _httpClient.send(request),
    );
    return _toTurboResponse(response, onSuccess);
  }

  // 🏗️ HELPERS

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
