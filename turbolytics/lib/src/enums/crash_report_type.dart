import 'log_level.dart';
import '../extensions/log_type_extensions.dart';

/// Used to indicate what type of leading information is added to the crash report.
enum CrashReportType {
  location,
  tagLocation,
  iconTagLocation,
}

extension CrashReportTypeExtension on CrashReportType {
  String parseLogLevel({
    required String location,
    required LogLevel logLevel,
  }) {
    switch (this) {
      case CrashReportType.location:
        return '[$location]';
      case CrashReportType.tagLocation:
        return '${logLevel.tag} [$location]';
      case CrashReportType.iconTagLocation:
        return '${logLevel.iconTag} [$location]';
    }
  }
}
