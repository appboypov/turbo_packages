import 'dart:async';
import 'dart:collection';
import 'dart:ui';

class Mutex {
  final _completerQueue = Queue<Completer>();

  FutureOr<T> lockAndRun<T>({
    required FutureOr<T> Function(VoidCallback unlock) run,
  }) async {
    final completer = Completer();
    _completerQueue.add(completer);
    if (_completerQueue.first != completer) {
      await _completerQueue.removeFirst().future;
    }
    final value = await run(() => completer.complete());
    _completerQueue.remove(completer);
    return value;
  }

  void dispose() => _completerQueue.clear();
}
