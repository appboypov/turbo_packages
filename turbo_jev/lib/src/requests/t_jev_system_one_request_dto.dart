import 'package:json_annotation/json_annotation.dart';

import '../abstracts/t_jev_question_dto.dart';
import '../converters/t_jev_model_converter.dart';
import '../types/t_jev_model.dart';

part 't_jev_system_one_request_dto.g.dart';

/// The wire form of a System One Request, apart from the Images it sends in
/// a `TJevSystemOneAssetsDto`.
@JsonSerializable(
  createFactory: false,
  includeIfNull: false,
  explicitToJson: true,
)
final class TJevSystemOneRequestDto {
  const TJevSystemOneRequestDto({
    required this.model,
    required this.state,
    required this.questions,
  });

  // 🎩 STATE

  @TJevModelConverter()
  final TJevModel model;

  final Object state;

  /// The Questions keyed by their ids.
  final Map<String, TJevQuestionDto> questions;

  // 🧲 FETCHERS

  Map<String, dynamic> toJson() => _$TJevSystemOneRequestDtoToJson(this);
}
