import 'dart:async';
import 'dart:ui';

import 'package:turbo_flutter_template/core/ui/constants/t_durations.dart';

import '../extensions/completer_extension.dart';

/// A utility class that helps control the rate of execution of callbacks by delaying them.
///
/// The Debouncer ensures that rapidly fired events don't trigger a callback too frequently
/// by waiting for a specified duration of inactivity before executing the callback.
///
/// Example:
/// ```dart
/// final debouncer = Debouncer(duration: Duration(milliseconds: 300));
///
/// // In a search field
/// searchField.onChanged = (value) {
///   debouncer.run(() {
///     // This will only execute 300ms after the last keystroke
///     performSearch(value);
///   });
/// };
/// ```
class Debouncer {
  Debouncer({Duration duration = TDurations.animation}) : _duration = duration;

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  final Duration _duration;

  // 🎩 STATE --------------------------------------------------------------------------------- \\

  Completer? _isRunningCompleter;
  Timer? _timer;
  VoidCallback? _voidCallback;

  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  /// Returns a Future that completes when the current debounced operation is finished.
  Future get isDone => _isRunningCompleter?.future ?? Future.value();

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  /// Schedules a callback to be run after the specified duration.
  ///
  /// If another call to [run] occurs before the duration expires, the timer is reset.
  void run(VoidCallback voidCallback) {
    _isRunningCompleter ??= Completer();
    _voidCallback = voidCallback;
    tryCancel();
    _timer = Timer(_duration, () {
      voidCallback();
      _voidCallback = null;
      _isRunningCompleter!.completeIfNotComplete();
      _isRunningCompleter = null;
    });
  }

  /// Cancels any pending callback if one exists.
  void tryCancel() => _timer?.cancel();

  /// Cancels any pending callback and executes it immediately if one exists.
  void tryCancelAndRunNow() {
    tryCancel();
    _voidCallback?.call();
    _voidCallback = null;
  }

  /// Cancels any pending operations and runs the provided callback immediately.
  ///
  /// This method:
  /// 1. Cancels any pending timer
  /// 2. Clears any stored callback
  /// 3. Runs the provided callback immediately
  void forceRun(VoidCallback voidCallback) {
    tryCancel();
    _voidCallback = null;
    voidCallback();
  }
}
