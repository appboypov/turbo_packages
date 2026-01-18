import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/state/manage-state/models/crud.dart';
import 'package:turbo_notifiers/turbo_notifiers.dart';

class ActiveItemsBuilder<T> extends StatefulWidget {
  ActiveItemsBuilder({
    required Iterable<T> initialActiveItems,
    required this.builder,
    this.onItemChanged,
    this.child,
    super.key,
  }) : initialActiveItems = initialActiveItems.toSet();

  final Set<T> initialActiveItems;
  final Widget Function(BuildContext context, CRUD<T> crud, Widget? child) builder;
  final void Function(T item, bool isActive, Set<T> activeItems)? onItemChanged;
  final Widget? child;

  @override
  State<ActiveItemsBuilder<T>> createState() => _ActiveItemsBuilderState<T>();
}

class _ActiveItemsBuilderState<T> extends State<ActiveItemsBuilder<T>> {
  late final TNotifier<Set<T>> _activeItems;

  @override
  void initState() {
    _activeItems = TNotifier<Set<T>>(widget.initialActiveItems, forceUpdate: true);
    super.initState();
  }

  @override
  void dispose() {
    _activeItems.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _activeItems,
    builder: (context, child) => widget.builder(
      context,
      CRUD<T>(
        update: (value) => _activeItems.update(value),
        isActive: (value) => _activeItems.value.contains(value),
        add: (value) {
          _activeItems.updateCurrent((current) => current..add(value));
          widget.onItemChanged?.call(value, true, _activeItems.value);
        },
        addAll: (value) {
          _activeItems.updateCurrent((current) => current..addAll(value));
          for (final item in value) {
            widget.onItemChanged?.call(item, true, _activeItems.value);
          }
        },
        remove: (value) {
          _activeItems.updateCurrent((current) => current..remove(value));
          widget.onItemChanged?.call(value, false, _activeItems.value);
        },
        removeAll: (value) {
          _activeItems.updateCurrent((current) => current..removeAll(value));
          for (final item in value) {
            widget.onItemChanged?.call(item, false, _activeItems.value);
          }
        },
        clear: () {
          final items = _activeItems.value.toSet();
          _activeItems.updateCurrent((current) => current..clear());
          for (final item in items) {
            widget.onItemChanged?.call(item, false, _activeItems.value);
          }
        },
        toggle: (value) {
          final willBeActive = !_activeItems.value.contains(value);
          _activeItems.updateCurrent((current) {
            if (current.contains(value)) {
              current.remove(value);
            } else {
              current.add(value);
            }
            return current;
          });
          widget.onItemChanged?.call(value, willBeActive, _activeItems.value);
        },
        onItemChanged: widget.onItemChanged,
      ),
      widget.child,
    ),
    child: widget.child,
  );
}
