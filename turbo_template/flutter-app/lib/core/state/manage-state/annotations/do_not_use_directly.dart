import 'package:flutter/foundation.dart';

/// An annotation to mark code that should not be used directly.
///
/// This annotation provides information about why the code should not be used
/// and what alternative should be used instead.
///
/// Example:
/// ```dart
/// @DoNotUseDirectly(
///   reason: 'Use the high-level API instead',
///   useInstead: HighLevelApi,
/// )
/// class LowLevelImplementation {
///   // ...
/// }
/// ```
@immutable
class DoNotUseDirectly {
  const DoNotUseDirectly({required this.reason, required this.useInstead});
  final String reason;
  final Object? useInstead;

  @override
  String toString() {
    return 'DoNotUseDirectly{reason: $reason, serviceName: $useInstead}';
  }
}
