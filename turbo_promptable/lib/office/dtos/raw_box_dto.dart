import 'package:json_annotation/json_annotation.dart';

import '../../shared/abstracts/turbo_promptable.dart';

part 'raw_box_dto.g.dart';

/// Represents raw input materials in the Pew Pew Plaza hierarchy.
///
/// Raw Box DTOs contain unprocessed input materials from rawbox folders
/// that will be processed or transformed later.
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class RawBoxDto extends TurboPromptable {
  /// Creates a [RawBoxDto] with the given properties.
  RawBoxDto();

  static const fromJsonFactory = _$RawBoxDtoFromJson;
  factory RawBoxDto.fromJson(Map<String, dynamic> json) =>
      _$RawBoxDtoFromJson(json);
  static const toJsonFactory = _$RawBoxDtoToJson;
  @override
  Map<String, dynamic> toJson() => _$RawBoxDtoToJson(this);

  RawBoxDto copyWith() {
    return RawBoxDto();
  }

  @override
  String toString() => 'RawBoxDto()';
}
