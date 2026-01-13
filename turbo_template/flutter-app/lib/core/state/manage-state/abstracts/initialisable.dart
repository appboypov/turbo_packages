import 'dart:async';

/// Mixin for services that require async initialization.
///
/// Provides a standardized pattern for services that need to perform
/// asynchronous setup before they're ready to use.
///
/// Usage:
/// ```dart
/// class MyService with Initialisable, Loglytics {
///   MyService() {
///     _initialise();
///   }
///
///   Future<void> _initialise() async {
///     try {
///       await loadData();
///       completeInitialisation();
///     } catch (e) {
///       log.error('Failed to initialize', error: e);
///     }
///   }
/// }
///
/// // Usage
/// await MyService.locate.isReady;
/// ```
mixin Initialisable {
  final Completer<void> _isReadyCompleter = Completer<void>();

  /// Future that completes when the service is fully initialized.
  ///
  /// Await this before using the service to ensure all async setup is complete.
  Future<void> get isReady => _isReadyCompleter.future;

  /// Whether the service has completed initialization.
  bool get isInitialised => _isReadyCompleter.isCompleted;

  /// Marks the service as initialized.
  ///
  /// Call this at the end of your initialization logic.
  /// Can only be called once.
  void completeInitialisation() {
    if (!_isReadyCompleter.isCompleted) {
      _isReadyCompleter.complete();
    }
  }

  /// Marks the service initialization as failed.
  ///
  /// Call this when initialization encounters an unrecoverable error.
  void failInitialisation(Object error, [StackTrace? stackTrace]) {
    if (!_isReadyCompleter.isCompleted) {
      _isReadyCompleter.completeError(error, stackTrace);
    }
  }
}
