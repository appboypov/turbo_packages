import 'package:json_annotation/json_annotation.dart';

import '../abstracts/t_jev_question_dto.dart';
import '../enums/t_jev_question_type.dart';

part 't_jev_score_question_dto.g.dart';

/// The wire form of a Score.
@JsonSerializable(createFactory: false, includeIfNull: false)
final class TJevScoreQuestionDto implements TJevQuestionDto {
  const TJevScoreQuestionDto({this.instructions, required this.criteria});

  // ⚡️ OVERRIDES

  @override
  @JsonKey(includeToJson: true)
  TJevQuestionType get type => TJevQuestionType.score;

  @override
  Map<String, dynamic> toJson() => _$TJevScoreQuestionDtoToJson(this);

  // 🎩 STATE

  final Object? instructions;

  /// The description of each Level, in Level order.
  final List<Object> criteria;
}
