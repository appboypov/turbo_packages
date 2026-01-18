import 'dart:async';

import 'package:turbolytics/turbolytics.dart';

/// A service that manages a stream subscription with automatic retry functionality.
///
/// This abstract class provides a base implementation for services that need to maintain
/// a stream connection with automatic reconnection attempts on failures.
///
/// Example usage:
/// ```dart
/// class UserSyncService extends SyncService<User> {
///   @override
///   Stream<User> Function() get stream => () => userStream;
///
///   @override
///   void Function(User value) get onData => (user) {
///     // Handle incoming user data
///   };
/// }
///
/// final service = UserSyncService();
/// // Service will automatically initialize and manage the stream
/// ```
abstract class SyncService<T extends Object?> {
  SyncService({bool initialiseStream = true}) {
    if (initialiseStream) {
      tryInitialiseStream();
    }
  }

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\
  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  /// Disposes of the service by resetting the stream and retry timer.
  Future<void> dispose() async {
    log.debug('Starting disposal of $runtimeType');
    await _resetStream();
    _resetRetryTimer();
    _nrOfRetry = 0;
    log.debug('Completed disposal of $runtimeType\n');
  }

  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\

  /// Returns a function that provides the stream to listen to.
  Stream<T> Function() get stream;

  /// Returns a function that handles incoming data from the stream.
  void Function(T value) get onData;

  // 🎩 STATE --------------------------------------------------------------------------------- \\

  StreamSubscription? _subscription;
  Timer? _retryTimer;
  final int _maxNrOfRetry = 20;
  int _nrOfRetry = 0;

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\

  late final TLog log = TLog(location: runtimeType.toString());

  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  /// Cancels and resets the current stream subscription.
  Future<void> _resetStream() async {
    log.debug('Resetting stream subscription');
    await _subscription?.cancel();
    _subscription = null;
    log.debug('Stream subscription reset\n');
  }

  /// Cancels and resets the retry timer.
  void _resetRetryTimer() {
    log.debug('Resetting retry timer');
    _retryTimer?.cancel();
    _retryTimer = null;
    log.debug('Retry timer reset\n');
  }

  /// Attempts to retry stream initialization after a failure.
  void _tryRetry() {
    log.debug('Attempting stream retry');
    if (_nrOfRetry < _maxNrOfRetry) {
      if (_retryTimer?.isActive ?? false) {
        _resetRetryTimer();
        log.debug('Active retry timer reset');
      }
      log.debug(
        'Initiating stream retry $_nrOfRetry/$_maxNrOfRetry for $runtimeType in 10 seconds',
      );
      _retryTimer = Timer(const Duration(seconds: 10), () {
        _nrOfRetry++;
        _resetStream();
        tryInitialiseStream();
        _retryTimer = null;
      });
    } else {
      _resetStream();
    }
    log.debug('Retry attempt handling complete\n');
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  /// Called when the stream completes.
  ///
  /// Override this method to handle stream completion differently.
  void onDone(int nrOfRetry, int maxNrOfRetry) {
    log.debug('Stream completed for $runtimeType\n');
  }

  /// Attempts to initialize the stream subscription.
  ///
  /// Handles errors by initiating retry mechanism.
  Future<void> tryInitialiseStream() async {
    log.debug('Starting stream initialization');
    await _resetStream();
    try {
      _subscription = stream().listen(
        onData,
        onError: (error, stackTrace) {
          log.error(
            'Stream error occurred inside of stream!',
            error: error,
            stackTrace: stackTrace,
          );
          _tryRetry();
        },
        onDone: () => onDone(_nrOfRetry, _maxNrOfRetry),
      );
      log.debug('Stream initialization successful\n');
    } catch (error, stack) {
      log.error('Stream error occurred while setting up stream!', error: error, stackTrace: stack);
      _tryRetry();
      log.debug('Stream initialization failed\n');
    }
  }
}
