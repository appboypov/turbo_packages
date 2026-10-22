part of '../abstracts/t_jev_question.dart';

/// A Question that finds one region in an Image.
///
/// Only the models in [TJevModel.boxModels] answer a Box. A Box always
/// answers with a region, also when what it looks for is not in the Image;
/// ask a [TJevNoul] next to it to learn whether it is there.
///
/// ```dart
/// const mug = TJevBox(instructions: 'the coffee mug in `photo`');
/// ```
final class TJevBox extends TJevQuestion<TJevBoxAnswer> {
  const TJevBox({super.id, this.instructions});

  /// What to find, and in which Image.
  final Object? instructions;

  @override
  TurboResponse<void> validate() => TJevQuestion.checkContent(
    instructions,
    TJevMessages.instructionsLocation,
  );
}
