import 'package:flutter/foundation.dart';

/// A constant instance of [CanThrow] for convenient use.
const canThrow = CanThrow._();

/// An annotation indicating that a method can throw an exception.
///
/// This annotation serves as a clear indicator that the annotated method is designed
/// to throw exceptions rather than handle them internally. The caller is responsible
/// for implementing appropriate exception handling.
///
/// Example:
/// ```dart
/// @canThrow
/// void riskyOperation() {
///   if (somethingWrong) {
///     throw Exception('Something went wrong');
///   }
/// }
///
/// void main() {
///   try {
///     riskyOperation();
///   } catch (e) {
///     // Handle the exception here
///   }
/// }
/// ```
@immutable
class CanThrow {
  /// Creates a private instance of [CanThrow].
  ///
  /// Private constructor to ensure singleton usage through [canThrow] constant.
  const CanThrow._();
}
