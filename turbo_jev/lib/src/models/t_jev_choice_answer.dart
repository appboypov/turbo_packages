part of '../abstracts/t_jev_answer.dart';

/// The Answer of a Choice: the chosen Option and the Probability of every
/// Option.
final class TJevChoiceAnswer<T extends Object> extends TJevAnswer {
  const TJevChoiceAnswer({
    required this.choice,
    required this.probabilities,
    required this.confidence,
  });

  /// The Answer of [dto] to a Choice whose Options [options] keys by their
  /// wire keys, in Option order.
  ///
  /// Throws a [FormatException] when [dto] is no Choice Answer, its
  /// Probabilities are not keyed by exactly the keys of [options] or it
  /// chooses none of them.
  @internal
  factory TJevChoiceAnswer.fromDto(
    TJevChoiceAnswerDto dto, {
    required Map<String, T> options,
  }) {
    TJevAnswer._checkType(dto.type, TJevQuestionType.choice);
    TJevAnswer._checkKeys(
      TJevHttp.probabilitiesKey,
      dto.probabilities.keys,
      options.keys.toList(),
    );
    final choice = options[dto.choice];
    if (choice == null) {
      throw FormatException(TJevMessages.unknownOption(dto.choice));
    }
    return TJevChoiceAnswer(
      choice: choice,
      confidence: dto.confidence,
      probabilities: {
        for (final MapEntry(:key, value: option) in options.entries)
          option: dto.probabilities[key]!,
      },
    );
  }

  /// The Option with the highest Probability.
  final T choice;

  /// The Probability of each Option, in the order of the Choice's Options.
  /// They sum to about 1.
  final Map<T, double> probabilities;

  /// How much of the Probability sits on [choice], from 0 (spread evenly) to
  /// 1 (all on [choice]): `(top - 1/n) / (1 - 1/n)` for `n` Options.
  final double confidence;

  /// The highest Probability of any Option.
  double get topProbability => probabilities.values.reduce(math.max);

  /// How clearly [choice] beats the runner-up: the top Probability divided by
  /// the second highest.
  ///
  /// It is infinite when no other Option has any Probability.
  double get margin {
    var top = 0.0;
    var second = 0.0;
    for (final probability in probabilities.values) {
      if (probability > top) {
        second = top;
        top = probability;
      } else if (probability > second) {
        second = probability;
      }
    }
    return top / second;
  }
}
