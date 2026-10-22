/// Names of the environment variables [TJev] reads its config from.
abstract final class TJevEnvironmentKeys {
  /// The API key.
  static const apiKey = 'TYPESAFE_API_KEY';

  /// The base URL of TypeSafe or of a proxy in front of it.
  static const baseUrl = 'TYPESAFE_BASE_URL';

  /// The model a Request uses when it names none.
  static const defaultModel = 'TYPESAFE_DEFAULT_MODEL';

  /// How much the client logs: `debug`, `info`, `warn`, `warning`, `error`
  /// or `off`.
  static const logLevel = 'TYPESAFE_LOG_LEVEL';
}
