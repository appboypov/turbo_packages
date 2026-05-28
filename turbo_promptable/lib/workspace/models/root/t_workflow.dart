import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/turbo_promptable.dart';
import 'package:turbo_promptable/workspace/models/root/t_tool_set.dart';

part 't_workflow.g.dart';

/// An ordered sequence of [TStep]s that define a process.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TWorkflow extends TPromptable {
  const TWorkflow({
    required super.name,
    super.metaData,
    required this.steps,
    required this.endGoal,
    this.instructions,
    this.tools,
    this.toolSets,
  });

  final List<TStep> steps;
  final TEndGoal endGoal;
  final List<TInstruction>? instructions;
  final List<TTool>? tools;
  final List<TToolSet>? toolSets;

  factory TWorkflow.fromJson(Map<String, dynamic> json) =>
      _$TWorkflowFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TWorkflowToJson(this);
}
