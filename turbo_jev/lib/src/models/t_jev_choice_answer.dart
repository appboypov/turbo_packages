part of '../abstracts/t_jev_answer.dart';

/// The Answer of a Choice: the chosen Option and the Probability of every
/// Option.
final class TJevChoiceAnswer<T extends Object> extends TJevAnswer {
  const TJevChoiceAnswer({
    required this.choice,
    required this.probabilities,
    required this.confidence,
  });

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
