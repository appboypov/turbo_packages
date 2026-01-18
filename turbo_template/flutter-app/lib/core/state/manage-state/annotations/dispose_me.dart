import 'package:flutter/foundation.dart';

/// Marks a class or member for disposal.
///
/// Use this annotation to indicate that a class or member should be disposed
/// when it is no longer needed.
///
/// Example:
/// ```dart
/// @DisposeMe()
/// class MyDisposableClass {
///   final StreamController _controller = StreamController();
///
///   void dispose() {
///     _controller.close();
///   }
/// }
/// ```
@immutable
class DisposeMe {
  const DisposeMe();
}
