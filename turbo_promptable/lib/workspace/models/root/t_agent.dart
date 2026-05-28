import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/turbo_promptable.dart';
import 'package:turbo_promptable/workspace/models/meta/t_spawnable.dart';

part 't_agent.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  genericArgumentFactories: true,
)
class TAgent<IDENTITY extends TRole> extends TSpawnable {
  const TAgent(
    super.name, {
    required super.id,
    super.allowedTools,
    super.yolo = true,
    super.model,
    super.headless = true,
    required this.identity,
    this.workflow,
  });

  final IDENTITY identity;
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

  @override
  String get systemPrompt => identity.toMd();
}
