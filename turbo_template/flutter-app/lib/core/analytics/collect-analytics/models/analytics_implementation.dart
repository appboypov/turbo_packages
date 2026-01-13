import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:loglytics/loglytics.dart';

/// Firebase Analytics implementation for the loglytics AnalyticsInterface.
///
/// Provides analytics tracking through Firebase Analytics.
class AnalyticsImplementation implements AnalyticsInterface {
  final _analytics = FirebaseAnalytics.instance;

  @override
  Future<void> logEvent({required String name, Map<String, Object>? parameters}) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  @override
  Future<void> resetAnalyticsData() async {
    await _analytics.resetAnalyticsData();
  }

  @override
  Future<void> setCurrentScreen({required String name, String? screenClassOverride}) async {
    await _analytics.logScreenView(
      screenName: name,
      screenClass: screenClassOverride,
    );
  }

  @override
  Future<void> setUserId(String? id) async {
    await _analytics.setUserId(id: id);
  }

  @override
  Future<void> setUserProperty({required String name, required String? value}) async {
    await _analytics.setUserProperty(name: name, value: value);
  }
}

