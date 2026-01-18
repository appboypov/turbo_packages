import 'package:flutter/foundation.dart';

/// An annotation that indicates a class, method or variable should not be used
/// unless a specific reason is met.
///
/// Use this annotation to mark code that should only be used in specific cases
/// and document why through the [reason] parameter.
///
/// ```dart
/// @DoNotUseUnless(reason: 'This is a legacy API that will be removed')
/// void legacyMethod() {
///   // ...
/// }
/// ```
@immutable
class DoNotUseUnless {
  final String reason;

  const DoNotUseUnless({required this.reason});
}
