/// Thrown before sending when the Questions of a Request are invalid.
final class TJevInvalidQuestionException implements Exception {
  const TJevInvalidQuestionException({required this.reason});

  /// What is wrong with the Questions.
  final String reason;

  @override
  String toString() => 'TJevInvalidQuestionException{reason: $reason}';
}
