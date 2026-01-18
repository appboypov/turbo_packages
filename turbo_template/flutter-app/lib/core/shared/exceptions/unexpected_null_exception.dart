/// An exception that is thrown when an unexpected null value is encountered.
///
/// Use this exception to indicate that a null value was found in a context
/// where it should not be possible.
///
/// ```dart
/// try {
///   if (criticalValue == null) {
///     throw UnexpectedNullException(
///       reason: 'Critical value should never be null',
///     );
///   }
/// } catch (e) {
///   print(e); // UnexpectedNullException{reason: Critical value should never be null}
/// }
/// ```
class UnexpectedNullException {
  const UnexpectedNullException({required this.reason});

  final String reason;

  @override
  String toString() {
    return 'UnexpectedNullException{reason: $reason}';
  }
}
