import 'package:turbolytics/turbolytics.dart';

class CounterAnalytics extends Analytics {
  final String counterButton = 'counter_button';
  final String _counterView = 'counter_view';

  void viewPage() => service.viewed(subject: _counterView);
}
