import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';
import 'package:turbolytics/turbolytics.dart';

import 'debouncer.dart';
import 'mutex.dart';

/// A utility class that combines debouncing with blocking functionality.
///
/// BlockDebouncer helps manage asynchronous operations by debouncing them and
/// providing a blocking mechanism to prevent concurrent executions.
///
/// Example:
/// ```dart
/// final debouncer = BlockDebouncer(duration: Duration(milliseconds: 300));
///
/// // Add futures to be debounced
/// debouncer.onChanged(myFuture);
///
/// // Check if processing is complete
/// if (debouncer.canContinue) {
///   // Continue with next operation
/// }
///
/// // Clean up resources
/// debouncer.dispose();
/// ```
class BlockDebouncer with Turbolytics {
  BlockDebouncer({required Duration duration}) : _debouncer = Debouncer(duration: duration);

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\
  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  void dispose() => _debouncer.tryCancel();

  // 🎩 STATE --------------------------------------------------------------------------------- \\

  bool _canContinue = true;
  final List<Future> _futures = [];

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\

  final Debouncer _debouncer;
  final Mutex _mutex = Mutex();

  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  bool get canContinue => _canContinue;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  /// Handles changes by managing futures and debouncing their execution.
  ///
  /// Takes an optional [future] parameter that will be added to a queue of futures
  /// to be executed. Sets [canContinue] to false while processing and true when complete.
  /// Uses mutex locking to safely manage concurrent access to the futures list.
  /// All futures are executed with a timeout specified by [TDurations.timeOut].
  void onChanged([Future? future]) {
    log.debug('BlockDebouncer.onChanged called with future: ${future != null}');
    _canContinue = false;
    if (future != null) {
      _mutex.lockAndRun(
        run: (unlock) async {
          try {
            log.debug('Adding future to queue');
            _futures.add(future);
          } catch (error, stackTrace) {
            TLog(location: 'BlockDebouncer').error(
              'Exception caught while adding future to BlockDebouncer!',
              error: error,
              stackTrace: stackTrace,
            );
          } finally {
            unlock();
          }
        },
      );
    }
    _debouncer.run(() async {
      if (_futures.isNotEmpty) {
        await _mutex.lockAndRun(
          run: (unlock) async {
            try {
              log.debug('Processing ${_futures.length} queued futures');
              final deepCopy = List<Future>.from(_futures);
              _futures.clear();
              await Future.wait(deepCopy).timeout(TDurations.timeOut);
              log.debug('Successfully processed all queued futures');
            } catch (error, stackTrace) {
              TLog(location: 'BlockDebouncer').error(
                'Exception caught while running future in BlockDebouncer!',
                error: error,
                stackTrace: stackTrace,
              );
            } finally {
              unlock();
            }
          },
        );
      }
      _canContinue = true;
      log.debug('BlockDebouncer processing complete, canContinue set to true');
    });
  }
}
