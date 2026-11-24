part of 'turbolytics.dart';

/// Used to make sure that events that are fired will be sent in chronological order.
class TAnalyticsEventBus {
  factory TAnalyticsEventBus() => _eventBus;
  TAnalyticsEventBus._();
  static final TAnalyticsEventBus _eventBus = TAnalyticsEventBus._();

  late final StreamController<Future<void>> _crashReports =
      StreamController.broadcast();
  StreamSubscription? _crashReportsSubscription;
  late final StreamController<Future<void>> _analytics =
      StreamController.broadcast();
  StreamSubscription? _analyticsSubscription;
  late final StreamController<Future<void>> _combinedEvents =
      StreamController.broadcast();
  StreamSubscription? _combinedEventsSubscription;

  /// Adds a crash report to the event stream.
  void tryAddCrashReport(Future<void>? crashReport) {
    if (crashReport != null) {
      if (Turbolytics._combineEvents) {
        _combinedEvents.add(_send(crashReport));
      } else {
        _crashReports.add(_send(crashReport));
      }
    }
  }

  /// Adds an analytic report to the event stream.
  void tryAddAnalytic(Future<void>? analytic) {
    if (analytic != null) {
      if (Turbolytics._combineEvents) {
        _combinedEvents.add(_send(analytic));
      } else {
        _analytics.add(_send(analytic));
      }
    }
  }

  /// Used ot dispose all event streams.
  Future<void> dispose() async {
    await _crashReportsSubscription?.cancel();
    _crashReportsSubscription = null;
    await _analyticsSubscription?.cancel();
    _analyticsSubscription = null;
    await _combinedEventsSubscription?.cancel();
    _combinedEventsSubscription = null;
  }

  /// Used to start listening to the event streams.
  Future<void> _listen() async {
    if (Turbolytics._combineEvents) {
      if (!_combinedEvents.hasListener && _combinedEventsSubscription == null) {
        _combinedEventsSubscription = _combinedEvents.stream.listen(_await);
      }
    } else {
      if (!_crashReports.hasListener && _crashReportsSubscription == null) {
        _crashReportsSubscription = _crashReports.stream.listen(_await);
      }
      if (!_analytics.hasListener && _analyticsSubscription == null) {
        _analyticsSubscription = _analytics.stream.listen(_await);
      }
    }
  }

  /// Waits for [report] in the order the events came.
  static Future<void> _await(Future<void> report) => report;

  /// Waits for [report] and drops its failure, so a reporter that fails never stops the program.
  static Future<void> _send(Future<void> report) async {
    try {
      await report;
    } catch (_) {
      // The reporter decides how it reports its own failure, and turbolytics carries on.
    }
  }
}
