import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/turbo_promptable.dart';

part 'api_dto.g.dart';

/// Represents an HTTP/REST API tool.
///
/// Extends [TurboPromptable] with API-specific functionality.
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class ApiDto extends TurboPromptable {
  /// Creates an [ApiDto] with the given properties.
  ApiDto();

  static const fromJsonFactory = _$ApiDtoFromJson;
  factory ApiDto.fromJson(Map<String, dynamic> json) => _$ApiDtoFromJson(json);
  static const toJsonFactory = _$ApiDtoToJson;
  @override
  Map<String, dynamic> toJson() => _$ApiDtoToJson(this);

  ApiDto copyWith() {
    return ApiDto();
  }

  @override
  String toString() => 'ApiDto()';
}
