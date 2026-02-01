/// All levels of logging.
///
/// Each level has its own unique prefix and icon.
enum TLogLevel {
  trace,
  debug,
  info,
  analytic,
  warning,
  error,
  fatal
  ;

  /// Decides whether to show the log based on the [index] of the [TLogLevel].
  bool skipLog(TLogLevel logLevel) => index > logLevel.index;
}
