import 'package:logging/logging.dart';

/// How much a [TJev] client logs, from most to least: each level logs its
/// own records and those of the levels after it.
enum TJevLogLevel {
  /// Also the headers and bodies of each attempt, logged at [Level.FINE].
  debug(Level.FINE),

  /// Also one summary per Request, logged at [Level.INFO].
  info(Level.INFO),

  /// Also one warning per Retry, logged at [Level.WARNING].
  warning(Level.WARNING),

  /// Only one error per Request that ends in a failure other than an abort,
  /// logged at [Level.SEVERE].
  error(Level.SEVERE),

  /// Nothing.
  off(Level.OFF);

  const TJevLogLevel(this.level);

  /// The lowest `package:logging` level this level logs.
  final Level level;

  /// The level named [name], case-insensitive, with `warn` for [warning], or
  /// `null` when no level has that name.
  static TJevLogLevel? tryParse(String name) => switch (name.toLowerCase()) {
    'debug' => debug,
    'info' => info,
    'warn' || 'warning' => warning,
    'error' => error,
    'off' => off,
    _ => null,
  };
}
