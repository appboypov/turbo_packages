import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'analytics.dart';

/// Used to register analytics objects via the [Turbolytics.setUp] method.
@protected
class AnalyticsFactory {
  const AnalyticsFactory({
    required GetIt getIt,
  }) : _getIt = getIt;

  final GetIt _getIt;

  void registerAnalytic<A extends Analytics>(A Function() analytic) {
    _getIt.registerFactory<A>(analytic);
  }
}
