part of '../turbolytics/turbolytics.dart';

/// Pure logger class to facilitate logging.
class TLog {
  TLog({
    String? location,
    String? tag,
    int? maxLinesStackTrace,
  }) : _tag = tag,
       _location = location ?? 'Log',
       _maxLinesStackTrace = maxLinesStackTrace;

  /// Used to indicate the tag of the log, can also be specified per method.
  final String? _tag;

  /// Used to toggle logging of time on or off.
  static bool logTime = false;

  /// Used to set the log level of the [Turbolytics].
  static TLogLevel level = TLogLevel.info;

  /// Used to indicate the current location of the log.
  final String _location;

  /// Used to determine the max lines of the stack trace.
  final int? _maxLinesStackTrace;

  /// Used to properly handle chronological processing of events.
  late final TAnalyticsEventBus _eventBus = TAnalyticsEventBus();

  /// Used to toggle broadcasting logs on or off.
  static bool broadcastLogs = false;

  /// Receives each [TLogLine] that a [TLog] writes. The process sets it once at its start, such
  /// as to write lines to a file. It is [printLine] when nothing is set.
  static void Function(TLogLine line) output = printLine;

  /// Prints [line] as text to standard output, after its time when [logTime] is true.
  static void printLine(TLogLine line) =>
      // Standard output is the default sink of a log line.
      // ignore: avoid_print
      print('${logTime ? '${timeOf(line.time)} ' : ''}$line');

  /// Used to expose all crash reports logs.
  static final StreamController<String> crashReportsObserver =
      StreamController.broadcast();

  /// Used to expose all analytics logs.
  static final StreamController<String> analyticsObserver =
      StreamController.broadcast();

  // --------------- REGULAR --------------- REGULAR --------------- REGULAR --------------- \\

  /// Logs a trace [message] with [TLogLevel.trace] to [TLog.output].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Turbolytics.setUp] method.
  void trace(
    String message, {
    bool addToCrashReports = true,
    String? location,
    String? tag,
  }) {
    const logLevel = TLogLevel.trace;
    if (level.skipLog(logLevel)) return;
    _logMessage(
      message: message,
      logLevel: logLevel,
      addToCrashReports: addToCrashReports,
      location: location,
      tag: tag,
    );
  }

  /// Logs a debug [message] with [TLogLevel.debug] to [TLog.output].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Turbolytics.setUp] method.
  void debug(
    String message, {
    bool addToCrashReports = true,
    String? location,
    String? tag,
  }) {
    if (level.skipLog(TLogLevel.debug)) return;
    _logMessage(
      message: message,
      logLevel: TLogLevel.debug,
      addToCrashReports: addToCrashReports,
      location: location,
      tag: tag,
    );
  }

  /// Logs an info [message] with [TLogLevel.info] to [TLog.output].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Turbolytics.setUp] method.
  void info(
    String message, {
    bool addToCrashReports = true,
    String? location,
    String? tag,
  }) {
    const logLevel = TLogLevel.info;
    if (level.skipLog(logLevel)) return;
    _logMessage(
      message: message,
      logLevel: logLevel,
      addToCrashReports: addToCrashReports,
      location: location,
      tag: tag,
    );
  }

  /// Logs an analytic [name] with [TLogLevel.analytic] to [TLog.output].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Turbolytics.setUp] method.
  void analytic({
    required String name,
    String? value,
    bool addToCrashReports = true,
    String? location,
    Map<String, Object?>? parameters,
    String? tag,
  }) {
    const logLevel = TLogLevel.analytic;
    if (level.skipLog(logLevel)) return;
    final message =
        '$name${value != null ? ': $value' : ''}'
        '${parameters != null ? ': $parameters' : ''}';
    _logMessage(
      message: message,
      logLevel: logLevel,
      addToCrashReports: addToCrashReports,
      location: location,
      tag: tag,
    );
    if (broadcastLogs) analyticsObserver.add(message);
  }

