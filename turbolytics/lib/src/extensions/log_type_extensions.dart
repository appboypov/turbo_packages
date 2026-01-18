import '../enums/t_log_level.dart';

/// Used to define a proper name per [TLogLevel] when icons are not preferred.
extension LogLevelExtensions on TLogLevel {
  String get tag {
    switch (this) {
      case TLogLevel.trace:
        return '[TRACE]';
      case TLogLevel.debug:
        return '[DEBUG]';
      case TLogLevel.info:
        return '[INFO]';
      case TLogLevel.analytic:
        return '[ANALYTIC]';
      case TLogLevel.warning:
        return '[WARNING]';
      case TLogLevel.error:
        return '[ERROR]';
      case TLogLevel.fatal:
        return '[FATAL]';
    }
  }

  /// Used to define a proper icon per [TLogLevel] when a name is not preferred.
  String get iconTag {
    switch (this) {
      case TLogLevel.trace:
        return '⏱️ $tag';
      case TLogLevel.debug:
        return '🐛 $tag';
      case TLogLevel.info:
        return '🗣 $tag';
      case TLogLevel.analytic:
        return '📊 $tag';
      case TLogLevel.warning:
        return '🚧 $tag';
      case TLogLevel.error:
        return '❌ $tag';
      case TLogLevel.fatal:
        return '☠️ $tag';
    }
  }
}
