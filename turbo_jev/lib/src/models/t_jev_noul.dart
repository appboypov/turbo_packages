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

  // ⚡️ OVERRIDES

  @override
  TurboResponse<void> validate() {
    if (instructions == null && trueMeans == null && falseMeans == null) {
      return const TurboResponse.failAsBool(
        message: TJevMessages.meaninglessNoul,
      );
    }
    return TJevQuestion._checkContents([
      (instructions, TJevMessages.instructionsLocation),
      (trueMeans, TJevMessages.trueMeaningLocation),
      (falseMeans, TJevMessages.falseMeaningLocation),
    ]);
  }

  // 🎩 STATE

  /// The question or statement to judge.
  ///
  /// A Noul needs Instructions or a meaning of true or false.
  final Object? instructions;

  /// What counts as true.
  final Object? trueMeans;

  /// What counts as false.
  final Object? falseMeans;
}