  /// Logs a warning [message] with [TLogLevel.warning] to [TLog.output], with the [error] and
  /// [stackTrace] of a failure that the program recovers from.
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Turbolytics.setUp] method. A warning records no error there.
  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool addToCrashReports = true,
    String? location,
    String? tag,
  }) {
    const logLevel = TLogLevel.warning;
    if (level.skipLog(logLevel)) return;
    _logMessage(
      message: message,
      logLevel: logLevel,
      addToCrashReports: addToCrashReports,
      location: location,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      stackLinesInText: _maxLinesStackTrace,
    );
  }

  /// Logs an error [message] with [TLogLevel.error] to [TLog.output], with its [error] and its
  /// stack trace when [printStack] is true.
  ///
  /// Also tries to send the log with optional [error], [stackTrace] and [fatal] boolean to your
  /// [CrashReportsInterface] implementation should you have configured one with the
  /// [Turbolytics.setUp] method.
  void error(
    String message, {
    String? location,
    Object? error,
    StackTrace? stackTrace,
    bool fatal = false,
    bool printStack = true,
    bool addToCrashReports = true,
    bool forceRecordError = false,
    String? tag,
  }) {
    final logLevel = fatal ? TLogLevel.fatal : TLogLevel.error;
    if (level.skipLog(logLevel)) return;
    StackTrace localStackTrace;
    try {
      localStackTrace =
          stackTrace ??
          StackTrace.fromString(
            StackTrace.current.toString().split('\n').sublist(1).join('\n'),
          );
    } catch (error) {
      localStackTrace = StackTrace.current;
    }
    _logMessage(
      message: message,
      logLevel: logLevel,
      addToCrashReports: addToCrashReports,
      location: location,
      tag: tag,
      error: error,
      stackTrace: localStackTrace,
      stackLinesInText: printStack ? _maxLinesStackTrace : 0,
    );
    if (error != null || forceRecordError) {
      _eventBus.tryAddCrashReport(
        Turbolytics._crashReportsInterface?.recordError(
          error,
          localStackTrace,
          fatal: fatal,
        ),
      );
    }
  }

  /// Logs a fatal [message] with [TLogLevel.fatal] to [TLog.output].
  ///
  /// Also tries to send the log with optional [error], [stackTrace] and [fatal] boolean to your
  /// [CrashReportsInterface] implementation should you have configured one with the
  /// [Turbolytics.setUp] method.
  void fatal(
    String message, {
    String? location,
    Object? error,
    StackTrace? stackTrace,
    bool printStack = true,
    bool addToCrashReports = true,
    bool forceRecordError = false,
    String? tag,
  }) => this.error(
    message,
    location: location,
    error: error,
    stackTrace: stackTrace,
    fatal: true,
    printStack: printStack,
    addToCrashReports: addToCrashReports,
    forceRecordError: forceRecordError,
    tag: tag,
  );

  // --------------- PRINTERS --------------- PRINTERS --------------- PRINTERS --------------- \\

  /// Used under the hood to log a [message] with [logLevel].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Turbolytics.setUp] method.
  void _logMessage({
    required String message,
    required TLogLevel logLevel,
    bool addToCrashReports = true,
    String? location,
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    int? stackLinesInText,
  }) {
    final localTag = tag ?? _tag;
    if (addToCrashReports) {
      _tryLogCrashReportMessage(message, logLevel, localTag);
    }
    final line = TLogLine(
      time: DateTime.now().toUtc(),
      level: logLevel,
      location: location ?? _location,
      message: message,
      tag: localTag,
      error: error,
      stackTrace: stackTrace,
      stackLinesInText: stackLinesInText,
    );
    if (broadcastLogs) {
      final time = TLog.logTime ? '${timeOf(line.time)} ' : '';
      crashReportsObserver.add('$time${line._prefix}$message');
      if (error != null) crashReportsObserver.add('$time${line._prefix}$error');
    }
    output(line);
  }

  // --------------- CRASH REPORTS --------------- CRASH REPORTS --------------- CRASH REPORTS --------------- \\

  /// Used under the hood to try and log a crashlytics [message] with [logLevel].
  void _tryLogCrashReportMessage(
    String message,
    TLogLevel logLevel,
    String? tag,
  ) => _eventBus.tryAddCrashReport(
    Turbolytics._crashReportsInterface?.log(
      '${Turbolytics._crashReportType.parseLogLevel(location: _location, logLevel: logLevel)} '
      '${tag != null ? '[$tag] ' : ''}'
      '$message',
    ),
  );
}
