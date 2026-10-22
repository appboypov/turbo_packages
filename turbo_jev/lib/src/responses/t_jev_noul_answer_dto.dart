import 'package:json_annotation/json_annotation.dart';

import '../enums/t_jev_question_type.dart';

part 't_jev_noul_answer_dto.g.dart';

/// The wire form of the Answer of a Noul.
@JsonSerializable(createToJson: false, checked: true)
final class TJevNoulAnswerDto {
  const TJevNoulAnswerDto({required this.type, required this.noul});

  factory TJevNoulAnswerDto.fromJson(Map<String, dynamic> json) =>
      _$TJevNoulAnswerDtoFromJson(json);

  final TJevQuestionType type;

  /// The Probability that the statement is true.
  final double noul;
}
