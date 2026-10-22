import 'package:json_annotation/json_annotation.dart';

import '../abstracts/t_jev_question_dto.dart';
import '../enums/t_jev_question_type.dart';
import 't_jev_noul_criteria_dto.dart';

part 't_jev_noul_question_dto.g.dart';

/// The wire form of a Noul.
@JsonSerializable(
  createFactory: false,
  includeIfNull: false,
  explicitToJson: true,
)
final class TJevNoulQuestionDto implements TJevQuestionDto {
  const TJevNoulQuestionDto({this.instructions, this.criteria});

  // ⚡️ OVERRIDES

  @override
  @JsonKey(includeToJson: true)
  TJevQuestionType get type => TJevQuestionType.noul;

  @override
  Map<String, dynamic> toJson() => _$TJevNoulQuestionDtoToJson(this);

  // 🎩 STATE

  final Object? instructions;

  final TJevNoulCriteriaDto? criteria;
}
