import 'package:json_annotation/json_annotation.dart';

import '../abstracts/t_jev_question_dto.dart';
import '../enums/t_jev_question_type.dart';

part 't_jev_box_question_dto.g.dart';

/// The wire form of a Box.
@JsonSerializable(createFactory: false, includeIfNull: false)
final class TJevBoxQuestionDto implements TJevQuestionDto {
  const TJevBoxQuestionDto({this.instructions});

  // ⚡️ OVERRIDES

  @override
  @JsonKey(includeToJson: true)
  TJevQuestionType get type => TJevQuestionType.box;

  @override
  Map<String, dynamic> toJson() => _$TJevBoxQuestionDtoToJson(this);

  // 🎩 STATE

  final Object? instructions;
}
