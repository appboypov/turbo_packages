import 'package:json_annotation/json_annotation.dart';

import '../abstracts/t_jev_question_dto.dart';

part 't_jev_choice_question_dto.g.dart';

/// The wire form of a Choice.
@JsonSerializable(createFactory: false, includeIfNull: false)
final class TJevChoiceQuestionDto implements TJevQuestionDto {
  const TJevChoiceQuestionDto({this.instructions, required this.criteria});

  @JsonKey(includeToJson: true)
  String get type => 'choice';

  final Object? instructions;

  /// The description of each Option, keyed by its wire key.
  @JsonKey(includeIfNull: true)
  final Map<String, Object?> criteria;

  @override
  Map<String, dynamic> toJson() => _$TJevChoiceQuestionDtoToJson(this);
}
