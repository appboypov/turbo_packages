import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/turbo_promptable.dart';


part 'api_dto.g.dart';

/// Represents an HTTP/REST API tool.
///
/// Extends [TurboPromptable] with API-specific functionality.
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class ApiDto extends TurboPromptable {
  /// Creates an [ApiDto] with the given properties.
  ApiDto({
    super.metaData,
  });

  static const fromJsonFactory = _$ApiDtoFromJson;
  factory ApiDto.fromJson(Map<String, dynamic> json) => _$ApiDtoFromJson(json);
  static const toJsonFactory = _$ApiDtoToJson;
  @override
  Map<String, dynamic>? toJsonMap() => _$ApiDtoToJson(this);

  ApiDto copyWith({
    MetaDataDto? metaData,
  }) {
    return ApiDto(
      metaData: metaData ?? this.metaData,
    );
  }
}
