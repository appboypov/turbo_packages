import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/activities/dtos/guard_rail_dto.dart';
import 'package:turbo_promptable/workflows/dtos/workflow_step.dart';

import '../../shared/abstracts/turbo_promptable.dart';

part 'workflow_dto.g.dart';

/// Represents a workflow in the Pew Pew Plaza hierarchy.
///
/// Workflows are step-by-step processes that describe WHAT to do.
/// Each step can be another [TurboPromptable] object.
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class WorkflowDto extends TurboPromptable {
  /// Creates a [WorkflowDto] with the given properties.
  WorkflowDto({
    this.guardRails,
    required this.steps,
  });

  final List<GuardRailDto>? guardRails;
  final List<WorkflowStep> steps;

  static const fromJsonFactory = _$WorkflowDtoFromJson;
  factory WorkflowDto.fromJson(Map<String, dynamic> json) =>
      _$WorkflowDtoFromJson(json);
  static const toJsonFactory = _$WorkflowDtoToJson;
  @override
  Map<String, dynamic> toJson() => _$WorkflowDtoToJson(this);

  WorkflowDto copyWith({
    List<GuardRailDto>? guardRails,
    List<WorkflowStep>? steps,
  }) {
    return WorkflowDto(
      guardRails: guardRails ?? this.guardRails,
      steps: steps ?? this.steps,
    );
  }

  @override
  String toString() => 'WorkflowDto{guardRails: $guardRails, steps: $steps}';
}
