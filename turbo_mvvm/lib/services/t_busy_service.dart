import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:turbo_mvvm/data/constants/turbo_mvvm_defaults.dart';
import 'package:turbo_mvvm/data/enums/t_busy_type.dart';
import 'package:turbo_mvvm/data/models/t_busy_model.dart';

/// A service to manage the busy state of the application.
/// Utilizes a ValueNotifier to notify subscribers when the busy state changes.
class TBusyService {
  TBusyService._();
  static TBusyService? _instance;

  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  static void initialise({
    TBusyType busyTypeDefault = TBusyType.defaultValue,
    Duration timeoutDurationDefault = TurboMvvmDefaults.timeout,
    String? busyMessageDefault,
    String? busyTitleDefault,
    VoidCallback? onTimeoutDefault,
  }) {
    _busyMessageDefault = busyMessageDefault;
    _busyTitleDefault = busyTitleDefault;
    _busyTypeDefault = busyTypeDefault;
    _onTimeoutDefault = onTimeoutDefault;
    _timeoutDurationDefault = timeoutDurationDefault;
  }

  /// Disposes resources held by [TBusyService].
  void dispose() {
    _allowUpdateTimer?.cancel();
    _isBusyNotifier.dispose();
    _mutex.dispose();
    _instance = null;
  }

  // 🎩 STATE --------------------------------------------------------------------------------- \\

  static TBusyType _busyTypeDefault = TBusyType.defaultValue;
  static Duration _timeoutDurationDefault = TurboMvvmDefaults.timeout;
  static String? _busyMessageDefault;
  static String? _busyTitleDefault;
  static VoidCallback? _onTimeoutDefault;

  final _isBusyNotifier = ValueNotifier<TBusyModel>(
    TBusyModel(
      isBusy: false,
      busyType: _busyTypeDefault,
      busyTitle: null,
      busyMessage: null,
      payload: null,
    ),
  );

  Timer? _allowUpdateTimer;
  Timer? _timeoutTimer;
  int _isBusies = 0;
  int _isNotBusies = 0;

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\

  final _mutex = _Mutex();

  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  bool get isBusy => _isBusyNotifier.value.isBusy;
  ValueListenable<TBusyModel> get isBusyListenable => _isBusyNotifier;

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  /// Sets the busy state of the application.
  void setBusy(
    bool isBusy, {
    Duration minBusyDuration = TurboMvvmDefaults.minBusy,
    String? busyMessage,
    String? busyTitle,
    TBusyType? busyType,
    Duration? timeoutDuration,
    VoidCallback? onTimeout,
    dynamic payload,
  }) {
    print('''[🐛] [PRINT] [🌟] [TBusyService.setBusy] [📞] I was called with: $isBusy''');
    if (_allowUpdateTimer == null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _setBusy(
          isBusy: isBusy,
          busyMessage: busyMessage ?? _busyMessageDefault,
          busyTitle: busyTitle ?? _busyTitleDefault,
          busyType: busyType ?? _busyTypeDefault,
          onTimeout: onTimeout ?? _onTimeoutDefault,
          timeoutDuration: timeoutDuration ?? _timeoutDurationDefault,
          payload: payload,
        ),
      );
      if (isBusy) {
        _allowUpdateTimer = Timer(
          minBusyDuration,
          () {
            if ((_isBusies - _isNotBusies) != 0) {
              final isReallyBusy = _isBusies > _isNotBusies;
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _setBusy(
                  isBusy: isReallyBusy,
                  busyMessage: busyMessage,
                  busyType: busyType ?? _busyTypeDefault,
                  busyTitle: busyTitle ?? _busyTitleDefault,
                  onTimeout: onTimeout ?? _onTimeoutDefault,
                  timeoutDuration: timeoutDuration ?? _timeoutDurationDefault,
                  payload: payload,
                ),
              );
              _mutex.lockAndRun(
                run: (unlock) {
                  _isBusies = 0;
                  _isNotBusies = 0;
                  unlock();
                },
              );
            }
            _allowUpdateTimer = null;
          },
        );
      }
    } else {
      _mutex.lockAndRun(
        run: (unlock) {
          if (isBusy) {
            _isBusies++;
          } else {
            _isNotBusies++;
          }
          unlock();
        },
      );
    }
  }

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  /// Sets the busy state in the ValueNotifier
  void _setBusy({
    required bool isBusy,
    required String? busyMessage,
    required String? busyTitle,
    required TBusyType busyType,
    required Duration timeoutDuration,
    required VoidCallback? onTimeout,
    required dynamic payload,
  }) {
    if (isBusy && onTimeout != null) {
      _timeoutTimer?.cancel();
      _timeoutTimer = Timer(
        timeoutDuration,
        () {
          onTimeout();
          _timeoutTimer = null;
        },
      );
    } else {
      _timeoutTimer?.cancel();
    }
    _isBusyNotifier.value = TBusyModel(
      isBusy: isBusy,
      busyTitle: isBusy ? busyTitle : null,
      busyMessage: isBusy ? busyMessage : null,
      busyType: busyType,
      payload: payload,
    );
  }

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  /// Returns an instance of [TBusyService] and sets the default [TBusyType] if provided.
  static TBusyService instance({
    @Deprecated('Use BusyService.initialise instead') TBusyType? defaultBusyType,
  }) {
    if (defaultBusyType != null) {
      _busyTypeDefault = defaultBusyType;
    }
    return _instance ??= TBusyService._();
  }
}

/// A private class to implement a mutex.x
/// Mutex is implemented to avoid race conditions when setting busy states.
class _Mutex {
  final _completerQueue = Queue<Completer>();

  /// Locks the busy state and runs the provided function
  FutureOr<T> lockAndRun<T>({
    required FutureOr<T> Function(VoidCallback unlock) run,
  }) async {
    final completer = Completer();
    _completerQueue.add(completer);
    if (_completerQueue.first != completer) {
      await _completerQueue.removeFirst().future;
    }
    final value = await run(() => completer.complete());
    return value;
  }

  /// Disposes resources held by [_Mutex].
  void dispose() {
    _completerQueue.clear();
  }
}
