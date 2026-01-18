import 'package:flutter/material.dart';

class ScrollControllerBox {
  final Map<dynamic, ScrollController> _controllers = {};

  ScrollController get(dynamic key) {
    return _controllers.putIfAbsent(key, () => ScrollController());
  }

  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }
}
