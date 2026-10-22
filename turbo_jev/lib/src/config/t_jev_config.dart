import 'package:meta/meta.dart';

import '../abstracts/t_jev_exception.dart';
import '../constants/t_jev_defaults.dart';
import '../constants/t_jev_environment_keys.dart';
import '../constants/t_jev_messages.dart';
import '../enums/t_jev_log_level.dart';
import '../types/t_jev_model.dart';
import 't_jev_retry_policy.dart';

/// The resolved config of a [TJev] client.
///
/// Each value comes from config first and from the environment second. A
/// blank environment value counts as unset.
final class TJevConfig {
  const TJevConfig._({
    required this.apiKey,
    required this.baseUrl,
    required this.defaultModel,
    required this.timeout,
    required this.defaultHeaders,
    required this.retry,
    required this.logLevel,
    required this.redactLoggedBodies,
  });

  /// Resolves the config and checks its API key and timeout.
  ///
  /// An explicit empty [apiKey] does not fall back to the environment. An
  /// environment log level that names no [TJevLogLevel] counts as unset.
  ///
  /// Throws [TJevApiKeyException] when no key is found or the key is not
  /// printable ASCII without spaces, and [TJevInvalidTimeoutException] when
  /// [timeout] is not positive.
  factory TJevConfig.resolve({
    required String? apiKey,
    required String? baseUrl,
    required TJevModel? defaultModel,
    required Duration? timeout,
    required Map<String, String> defaultHeaders,
    required TJevRetryPolicy? retry,
    required TJevLogLevel? logLevel,
    required bool redactLoggedBodies,
    required Map<String, String> environment,
  }) {
    final environmentModel = _environmentValue(
      environment,
      TJevEnvironmentKeys.defaultModel,
    );
    final environmentLogLevel = _environmentValue(
      environment,
      TJevEnvironmentKeys.logLevel,
    );
    return TJevConfig._(
      apiKey: _checkedApiKey(
        apiKey ?? _environmentValue(environment, TJevEnvironmentKeys.apiKey),
      ),
      baseUrl:
          (baseUrl ??
                  _environmentValue(environment, TJevEnvironmentKeys.baseUrl) ??
                  TJevDefaults.baseUrl)
              .replaceFirst(_trailingSlashes, ''),
      defaultModel:
          defaultModel ??
          (environmentModel == null
              ? TJevDefaults.model
              : TJevModel(environmentModel)),
      timeout: checkedTimeout(timeout ?? TJevDefaults.timeout),
      defaultHeaders: Map.unmodifiable(defaultHeaders),
      retry: retry ?? TJevRetryPolicy(),
      logLevel:
          logLevel ??
          (environmentLogLevel == null
              ? null
              : TJevLogLevel.tryParse(environmentLogLevel)) ??
          TJevDefaults.logLevel,
      redactLoggedBodies: redactLoggedBodies,
    );
  }

  // 🎩 STATE

  /// The API key sent as bearer auth.
  final String apiKey;

  /// The base URL without trailing slashes.
  final String baseUrl;

  /// The model a Request uses when it names none.
  final TJevModel defaultModel;

  /// How long one attempt of a Request may take, its whole response
  /// included.
  final Duration timeout;

  /// The headers every Request sends before its own headers.
  final Map<String, String> defaultHeaders;

  /// When a failed Request is sent again, unless a Request sets its own policy.
  final TJevRetryPolicy retry;

  /// How much the client logs.
  final TJevLogLevel logLevel;

  /// Whether the JSON of a body logged at debug, also the `request` part of
  /// a multipart Request, has the values of its secret fields replaced in
  /// full.
  final bool redactLoggedBodies;

  // 🧲 FETCHERS

  /// Returns [timeout] when it is positive.
  ///
  /// Throws [TJevInvalidTimeoutException] when it is zero or negative.
  @internal
  static Duration checkedTimeout(Duration timeout) {
    if (timeout <= Duration.zero) {
      throw TJevInvalidTimeoutException(
        message: TJevMessages.invalidTimeout(timeout),
        timeout: timeout,
      );
    }
    return timeout;
  }

  // 🏗️ HELPERS

  static final _trailingSlashes = RegExp(r'/+$');
  static final _printableAsciiWithoutSpaces = RegExp(r'^[\x21-\x7E]+$');

  static String _checkedApiKey(String? apiKey) {
    final key = apiKey?.trim() ?? '';
    if (key.isEmpty) {
      throw const TJevApiKeyException(message: TJevMessages.missingApiKey);
    }
    if (!_printableAsciiWithoutSpaces.hasMatch(key)) {
      throw const TJevApiKeyException(message: TJevMessages.invalidApiKey);
    }
    return key;
  }

  /// Returns the trimmed value of [key] in [environment], or null when it is
  /// unset or blank.
  static String? _environmentValue(
    Map<String, String> environment,
    String key,
  ) {
    final value = environment[key]?.trim();
    return value == null || value.isEmpty ? null : value;
  }
}
