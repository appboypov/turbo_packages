import 'package:json_annotation/json_annotation.dart';

import 't_jev_usage_dto.dart';

part 't_jev_system_one_response_dto.g.dart';

/// The wire form of a System One response.
@JsonSerializable(createToJson: false, checked: true)
final class TJevSystemOneResponseDto {
  const TJevSystemOneResponseDto({
    required this.model,
    required this.answers,
    required this.usage,
  });

  factory TJevSystemOneResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TJevSystemOneResponseDtoFromJson(json);

  /// The resolved model, which may differ from the Model Alias sent.
  final String model;

  /// The wire form of each Answer, keyed by its Question id.
  final Map<String, Map<String, dynamic>> answers;

  final TJevUsageDto usage;
}
