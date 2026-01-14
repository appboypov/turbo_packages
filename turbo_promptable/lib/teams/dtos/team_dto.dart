import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/roles/dtos/role_dto.dart';

import '../../shared/abstracts/turbo_promptable.dart';
import '../../shared/dtos/meta_data_dto.dart';
import '../../areas/dtos/area_dto.dart';

part 'team_dto.g.dart';

/// Represents a team in the Pew Pew Plaza hierarchy.
///
/// Teams are the top-level organizational unit and contain [areas].
/// Configuration cascades down to child areas and their roles.
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class TeamDto extends TurboPromptable {
  /// Creates a [TeamDto] with the given properties.
  TeamDto({
    super.metaData,
    this.areas,
    this.roles,
  });

  /// The areas within this team.
  final List<AreaDto>? areas;

  /// The roles directly under this team.
  final List<RoleDto>? roles;

  static const fromJsonFactory = _$TeamDtoFromJson;
  factory TeamDto.fromJson(Map<String, dynamic> json) =>
      _$TeamDtoFromJson(json);
  static const toJsonFactory = _$TeamDtoToJson;
  @override
  Map<String, dynamic>? toJsonMap() => _$TeamDtoToJson(this);

  TeamDto copyWith({
    MetaDataDto? metaData,
    List<AreaDto>? areas,
    List<RoleDto>? roles,
  }) {
    return TeamDto(
      metaData: metaData ?? this.metaData,
      areas: areas ?? this.areas,
      roles: roles ?? this.roles,
    );
  }
}
