import 'package:turbolytics/turbolytics.dart';

/// Base class to be inherited when specifying analytics for a specific feature or part of your project.
///
/// Comes with an [TAnalyticsService] to facilitate easy logging of analytics.
class TAnalytics {
  TAnalytics();
  late final TAnalyticsService service;
}
