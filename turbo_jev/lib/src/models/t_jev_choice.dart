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

  // ⚡️ OVERRIDES

  @override
  TurboResponse<void> validate() {
    if (options.isEmpty || options.length > TJevLimits.maxOptions) {
      return TurboResponse.failAsBool(
        message: TJevMessages.optionCount(options.length),
      );
    }
    final instructionsCheck = TJevQuestion.checkContent(
      instructions,
      TJevMessages.instructionsLocation,
    );
    if (instructionsCheck.isFail) return instructionsCheck;
    final keys = <String>{};
    for (final MapEntry(key: option, value: description) in options.entries) {
      final key = TJevQuestion.wireKey(option);
      if (!keys.add(key)) {
        return TurboResponse.failAsBool(
          message: TJevMessages.duplicateOptionKey(key),
        );
      }
      final descriptionCheck = TJevQuestion.checkContent(
        description,
        TJevMessages.optionDescriptionLocation(key),
      );
      if (descriptionCheck.isFail) return descriptionCheck;
    }
    return const TurboResponse.successAsBool();
  }

  // 🎩 STATE

  /// What to choose.
  final Object? instructions;

  /// The Options in order, each with its description or null.
  ///
  /// A Choice needs 1 to 255 Options, each with its own wire key.
  final Map<T, Object?> options;

  // 🧲 FETCHERS

  /// The result of [open] called with this Choice typed on its Option type
  /// [T], so what [open] builds keeps [T].
  @internal
  R withOptionType<R>(
    R Function<O extends Object>(TJevChoice<O> choice) open,
  ) => open<T>(this);
}
