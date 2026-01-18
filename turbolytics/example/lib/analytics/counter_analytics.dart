import 'package:turbolytics/turbolytics.dart';

class CounterAnalytics extends TAnalytics {
  final String counterButton = 'counter_button';
  final String _counterView = 'counter_view';

  void viewPage() => service.viewed(subject: _counterView);
}
