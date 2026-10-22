part of '../abstracts/t_jev_exception.dart';

/// Thrown when a [TJevResult] is read for a Question its Request did not ask.
final class TJevUnaskedQuestionException extends TJevException {
  const TJevUnaskedQuestionException({required this.message});

  /// Which Question was not asked.
  @override
  final String message;

  @override
  String toString() => 'TJevUnaskedQuestionException{message: $message}';
}
