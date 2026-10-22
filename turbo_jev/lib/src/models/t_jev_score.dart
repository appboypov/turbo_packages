part of '../abstracts/t_jev_question.dart';

/// A Question that places the State on ordered Levels.
///
/// Each Level is a value of [T]: an enum value or any other value with its
/// description, or the description itself.
///
/// ```dart
/// const severity = TJevScore<Severity>(
///   instructions: 'How severe is the reported issue?',
///   levels: {
///     Severity.cosmetic: 'Cosmetic; no impact to functionality',
///     Severity.blocking: 'Blocking issue; no workaround exists',
///   },
/// );
/// ```
final class TJevScore<T extends Object>
    extends TJevQuestion<TJevScoreAnswer<T>> {
  /// A Score whose [levels] map each Level to its description, from the low
  /// end of the scale to the high end.
  const TJevScore({
    super.id,
    this.instructions,
    required Map<T, Object> levels,
  }) : _levelMap = levels,
       _levelList = null;

  /// A Score whose [levels] are the descriptions of its Levels, from the low
  /// end of the scale to the high end. Each description is its own Level.
  const TJevScore.list({
    super.id,
    this.instructions,
    required List<T> levels,
  }) : _levelMap = null,
       _levelList = levels;

  // ⚡️ OVERRIDES

  @override
  TurboResponse<void> validate() {
    final descriptions = _descriptions;
    if (descriptions.isEmpty || descriptions.length > TJevLimits.maxLevels) {
      return TurboResponse.failAsBool(
        message: TJevMessages.levelCount(descriptions.length),
      );
    }
    final wireKeys = <String>{};
    for (final level in _levels) {
      final key = TJevQuestion.wireKey(level);
      if (!wireKeys.add(key)) {
        return TurboResponse.failAsBool(
          message: TJevMessages.duplicateLevelKey(key),
        );
      }
    }
    return TJevQuestion._checkContents([
      (instructions, TJevMessages.instructionsLocation),
      for (final (number, description) in descriptions.indexed)
        (description, TJevMessages.levelDescriptionLocation(number)),
    ]);
  }

  // 🎩 STATE

  /// What to rate.
  final Object? instructions;

  final Map<T, Object>? _levelMap;

  final List<T>? _levelList;

  // 🧲 FETCHERS

  /// Each Level with its description, from the low end of the scale to the
  /// high end.
  ///
  /// A Score needs 1 to 10 Levels, each with its own wire key: the name of
  /// an enum value, else its `toString`.
  Map<T, Object> get levels =>
      _levelMap ?? {for (final level in _levelList!) level: level};

  /// The result of [open] called with this Score typed on its Level type
  /// [T], so what [open] builds keeps [T].
  @internal
  R withLevelType<R>(R Function<L extends Object>(TJevScore<L> score) open) =>
      open<T>(this);

  // 🏗️ HELPERS

  List<T> get _levels => _levelList ?? _levelMap!.keys.toList();

  List<Object> get _descriptions => _levelList ?? _levelMap!.values.toList();
}
