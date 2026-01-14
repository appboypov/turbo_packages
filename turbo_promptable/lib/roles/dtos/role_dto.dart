import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/roles/dtos/expertise_dto.dart';
import 'package:turbo_promptable/roles/dtos/persona_dto.dart';

import '../../shared/abstracts/turbo_promptable.dart';
import '../../shared/dtos/meta_data_dto.dart';

part 'role_dto.g.dart';

/// Represents a role in the Pew Pew Plaza hierarchy.
///
/// Roles are organizational units within areas and contain knowledge items
/// such as collections, instructions, references, etc.
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class RoleDto extends TurboPromptable {
  /// Creates a [RoleDto] with the given properties.
  RoleDto({
    super.metaData,
    required this.expertise,
    this.persona,
  });

  final PersonaDto? persona;
  final ExpertiseDto expertise;

  static const fromJsonFactory = _$RoleDtoFromJson;
  factory RoleDto.fromJson(Map<String, dynamic> json) =>
      _$RoleDtoFromJson(json);
  static const toJsonFactory = _$RoleDtoToJson;
  @override
  Map<String, dynamic>? toJsonMap() => _$RoleDtoToJson(this);

  RoleDto copyWith({
    MetaDataDto? metaData,
    PersonaDto? persona,
    ExpertiseDto? expertise,
  }) {
    return RoleDto(
      metaData: metaData ?? this.metaData,
      persona: persona ?? this.persona,
      expertise: expertise ?? this.expertise,
    );
  }
}
