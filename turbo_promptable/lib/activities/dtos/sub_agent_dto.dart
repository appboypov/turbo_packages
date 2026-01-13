import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/roles/dtos/role_dto.dart';

import '../../shared/abstracts/turbo_promptable.dart';
import '../../shared/dtos/meta_data_dto.dart';

part 'sub_agent_dto.g.dart';

/// Represents an agent in the Pew Pew Plaza hierarchy.
///
/// Agents are AI agents with system prompts and available tools.
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class SubAgentDto extends TurboPromptable {
  /// Creates an [SubAgentDto] with the given properties.
  SubAgentDto({
    super.metaData,
    required this.role,
  });

  final RoleDto role;

  static const fromJsonFactory = _$SubAgentDtoFromJson;
  factory SubAgentDto.fromJson(Map<String, dynamic> json) =>
      _$SubAgentDtoFromJson(json);
  static const toJsonFactory = _$SubAgentDtoToJson;
  @override
  Map<String, dynamic> toJsonImpl() => _$SubAgentDtoToJson(this);

  SubAgentDto copyWith({
    MetaDataDto? metaData,
    RoleDto? role,
  }) {
    return SubAgentDto(
      metaData: metaData ?? this.metaData,
      role: role ?? this.role,
    );
  }
}
