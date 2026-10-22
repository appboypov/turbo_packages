import '../enums/t_jev_log_level.dart';
import '../types/t_jev_model.dart';

/// Values [TJev] uses when neither config nor environment sets them.
abstract final class TJevDefaults {
  /// The base URL of TypeSafe.
  static const baseUrl = 'https://api.typesafe.ai';

  /// The model a Request uses when it names none.
  static const model = TJevModel.jevLatest;

  /// How long one attempt of a Request may take, its whole response
  /// included.
  static const timeout = Duration(seconds: 10);

  /// How much the client logs.
  static const logLevel = TJevLogLevel.warning;

  /// How many times a failed Request is sent again.
  static const maxRetries = 2;

  /// The backoff before the first retry.
  static const initialBackoff = Duration(milliseconds: 500);

  /// The factor each next retry multiplies the backoff by.
  static const backoffMultiplier = 2;

  /// The longest backoff, before jitter.
  static const maxBackoff = Duration(seconds: 5);

  /// The fraction of each backoff that is randomly taken off.
  static const jitter = 0.25;

  /// The HTTP statuses that are retried: 408, 429 and 500 to 599.
  static final retryStatuses = Set<int>.unmodifiable({
    408,
    429,
    for (var status = 500; status < 600; status++) status,
  });

  /// Whether a delay TypeSafe asks for replaces the backoff.
  static const respectRetryAfter = true;

  /// The longest delay TypeSafe may ask for.
  static const maxRetryAfter = Duration(seconds: 60);

  /// Whether a connection failure is retried.
  static const retryConnectionFailures = true;

  /// Whether a timeout is retried.
  static const retryTimeouts = true;

  /// The total time of a Request, its attempts and waits included, that no
  /// retry starts past.
  static const retryBudget = Duration(seconds: 30);
}
