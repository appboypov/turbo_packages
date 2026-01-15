import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/activities/dtos/guard_rail_dto.dart';
import 'package:turbo_promptable/activities/enums/workflow_step_type.dart';

import '../../shared/abstracts/turbo_promptable.dart';
import '../../shared/dtos/meta_data_dto.dart';

part 'workflow_step.g.dart';

/// Represents a single step within a workflow.
///
/// Workflow steps define individual actions or phases in a process, with
/// optional input/output types, guard rails for validation, and a
/// specific step type that categorizes the action.
@JsonSerializable(
    includeIfNull: true, explicitToJson: true, genericArgumentFactories: true,)
class WorkflowStep<INPUT, OUTPUT> extends TurboPromptable {
  /// Creates a [WorkflowStep] with the given properties.
  WorkflowStep({
    super.metaData,
    required this.workflowStepType,
    this.guardRails,
    this.input,
    this.output,
  });

  /// Optional input data for this workflow step.
  ///
  /// The type parameter [INPUT] defines the structure of the input.
  final INPUT? input;

  /// Optional guard rails that validate or constrain this step's execution.
  ///
  /// Guard rails provide rules and constraints that must be satisfied
  /// before or during step execution.
  final List<GuardRailDto>? guardRails;

  /// Optional output data produced by this workflow step.
  ///
  /// The type parameter [OUTPUT] defines the structure of the output.
  final OUTPUT? output;

  /// The type of workflow step this represents.
  ///
  /// Categorizes the step's purpose (e.g., assess, research, plan, act).
  final WorkflowStepType workflowStepType;

  factory WorkflowStep.fromJson(
    Map<String, dynamic> json,
    INPUT Function(Object? json) fromJsonINPUT,
    OUTPUT Function(Object? json) fromJsonOUTPUT,
  ) =>
      _$WorkflowStepFromJson(json, fromJsonINPUT, fromJsonOUTPUT);

  /// JSON serialization method for generic types.
  /// Requires converters for INPUT and OUTPUT types.
  Map<String, dynamic> toJsonWithConverters(
    Object? Function(INPUT value) toJsonINPUT,
    Object? Function(OUTPUT value) toJsonOUTPUT,
  ) =>
      _$WorkflowStepToJson(this, toJsonINPUT, toJsonOUTPUT);

  @override
  Map<String, dynamic>? toJsonMap() {
    // For generic types, toJsonMap() cannot be implemented without type converters.
    // Use toJsonWithConverters() instead with appropriate converters.
    throw UnimplementedError(
      'WorkflowStep.toJsonMap() requires type converters. Use toJsonWithConverters() instead.',
    );
  }
}
