/// Thrown before sending when the Questions of a Request are invalid or its
/// content is no JSON content: a non-finite number, a map key that is no
/// String or an object without `toJson`, in the State or in a Question.
final class TJevInvalidQuestionException implements Exception {
  const TJevInvalidQuestionException({required this.reason});

  /// What is wrong with the Questions or the content.
  final String reason;

  @override
  String toString() => 'TJevInvalidQuestionException{reason: $reason}';
}
