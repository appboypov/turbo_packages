/// Thrown when a [TJevResult] is read for a Question its Request did not ask.
final class TJevUnaskedQuestionException implements Exception {
  const TJevUnaskedQuestionException({required this.reason});

  /// Which Question was not asked.
  final String reason;

  @override
  String toString() => 'TJevUnaskedQuestionException{reason: $reason}';
}
