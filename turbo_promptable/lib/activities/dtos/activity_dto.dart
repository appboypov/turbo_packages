import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/activities/dtos/instruction_dto.dart';
import 'package:turbo_promptable/activities/dtos/sub_agent_dto.dart';
import 'package:turbo_promptable/workflows/dtos/workflow_dto.dart';

import '../../shared/abstracts/turbo_promptable.dart';
import '../../shared/dtos/meta_data_dto.dart';

part 'activity_dto.g.dart';

/// Represents an activity (AI command) in the Pew Pew Plaza hierarchy.
///
/// Activities are AI commands that agents can execute.
@JsonSerializable(
    includeIfNull: true, explicitToJson: true, genericArgumentFactories: true,)
class ActivityDto<INPUT, OUTPUT> extends TurboPromptable {
  /// Creates an [ActivityDto] with the given properties.
  ActivityDto({
    super.metaData,
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

  factory ActivityDto.fromJson(
    Map<String, dynamic> json,
    INPUT Function(Object? json) fromJsonINPUT,
    OUTPUT Function(Object? json) fromJsonOUTPUT,
  ) =>
      _$ActivityDtoFromJson(json, fromJsonINPUT, fromJsonOUTPUT);

  /// JSON serialization method for generic types.
  /// Requires converters for INPUT and OUTPUT types.
  Map<String, dynamic> toJsonWithConverters(
    Object? Function(INPUT value) toJsonINPUT,
    Object? Function(OUTPUT value) toJsonOUTPUT,
  ) =>
      _$ActivityDtoToJson(this, toJsonINPUT, toJsonOUTPUT);

  @override
  Map<String, dynamic>? toJsonMap() {
    // For generic types, toJsonMap() cannot be implemented without type converters.
    // Use toJsonWithConverters() instead with appropriate converters.
    throw UnimplementedError(
      'ActivityDto.toJsonMap() requires type converters. Use toJsonWithConverters() instead.',
    );
  }
}
