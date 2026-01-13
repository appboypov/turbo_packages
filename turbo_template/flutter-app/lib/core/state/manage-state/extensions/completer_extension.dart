import 'dart:async';

extension CompleterExtension<T> on Completer<T> {
  void completeIfNotComplete([FutureOr<T>? value]) {
    if (!isCompleted) {
      complete(value);
    }
  }
}

