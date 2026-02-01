import 'dart:math';

extension IterableExtensionExtension<T> on Iterable<T> {
  List<T> get deepCopy => [...this];
}

extension IterableIntExtension on Iterable<double> {
  double get sum =>
      fold(0, (previousValue, element) => previousValue + element);
}

extension IterableExtension<T> on Iterable<T> {
  T get second => elementAt(1);
  T get third => elementAt(2);
  T get fourth => elementAt(3);
  T get random => elementAt(Random().nextInt(length));
}
