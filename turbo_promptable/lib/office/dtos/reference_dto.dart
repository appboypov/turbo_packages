import 'package:json_annotation/json_annotation.dart';

import '../../shared/abstracts/turbo_promptable.dart';
import '../../shared/dtos/meta_data_dto.dart';

part 'reference_dto.g.dart';

/// Represents a reference in the Pew Pew Plaza hierarchy.
///
/// References are static documentation, API docs, or saved content
/// that provide context and information to agents.
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class ReferenceDto extends TurboPromptable {
  /// Creates a [ReferenceDto] with the given properties.
  ReferenceDto();

  static const fromJsonFactory = _$ReferenceDtoFromJson;
  factory ReferenceDto.fromJson(Map<String, dynamic> json) =>
      _$ReferenceDtoFromJson(json);
  static const toJsonFactory = _$ReferenceDtoToJson;
  @override
  Map<String, dynamic> toJson() => _$ReferenceDtoToJson(this);

  ReferenceDto copyWith() {
    return ReferenceDto();
  }

  @override
  String toString() => 'ReferenceDto()';
}
