part of '../abstracts/t_jev_question.dart';

/// A Question that gives the Probability that a statement about the State is
/// true.
///
/// ```dart
/// const billing = TJevNoul(instructions: 'Is this message about billing?');
/// ```
final class TJevNoul extends TJevQuestion<TJevNoulAnswer> {
  const TJevNoul({
    super.id,
    this.instructions,
    this.trueMeans,
    this.falseMeans,
  });

  /// The question or statement to judge.
  ///
  /// A Noul needs Instructions or a meaning of true or false.
  final Object? instructions;

  /// What counts as true.
  final Object? trueMeans;

  /// What counts as false.
  final Object? falseMeans;

  @override
  TJevNoulQuestionDto toDto({required String id}) {
    if (instructions == null && trueMeans == null && falseMeans == null) {
      throw TJevInvalidQuestionException(
        reason: TJevMessages.meaninglessNoul(id),
      );
    }
    TJevQuestion.checkContent(
      instructions,
      TJevMessages.noulInstructionsLocation(id),
    );
    TJevQuestion.checkContent(trueMeans, TJevMessages.trueMeaningLocation(id));
    TJevQuestion.checkContent(
      falseMeans,
      TJevMessages.falseMeaningLocation(id),
    );
    return TJevNoulQuestionDto(
      instructions: instructions,
      criteria: trueMeans == null && falseMeans == null
          ? null
          : TJevNoulCriteriaDto(trueMeans: trueMeans, falseMeans: falseMeans),
    );
  }

  @override
  TJevNoulAnswer answerFromJson(Map<String, dynamic> json) {
    final dto = TJevNoulAnswerDto.fromJson(json);
    TJevQuestion._checkAnswerType(dto.type, 'noul');
    return TJevNoulAnswer(probability: dto.noul);
  }
}
