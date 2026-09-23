import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/spawn/dtos/t_spawn_config_dto.dart';
import 'package:turbo_promptable/spawn/enums/t_session_app.dart';
import 'package:turbo_promptable/spawn/enums/t_spawn_concept.dart';

part 't_resolved_spawn_dto.g.dart';

/// Everything plx needs to start one session, read from code.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TResolvedSpawnDto {
  const TResolvedSpawnDto({
    required this.concept,
    required this.id,
    required this.filePath,
    required this.config,
    required this.sessionApp,
    this.agentId,
    this.firstMessage,
  });

  final TSpawnConcept concept;

  /// Id of the spawned entity.
  final String id;

  /// Absolute path of the file that declares the spawned entity.
  final String filePath;

  /// Merged spawn config: role, then agent, then task or issue.
  final TSpawnConfigDto config;

  final TSessionApp sessionApp;

  /// Agent the session runs as; null for a role spawn.
  final String? agentId;

  final String? firstMessage;

  factory TResolvedSpawnDto.fromJson(Map<String, dynamic> json) =>
      _$TResolvedSpawnDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TResolvedSpawnDtoToJson(this);
}
