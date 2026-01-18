import '../extensions/log_type_extensions.dart';
import 't_log_level.dart';

/// Used to indicate what type of leading information is added to the crash report.
enum TCrashReportType {
  location,
  tagLocation,
  iconTagLocation,
}

extension CrashReportTypeExtension on TCrashReportType {
  String parseLogLevel({
    required String location,
    required TLogLevel logLevel,
  }) {
    switch (this) {
      case TCrashReportType.location:
        return '[$location]';
      case TCrashReportType.tagLocation:
        return '${logLevel.tag} [$location]';
      case TCrashReportType.iconTagLocation:
        return '${logLevel.iconTag} [$location]';
    }
  }
}
