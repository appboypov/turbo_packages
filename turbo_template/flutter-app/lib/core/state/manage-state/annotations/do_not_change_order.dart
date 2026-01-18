import 'package:flutter/foundation.dart';

/// An annotation that indicates the order of fields in a class must not be changed.
///
/// Use this annotation on classes or enums where field/value order is important and
/// must be preserved, for example when working with serialization or binary protocols.
///
/// Example:
/// ```dart
/// @DoNotChangeOrder()
/// enum Status {
///   draft,     // Must remain first (index 0)
///   pending,   // Must remain second (index 1)
///   published, // Must remain third (index 2)
///   archived   // Must remain fourth (index 3)
/// }
/// ```
@immutable
class DoNotChangeOrder {
  const DoNotChangeOrder();
}
