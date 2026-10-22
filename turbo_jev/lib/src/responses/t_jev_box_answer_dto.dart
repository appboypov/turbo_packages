import 'package:json_annotation/json_annotation.dart';

import '../enums/t_jev_question_type.dart';
import 't_jev_box_coordinates_dto.dart';

part 't_jev_box_answer_dto.g.dart';

/// The wire form of the Answer of a Box.
@JsonSerializable(createToJson: false, checked: true)
final class TJevBoxAnswerDto {
  const TJevBoxAnswerDto({
    required this.type,
    required this.box,
    required this.confidence,
  });

  factory TJevBoxAnswerDto.fromJson(Map<String, dynamic> json) =>
      _$TJevBoxAnswerDtoFromJson(json);

  // 🎩 STATE

  final TJevQuestionType type;

  final TJevBoxCoordinatesDto box;

  final double? confidence;
}
