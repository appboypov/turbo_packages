import 'package:json_annotation/json_annotation.dart';

/// The type of a Question, sent as the `type` of the Question and of its
/// Answer.
@JsonEnum(valueField: 'wireValue')
enum TJevQuestionType {
  /// A Noul, answered with the Probability that a statement is true.
  noul('noul'),

  /// A Choice, answered with one Option from a defined set.
  choice('choice'),

  /// A Score, answered with a place on ordered Levels.
  score('score'),

  /// A Box, answered with one region in an Image.
  box('box');

  const TJevQuestionType(this.wireValue);

  // 🎩 STATE

  /// The value of the type on the wire.
  final String wireValue;
}
