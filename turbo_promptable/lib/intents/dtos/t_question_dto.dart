import 'package:json_annotation/json_annotation.dart';

part 't_question_dto.g.dart';

/// A question about what the user wants, with its answer once given.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TQuestionDto {
  const TQuestionDto({required this.question, this.answer});

  /// The question, in plain words.
  final String question;

  /// The user's answer; null while the question is open.
  final String? answer;

  factory TQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$TQuestionDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TQuestionDtoToJson(this);
}
