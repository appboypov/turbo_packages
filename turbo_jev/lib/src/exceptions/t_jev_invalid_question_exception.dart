part of '../abstracts/t_jev_exception.dart';

/// Thrown before sending when the Questions of a Request are invalid or its
/// content is no JSON content: a non-finite number, a map key that is no
/// String or an object without `toJson`, in the State or in a Question.
final class TJevInvalidQuestionException extends TJevException {
  const TJevInvalidQuestionException({required this.message});

  // ⚡️ OVERRIDES

  /// What is wrong with the Questions or the content.
  @override
  final String message;

  @override
  String toString() => 'TJevInvalidQuestionException{message: $message}';
}
