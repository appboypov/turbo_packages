import 'package:json_annotation/json_annotation.dart';

import '../../roles/dtos/role_dto.dart';
import '../../shared/abstracts/turbo_promptable.dart';
import '../../shared/dtos/meta_data_dto.dart';

part 'area_dto.g.dart';

/// Represents an area in the Pew Pew Plaza hierarchy.
///
/// Areas are organizational units within teams and contain [roles].
/// Configuration cascades down to child roles and their knowledge items.
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class AreaDto extends TurboPromptable {
  /// Creates an [AreaDto] with the given properties.
  AreaDto({
    this.roles,
  });

  /// The roles within this area.
  final List<RoleDto>? roles;

  static const fromJsonFactory = _$AreaDtoFromJson;
  factory AreaDto.fromJson(Map<String, dynamic> json) => _$AreaDtoFromJson(json);
  static const toJsonFactory = _$AreaDtoToJson;
  @override
  Map<String, dynamic> toJson() => _$AreaDtoToJson(this);

  @override
  String toString() => 'AreaDto{roles: $roles}';

  AreaDto copyWith({
    MetaDataDto? metaData,
    List<RoleDto>? roles,
  }) =>
      AreaDto(
        roles: roles ?? this.roles,
      );
}
