import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/spawn/abstracts/t_agent_bound.dart';
import 'package:turbo_promptable/spawn/dtos/t_spawn_config_dto.dart';
import 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';

part 't_issue.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TIssue extends TPromptable implements TAgentBound {
  const TIssue({
    required this.id,
    required super.name,
    super.metaData,
    this.agentId,
    this.spawnConfig,
  });

  @override
  final String id;

  @override
  final String? agentId;

  @override
  @JsonKey(includeToJson: false)
  final TSpawnConfigDto? spawnConfig;

  factory TIssue.fromJson(Map<String, dynamic> json) => _$TIssueFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TIssueToJson(this);
}
