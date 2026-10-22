import 'package:json_annotation/json_annotation.dart';

import 't_jev_model_card_dto.dart';

part 't_jev_models_response_dto.g.dart';

/// The wire form of the models list.
@JsonSerializable(checked: true, createToJson: false)
final class TJevModelsResponseDto {
  const TJevModelsResponseDto({required this.models});

  factory TJevModelsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TJevModelsResponseDtoFromJson(json);

  // 🎩 STATE

  /// The models and Model Aliases of the account.
  final List<TJevModelCardDto> models;
}
