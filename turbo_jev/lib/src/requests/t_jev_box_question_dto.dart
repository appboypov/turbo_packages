import 'package:json_annotation/json_annotation.dart';

import '../abstracts/t_jev_question_dto.dart';

part 't_jev_box_question_dto.g.dart';

/// The wire form of a Box.
@JsonSerializable(createFactory: false, includeIfNull: false)
final class TJevBoxQuestionDto implements TJevQuestionDto {
  const TJevBoxQuestionDto({this.instructions});

  @JsonKey(includeToJson: true)
  String get type => 'box';

  final Object? instructions;

  @override
  Map<String, dynamic> toJson() => _$TJevBoxQuestionDtoToJson(this);
}
