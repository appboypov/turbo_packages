import 'package:json_annotation/json_annotation.dart';

import '../enums/t_jev_question_type.dart';

part 't_jev_choice_answer_dto.g.dart';

/// The wire form of the Answer of a Choice.
@JsonSerializable(createToJson: false, checked: true)
final class TJevChoiceAnswerDto {
  const TJevChoiceAnswerDto({
    required this.type,
    required this.choice,
    required this.confidence,
    required this.probabilities,
  });

  factory TJevChoiceAnswerDto.fromJson(Map<String, dynamic> json) =>
      _$TJevChoiceAnswerDtoFromJson(json);

  // 🎩 STATE

  final TJevQuestionType type;

  /// The wire key of the chosen Option.
  final String choice;

  final double confidence;

  /// The Probability of each Option, keyed by its wire key.
  final Map<String, double> probabilities;
}
