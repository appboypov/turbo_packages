/// Exception thrown when an unexpected state is encountered.
///
/// Use this exception when the application reaches a state that should not be possible
/// based on the current logic and constraints.
///
/// Example:
/// ```dart
/// try {
///   if (invalidState) {
///     throw UnexpectedStateException(
///       reason: 'User data is null but authentication succeeded',
///     );
///   }
/// } catch (e) {
///   print(e.toString());
/// }
/// ```
class UnexpectedStateException implements Exception {
  const UnexpectedStateException({required this.reason});

  final String reason;

  @override
  String toString() {
    return 'UnknownErrorException{reason: $reason}';
  }
}
