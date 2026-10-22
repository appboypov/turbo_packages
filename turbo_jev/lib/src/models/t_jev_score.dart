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

  /// What to rate.
  final Object? instructions;

  final Map<T, Object>? _levelMap;

  final List<T>? _levelList;

  /// Each Level with its description, from the low end of the scale to the
  /// high end.
  ///
  /// A Score needs 1 to 10 Levels.
  Map<T, Object> get levels =>
      _levelMap ?? {for (final level in _levelList!) level: level};

  List<T> get _levels => _levelList ?? _levelMap!.keys.toList();

  List<Object> get _descriptions => _levelList ?? _levelMap!.values.toList();

  @override
  TJevScoreQuestionDto toDto({required String id}) {
    final descriptions = _descriptions;
    if (descriptions.isEmpty || descriptions.length > TJevLimits.maxLevels) {
      throw TJevInvalidQuestionException(
        reason:
            'Score $id needs 1 to ${TJevLimits.maxLevels} Levels, '
            'not ${descriptions.length}.',
      );
    }
    final levelList = _levelList;
    if (levelList != null && levelList.toSet().length != levelList.length) {
      throw TJevInvalidQuestionException(
        reason: 'Two Levels of Score $id are equal.',
      );
    }
    TJevQuestion._checkContent(instructions, 'The Instructions of Score $id');
    for (final (number, description) in descriptions.indexed) {
      TJevQuestion._checkContent(
        description,
        'The description of Level $number of Score $id',
      );
    }
    return TJevScoreQuestionDto(
      instructions: instructions,
      criteria: descriptions,
    );
  }

  @override
  TJevScoreAnswer<T> answerFromJson(Map<String, dynamic> json) {
    final dto = TJevScoreAnswerDto.fromJson(json);
    TJevQuestion._checkAnswerType(dto.type, 'score');
    final levels = _levels;
    final levelNumbers = [
      for (var number = 0; number < levels.length; number++) '$number',
    ];
    TJevQuestion._checkKeys('legend', dto.legend.keys, levelNumbers);
    TJevQuestion._checkKeys(
      'probabilities',
      dto.probabilities.keys,
      levelNumbers,
    );
    return TJevScoreAnswer(
      score: dto.score,
      confidence: dto.confidence,
      probabilities: {
        for (final (number, level) in levels.indexed)
          level: dto.probabilities['$number']!,
      },
      legend: {
        for (final (number, level) in levels.indexed)
          level: dto.legend['$number'],
      },
    );
  }
}
