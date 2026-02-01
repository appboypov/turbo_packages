import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/abstracts/has_to_json.dart';
import 'package:turbo_promptable/activities/dtos/instruction_dto.dart';
import 'package:turbo_promptable/activities/dtos/sub_agent_dto.dart';
import 'package:turbo_promptable/workflows/dtos/workflow_dto.dart';

import '../../shared/abstracts/turbo_promptable.dart';

part 'activity_dto.g.dart';

/// Represents an activity (AI command) in the Pew Pew Plaza hierarchy.
///
/// Activities are AI commands that agents can execute.
@JsonSerializable(
  includeIfNull: true,
  explicitToJson: true,
  genericArgumentFactories: true,
)
class ActivityDto<INPUT extends HasToJson, OUTPUT extends HasToJson>
    extends TurboPromptable {
  /// Creates an [ActivityDto] with the given properties.
  ActivityDto({
    required this.output,
    required this.workflow,
    this.input,
    this.instructions,
    this.subAgents,
  });

  final INPUT? input;
  final List<InstructionDto>? instructions;
  final List<SubAgentDto>? subAgents;
  final OUTPUT? output;
  final WorkflowDto workflow;

  static const fromJsonFactory = _$ActivityDtoFromJson;
  factory ActivityDto.fromJson(
    Map<String, dynamic> json,
    INPUT Function(Object? json) fromJsonINPUT,
    OUTPUT Function(Object? json) fromJsonOUTPUT,
  ) => _$ActivityDtoFromJson(
    json,
    fromJsonINPUT,
    fromJsonOUTPUT,
  );
  static const toJsonFactory = _$ActivityDtoToJson;
  @override
  Map<String, dynamic> toJson() => _$ActivityDtoToJson(
    this,
    (value) => value.toJson(),
    (value) => value.toJson(),
  );

  @override
  String toString() =>
      'ActivityDto{input: $input, instructions: $instructions, subAgents: $subAgents, output: $output, workflow: $workflow}';
}
