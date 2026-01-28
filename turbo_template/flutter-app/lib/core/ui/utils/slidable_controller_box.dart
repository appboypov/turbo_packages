import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// Used to provide and dispose scroll controllers in a neat way.
class SlidableControllerBox {
  final Map<Object, SlidableController> _box = {};

  SlidableController get(Object key, {required TickerProvider vsync}) =>
      _box.putIfAbsent(key.toString(), () => SlidableController(vsync));

  void dispose([Object? key]) {
    if (key != null) {
      _box.remove(key.toString())?.dispose();
    } else {
      for (final slidableController in _box.values) {
        slidableController.dispose();
      }
      _box.clear();
    }
  }

  void clear() {
    _box.clear();
  }
}
