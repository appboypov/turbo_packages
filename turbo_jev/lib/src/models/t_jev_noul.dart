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
  final Object? instructions;

  /// What counts as true.
  final Object? trueMeans;

  /// What counts as false.
  final Object? falseMeans;

  @override
  TJevNoulQuestionDto toDto() => TJevNoulQuestionDto(
    instructions: instructions,
    criteria: trueMeans == null && falseMeans == null
        ? null
        : TJevNoulCriteriaDto(trueMeans: trueMeans, falseMeans: falseMeans),
  );

  @override
  TJevNoulAnswer answerFromJson(Map<String, dynamic> json) =>
      TJevNoulAnswer.fromJson(json);
}
