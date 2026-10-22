import 't_jev_http.dart';

/// How [TJev] logs and what it keeps out of its logs.
abstract final class TJevLogging {
  // 🧲 FETCHERS

  /// The name of the `package:logging` logger the client logs to.
  static const loggerName = 'turbo_jev';

  /// The most bytes of a body a debug record holds.
  static const maxLoggedBodyBytes = 4096;

  /// The value logged in place of a secret header or body field value.
  static const redactedValue = '***';

  /// The lowercase names of the headers whose values are secret.
  static final secretHeaders = Set<String>.unmodifiable({
    TJevHttp.authorizationHeader.toLowerCase(),
    'proxy-authorization',
    'cookie',
    'set-cookie',
  });

  /// The lowercase parts that make a header name secret wherever they occur
  /// in it.
  static const secretHeaderNameParts = ['token', 'secret', 'api-key'];

  /// The lowercase parts that make a JSON body field name secret wherever
  /// they occur in it: the [secretHeaderNameParts] and the other spellings
  /// of a password and an API key.
  static const secretBodyFieldNameParts = [
    ...secretHeaderNameParts,
    'password',
    'api_key',
    'apikey',
  ];
}
