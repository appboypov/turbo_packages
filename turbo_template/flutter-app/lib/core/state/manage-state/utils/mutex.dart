import 'dart:async';

class Mutex {
  bool _isLocked = false;
  final Completer<void> _lockCompleter = Completer<void>();

  Future<void> lockAndRun({
    required Future<void> Function(void Function() unlock) run,
  }) async {
    await _lock();
    try {
      await run(_unlock);
    } finally {
      _unlock();
    }
  }

  Future<void> _lock() async {
    while (_isLocked) {
      await _lockCompleter.future;
    }
    _isLocked = true;
  }

  void _unlock() {
    _isLocked = false;
    if (!_lockCompleter.isCompleted) {
      _lockCompleter.complete();
    }
  }
}

