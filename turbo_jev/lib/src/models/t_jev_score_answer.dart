part of '../abstracts/t_jev_answer.dart';

/// The Answer of a Score: the State's position on the Levels and the
/// Probability of every Level.
final class TJevScoreAnswer<T extends Object> extends TJevAnswer {
  const TJevScoreAnswer({
    required this.score,
    required this.probabilities,
    required this.confidence,
    required this.legend,
  });

  /// The Probability-weighted mean of the Level numbers, from 0 to the top
  /// Level number. It can fall between two Levels.
  final double score;

  /// The Probability of each Level, in Level order. They sum to about 1.
  final Map<T, double> probabilities;

  /// How much of the Probability sits on and near [mostLikelyLevel], from 0
  /// (spread at least as evenly as over all Levels) to 1 (all on one Level).
  final double confidence;

  /// The description of each Level as Jev read it, in Level order.
  final Map<T, Object?> legend;

  /// [score] divided by the top Level number, from 0 to 1, so Scores with
  /// different numbers of Levels compare.
  ///
  /// It is 0 for a Score with one Level.
  double get normalizedScore {
    final topLevelNumber = probabilities.length - 1;
    return topLevelNumber == 0 ? 0 : score / topLevelNumber;
  }

  /// The Level with the highest Probability; the lowest such Level on a tie.
  T get mostLikelyLevel {
    late T mostLikely;
    var highest = double.negativeInfinity;
    for (final MapEntry(key: level, value: probability)
        in probabilities.entries) {
      if (probability > highest) {
        highest = probability;
        mostLikely = level;
      }
    }
    return mostLikely;
  }
}
