part of '../abstracts/t_jev_question.dart';

/// A Question that picks one Option from a defined set.
///
/// Each Option is a value of [T], such as an enum value or a candidate id. On
/// the wire an enum value goes under its name and any other value under its
/// `toString`.
///
/// ```dart
/// const department = TJevChoice<Team>(
///   instructions: 'Which team should handle this?',
///   options: {
///     Team.returns: 'Exchanges, wrong or damaged items',
///     Team.billing: 'Charges, invoices, payment problems',
///   },
/// );
/// ```
final class TJevChoice<T extends Object>
    extends TJevQuestion<TJevChoiceAnswer<T>> {
  const TJevChoice({super.id, this.instructions, required this.options});

  /// What to choose.
  final Object? instructions;

  /// The Options in order, each with its description or null.
  ///
  /// A Choice needs 1 to 255 Options, each with its own wire key.
  final Map<T, Object?> options;

  @override
  TJevChoiceQuestionDto toDto({required String id}) {
    if (options.isEmpty || options.length > TJevLimits.maxOptions) {
      throw TJevInvalidQuestionException(
        message: TJevMessages.optionCount(id, options.length),
      );
    }
    TJevQuestion.checkContent(
      instructions,
      TJevMessages.choiceInstructionsLocation(id),
    );
    final criteria = <String, Object?>{};
    for (final MapEntry(key: option, value: description) in options.entries) {
      final key = TJevQuestion._wireKey(option);
      if (criteria.containsKey(key)) {
        throw TJevInvalidQuestionException(
          message: TJevMessages.duplicateOptionKey(id, key),
        );
      }
      TJevQuestion.checkContent(
        description,
        TJevMessages.optionDescriptionLocation(id, key),
      );
      criteria[key] = description;
    }
    return TJevChoiceQuestionDto(
      instructions: instructions,
      criteria: criteria,
    );
  }

  @override
  TJevChoiceAnswer<T> answerFromJson(Map<String, dynamic> json) {
    final dto = TJevChoiceAnswerDto.fromJson(json);
    TJevQuestion._checkAnswerType(dto.type, TJevQuestionType.choice);
    final optionsByKey = {
      for (final option in options.keys) TJevQuestion._wireKey(option): option,
    };
    TJevQuestion._checkKeys(
      TJevHttp.probabilitiesKey,
      dto.probabilities.keys,
      optionsByKey.keys.toList(),
    );
    final choice = optionsByKey[dto.choice];
    if (choice == null) {
      throw FormatException(TJevMessages.unknownOption(dto.choice));
    }
    return TJevChoiceAnswer(
      choice: choice,
      confidence: dto.confidence,
      probabilities: {
        for (final MapEntry(:key, value: option) in optionsByKey.entries)
          option: dto.probabilities[key]!,
      },
    );
  }
}
