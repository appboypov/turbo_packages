import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/turbo_promptable.dart';

part 't_agent.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  genericArgumentFactories: true,
)
class TAgent<IDENTITY extends TRole> extends TPromptable implements TSpawnable {
  const TAgent(
    String name, {
    required this.id,
    required this.identity,
    this.spawnConfig,
    this.workflow,
  }) : super(name: name);

  @override
  final String id;

  /// Role of this agent; its prompt is the default system prompt.
  final IDENTITY identity;

  @override
  @JsonKey(includeToJson: false)
  final TSpawnConfigDto? spawnConfig;

  final TWorkflow? workflow;

  factory TAgent.fromJson(
    Map<String, dynamic> json,
    IDENTITY Function(Object? json) fromJsonIdentity,
  ) => _$TAgentFromJson(json, fromJsonIdentity);

  @override
  Map<String, dynamic> toJson() => _$TAgentToJson(
    this,
    (IDENTITY identity) => identity.toJson(),
  );
}
