class CRUD<T> {
  const CRUD({
    required this.isActive,
    required this.add,
    required this.addAll,
    required this.remove,
    required this.removeAll,
    required this.update,
    required this.clear,
    required this.toggle,
    required this.onItemChanged,
  });

  final bool Function(T value) isActive;
  final void Function() clear;
  final void Function(Iterable<T> value) addAll;
  final void Function(Iterable<T> value) removeAll;
  final void Function(Set<T> value) update;
  final void Function(T value) add;
  final void Function(T value) remove;
  final void Function(T value) toggle;
  final void Function(T item, bool isActive, Set<T> activeItems)? onItemChanged;
}
