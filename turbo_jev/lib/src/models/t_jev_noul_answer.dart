part of '../abstracts/t_jev_answer.dart';

/// The Answer of a Noul: the Probability that its statement is true.
final class TJevNoulAnswer extends TJevAnswer {
  const TJevNoulAnswer({required this.probability});

  /// The Answer of [dto].
  ///
  /// Throws a [FormatException] when [dto] is no Noul Answer.
  @internal
  factory TJevNoulAnswer.fromDto(TJevNoulAnswerDto dto) {
    TJevAnswer._checkType(dto.type, TJevQuestionType.noul);
    return TJevNoulAnswer(probability: dto.noul);
  }

  /// The Probability that the statement is true, from 0 to 1.
  final double probability;

  /// How decided the Answer is: `abs(2p - 1)`, from 0 at a Probability of 0.5
  /// to 1 at a Probability of 0 or 1.
  double get confidence => (2 * probability - 1).abs();
}
