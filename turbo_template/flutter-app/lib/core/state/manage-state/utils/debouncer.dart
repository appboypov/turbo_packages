import 'dart:async';

import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/completer_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';

class Debouncer {
  Debouncer({Duration duration = TDurations.animation}) : _duration = duration;

  final Duration _duration;

  Completer? _isRunningCompleter;
  Timer? _timer;
  VoidCallback? _voidCallback;

  Future get isDone => _isRunningCompleter?.future ?? Future.value();

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

  void tryCancel() => _timer?.cancel();

  void tryCancelAndRunNow() {
    tryCancel();
    _voidCallback?.call();
    _voidCallback = null;
  }

  void forceRun(VoidCallback voidCallback) {
    tryCancel();
    _voidCallback = null;
    voidCallback();
  }
}
