extension TurboObjectExtension on Object {
  /// Safely casts this object to type E
  E turboAsType<E extends Object>() => this as E;
}

extension TurboNullableObjectExtension on Object? {
  /// Returns value when condition is true, otherwise returns this
  T turboButWhen<T extends Object?>(bool condition, T Function() value) =>
      condition ? value() : this as T;
}
