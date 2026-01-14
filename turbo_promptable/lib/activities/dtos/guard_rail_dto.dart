import 'package:json_annotation/json_annotation.dart';

import '../../shared/abstracts/turbo_promptable.dart';
import '../../shared/dtos/meta_data_dto.dart';

part 'guard_rail_dto.g.dart';

/// Represents a guard rail in the Pew Pew Plaza hierarchy.
///
/// Guard rails provide rules and constraints that must be satisfied
/// during workflow step execution or agent behavior.
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class GuardRailDto extends TurboPromptable {
  /// Creates a [GuardRailDto] with the given properties.
  GuardRailDto({
    super.metaData,
  });

  static const fromJsonFactory = _$GuardRailDtoFromJson;
  factory GuardRailDto.fromJson(Map<String, dynamic> json) =>
      _$GuardRailDtoFromJson(json);
  static const toJsonFactory = _$GuardRailDtoToJson;
  @override
  Map<String, dynamic>? toJsonMap() => _$GuardRailDtoToJson(this);

  GuardRailDto copyWith({
    MetaDataDto? metaData,
  }) {
    return GuardRailDto(
      metaData: metaData ?? this.metaData,
    );
  }
}
