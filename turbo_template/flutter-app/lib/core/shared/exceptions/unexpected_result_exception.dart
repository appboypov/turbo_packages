/// An exception thrown when a result does not match the expected outcome.
///
/// Use this exception when an operation produces a result that deviates from
/// what was anticipated, optionally providing a reason for the mismatch.
///
/// ```dart
/// try {
///   if (result != expectedValue) {
///     throw UnexpectedResultException(
///       result: result,
///       reason: 'Result should match expected value',
///     );
///   }
/// } on UnexpectedResultException catch (e) {
///   print(e); // UnexpectedResultException{result: actual, reason: message}
/// }
/// ```
class UnexpectedResultException implements Exception {
  const UnexpectedResultException({this.result, required this.reason});
  final Object? result;
  final String? reason;

  @override
  String toString() {
    return 'UnexpectedResultException{result: $result, reason: $reason}';
  }
}
