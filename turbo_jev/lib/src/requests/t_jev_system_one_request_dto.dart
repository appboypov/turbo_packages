import 'package:json_annotation/json_annotation.dart';

import '../abstracts/t_jev_question_dto.dart';

part 't_jev_system_one_request_dto.g.dart';

/// The wire form of a System One Request.
@JsonSerializable(createFactory: false, explicitToJson: true)
final class TJevSystemOneRequestDto {
  const TJevSystemOneRequestDto({
    required this.model,
    required this.state,
    required this.questions,
  });

  final String model;

  final Object state;

  /// The Questions keyed by their ids.
  final Map<String, TJevQuestionDto> questions;

  Map<String, dynamic> toJson() => _$TJevSystemOneRequestDtoToJson(this);
}
