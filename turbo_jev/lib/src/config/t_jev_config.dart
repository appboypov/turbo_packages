import 'package:meta/meta.dart';

import '../constants/t_jev_defaults.dart';
import '../constants/t_jev_environment_keys.dart';
import '../exceptions/t_jev_api_key_exception.dart';
import '../exceptions/t_jev_invalid_timeout_exception.dart';
import '../models/t_jev_model.dart';

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
  });

  /// Resolves the config and checks its API key and timeout.
  ///
  /// An explicit empty [apiKey] does not fall back to the environment.
  ///
  /// Throws [TJevApiKeyException] when no key is found or the key is not
  /// printable ASCII without spaces, and [TJevInvalidTimeoutException] when
  /// [timeout] is not positive.
  factory TJevConfig.resolve({
    required String? apiKey,
    required String? baseUrl,
    required TJevModel? defaultModel,
    required Duration? timeout,
    required Map<String, String> environment,
  }) {
    String? fromEnvironment(String key) {
      final value = environment[key]?.trim();
      return value == null || value.isEmpty ? null : value;
    }

    final environmentModel = fromEnvironment(TJevEnvironmentKeys.defaultModel);
    return TJevConfig._(
      apiKey: _checkedApiKey(
        apiKey ?? fromEnvironment(TJevEnvironmentKeys.apiKey),
      ),
      baseUrl:
          (baseUrl ??
                  fromEnvironment(TJevEnvironmentKeys.baseUrl) ??
                  TJevDefaults.baseUrl)
              .replaceFirst(_trailingSlashes, ''),
      defaultModel:
          defaultModel ??
          (environmentModel == null
              ? TJevDefaults.model
              : TJevModel(environmentModel)),
      timeout: checkedTimeout(timeout ?? TJevDefaults.timeout),
    );
  }

  static final _trailingSlashes = RegExp(r'/+$');
  static final _printableAsciiWithoutSpaces = RegExp(r'^[\x21-\x7E]+$');

  /// The API key sent as bearer auth.
  final String apiKey;

  /// The base URL without trailing slashes.
  final String baseUrl;

  /// The model a Request uses when it names none.
  final TJevModel defaultModel;

  /// How long one attempt of a Request may take, its whole response
  /// included.
  final Duration timeout;

  /// Returns [timeout] when it is positive.
  ///
  /// Throws [TJevInvalidTimeoutException] when it is zero or negative.
  @internal
  static Duration checkedTimeout(Duration timeout) {
    if (timeout <= Duration.zero) {
      throw TJevInvalidTimeoutException(timeout: timeout);
    }
    return timeout;
  }

  static String _checkedApiKey(String? apiKey) {
    final key = apiKey?.trim() ?? '';
    if (key.isEmpty) {
      throw const TJevApiKeyException(
        reason:
            'No API key was provided. Pass apiKey or set the '
            '${TJevEnvironmentKeys.apiKey} environment variable.',
      );
    }
    if (!_printableAsciiWithoutSpaces.hasMatch(key)) {
      throw const TJevApiKeyException(
        reason: 'The API key must hold only printable ASCII without spaces.',
      );
    }
    return key;
  }
}
