import 'dart:async';

import 'package:loglytics/loglytics.dart';

abstract class SyncService<T extends Object?> {
  SyncService({bool initialiseStream = true}) {
    if (initialiseStream) {
      tryInitialiseStream();
    }
  }

  Stream<T> Function() get stream;

  void Function(T value) get onData;

  StreamSubscription? _subscription;
  Timer? _retryTimer;
  final int _maxNrOfRetry = 20;
  int _nrOfRetry = 0;

  late final Log log = Log(location: runtimeType.toString());

  Future<void> _resetStream() async {
    log.debug('Resetting stream subscription');
    await _subscription?.cancel();
    _subscription = null;
    log.debug('Stream subscription reset\n');
  }

  void _resetRetryTimer() {
    log.debug('Resetting retry timer');
    _retryTimer?.cancel();
    _retryTimer = null;
    log.debug('Retry timer reset\n');
  }

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

  void onDone(int nrOfRetry, int maxNrOfRetry) {
    log.debug('Stream completed for $runtimeType\n');
  }

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

  Future<void> dispose() async {
    log.debug('Starting disposal of $runtimeType');
    await _resetStream();
    _resetRetryTimer();
    _nrOfRetry = 0;
    log.debug('Completed disposal of $runtimeType\n');
  }
}

