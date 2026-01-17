extension TObjectExtension on Object {
  /// Safely casts this object to type E
  E tAsType<E extends Object>() => this as E;
}

extension TNullableObjectExtension on Object? {
  /// Returns value when condition is true, otherwise returns this
  T tButWhen<T extends Object?>(bool condition, T Function() value) =>
      condition ? value() : this as T;
}
