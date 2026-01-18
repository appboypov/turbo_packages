import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';

class Throttler {
  Throttler({this.duration = TDurations.throttle});

  Timer? _timer;
  VoidCallback? _pendingAction;
  bool _isThrottled = false;
  final Duration duration;

  void run(VoidCallback action) {
    if (_isThrottled) {
      _pendingAction = action;
      return;
    }

    action();
    _isThrottled = true;

    _timer?.cancel();
    _timer = Timer(duration, () {
      _isThrottled = false;
      if (_pendingAction != null) {
        final pendingAction = _pendingAction;
        _pendingAction = null;
        pendingAction!();
      }
    });
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    _pendingAction = null;
  }
}
