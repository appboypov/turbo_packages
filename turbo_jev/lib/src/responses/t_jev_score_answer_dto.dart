import 'package:json_annotation/json_annotation.dart';

import '../enums/t_jev_question_type.dart';

part 't_jev_score_answer_dto.g.dart';

/// The wire form of the Answer of a Score.
@JsonSerializable(createToJson: false, checked: true)
final class TJevScoreAnswerDto {
  const TJevScoreAnswerDto({
    required this.type,
    required this.score,
    required this.confidence,
    required this.legend,
    required this.probabilities,
  });

  factory TJevScoreAnswerDto.fromJson(Map<String, dynamic> json) =>
      _$TJevScoreAnswerDtoFromJson(json);

  // 🎩 STATE

  final TJevQuestionType type;

  final double score;

  final double confidence;

  /// The description of each Level, keyed by its Level number as a string.
  final Map<String, Object?> legend;

  /// The Probability of each Level, keyed by its Level number as a string.
  final Map<String, double> probabilities;
}
