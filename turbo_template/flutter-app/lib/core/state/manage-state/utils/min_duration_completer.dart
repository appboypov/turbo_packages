import 'dart:async';

import '../extensions/completer_extension.dart';

/// A utility class that ensures a minimum duration passes before completing.
///
/// Useful for showing loading states or animations that should have a minimum visible duration.
///
/// ```dart
/// // Create completer with 2 second minimum duration
/// final completer = MinDurationCompleter(Duration(seconds: 2));
///
/// // Start the timer
/// completer.start();
///
/// // Wait for completion
/// await completer.future;
/// ```
class MinDurationCompleter {
  MinDurationCompleter(this.duration);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  final Duration duration;
  Completer<void>? _completer;
  Timer? _timer;

  // 🏗 HELPERS ------------------------------------------------------------------------------- \\

  /// Attempts to complete the completer and cancels any existing timer.
  void tryComplete() {
    _timer?.cancel();
    _completer?.completeIfNotComplete();
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  /// Starts the minimum duration timer and creates a new completer if needed.
  void start() {
    tryComplete();
    _completer = Completer<void>();
    _timer = Timer(duration, () => tryComplete());
  }

  /// Returns the future that will complete after the minimum duration.
  ///
  /// Automatically starts the timer if not already started.
  Future<void> get future {
    if (_completer == null) {
      start();
    }
    return _completer!.future;
  }
}
