part of '../abstracts/t_jev_answer.dart';

/// The Answer of a Box: the edges of the smallest region that holds what it
/// looks for, as fractions of the Image measured from its top-left corner.
final class TJevBoxAnswer extends TJevAnswer {
  const TJevBoxAnswer({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
    required this.confidence,
  });

  /// The top edge, as a fraction of the Image's height from 0 to 1.
  final double top;

  /// The bottom edge, as a fraction of the Image's height from 0 to 1.
  final double bottom;

  /// The left edge, as a fraction of the Image's width from 0 to 1.
  final double left;

  /// The right edge, as a fraction of the Image's width from 0 to 1.
  final double right;

  /// How sure Jev is of the region, from 0 to 1, or null when the model
  /// gives none.
  final double? confidence;
}
