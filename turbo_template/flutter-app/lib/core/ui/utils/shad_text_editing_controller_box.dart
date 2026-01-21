import 'package:shadcn_ui/shadcn_ui.dart';

/// Used to provide and dispose text controllers in a neat way.
class ShadTextEditingControllerBox {
  final Map<Object, ShadTextEditingController> _box = {};

  ShadTextEditingController get(Object key, {String? initialValue}) {
    return _box.putIfAbsent(key.toString(), () => ShadTextEditingController(text: initialValue));
  }

  bool exists(Object key) => _box.containsKey(key.toString());

  void update({required Object key, required String value}) {
    _box.putIfAbsent(key.toString(), () => ShadTextEditingController())..text = value;
  }

  String value(Object key) {
    final value = _box.putIfAbsent(key.toString(), () => ShadTextEditingController()).value.text;
    return value;
  }

  void forAll(void Function(ShadTextEditingController controller) action) {
    for (final controller in _box.values) {
      action(controller);
    }
  }

  void dispose([Object? key]) {
    if (key != null) {
      _box.remove(key.toString())?.dispose();
    } else {
      for (final controller in _box.values) {
        controller.dispose();
      }
      _box.clear();
    }
  }

  void clear() {
    _box.clear();
  }
}
