import 'package:turbo_notifiers/t_notifier.dart';

/// Used to provide and dispose notifiers in a neat way.
class BoolNotifierBox {
  BoolNotifierBox({required bool initialValue}) : _defaultValue = initialValue;

  final bool _defaultValue;
  final Map<String, TNotifier<bool>> _box = {};
  final Set<Object> activeIds = {};

  TNotifier<bool> getNotifier(Object id, {bool? initialValue}) {
    final notifier = _box.putIfAbsent(
      id.toString(),
      () => TNotifier<bool>(initialValue ?? _defaultValue),
    );
    if (notifier.value) {
      activeIds.add(id);
    }
    return notifier;
  }

  void remove(Object id) {
    _box.remove(id.toString());
    activeIds.remove(id);
  }

  void forEach(void Function(String key, TNotifier<bool> notifier) action) =>
      _box.forEach((id, notifier) {
        action(id, notifier);
        if (notifier.value) {
          activeIds.add(id);
        }
      });

  void toggle(Object id) {
    getNotifier(id).toggle();
    if (getNotifier(id).value) {
      activeIds.add(id);
    } else {
      activeIds.remove(id);
    }
  }

  void update(Object id, bool value) {
    getNotifier(id).update(value);
    if (value) {
      activeIds.add(id);
    } else {
      activeIds.remove(id);
    }
  }

  void updateCurrent(Object id, bool Function(bool value) current) {
    final notifier = getNotifier(id);
    notifier.updateCurrent(current);
    if (notifier.value) {
      activeIds.add(id);
    } else {
      activeIds.remove(id);
    }
  }

  void dispose() {
    for (final notifier in _box.values) {
      notifier.dispose();
    }
    _box.clear();
  }

  void disableActives() {
    for (final activeId in activeIds) {
      getNotifier(activeId).update(false);
    }
    activeIds.clear();
  }

  void clear() {
    _box.clear();
  }
}

extension TNotifierBoolExtension<T> on TNotifier<bool> {
  void toggle() => updateCurrent((value) => !value);
}
