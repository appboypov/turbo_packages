/// Limits on Questions, retry policies and failure messages.
abstract final class TJevLimits {
  /// The most Options a Choice can have.
  static const maxOptions = 255;

  /// The most Levels a Score can have.
  static const maxLevels = 10;

  /// The lowest HTTP status a retry policy accepts.
  static const minHttpStatus = 100;

  /// The highest HTTP status a retry policy accepts.
  static const maxHttpStatus = 999;

  /// The lowest jitter of a retry policy.
  static const minJitter = 0;

  /// The highest jitter of a retry policy.
  static const maxJitter = 1;

  /// The longest raw body, in characters, that the message of a
  /// `TJevHttpFailure` holds uncut.
  static const maxRawBodyLength = 200;
}
