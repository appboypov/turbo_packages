import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/activities/dtos/guard_rail_dto.dart';
import 'package:turbo_promptable/workflows/dtos/workflow_step.dart';

import '../../shared/abstracts/turbo_promptable.dart';
import '../../shared/dtos/meta_data_dto.dart';

part 'workflow_dto.g.dart';

/// Represents a workflow in the Pew Pew Plaza hierarchy.
///
/// Workflows are step-by-step processes that describe WHAT to do.
/// Each step can be another [TurboPromptable] object.
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class WorkflowDto extends TurboPromptable {
  /// Creates a [WorkflowDto] with the given properties.
  WorkflowDto({
    super.metaData,
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
  Map<String, dynamic> toJsonImpl() => _$WorkflowDtoToJson(this);

  WorkflowDto copyWith({
    MetaDataDto? metaData,
    List<GuardRailDto>? guardRails,
    List<WorkflowStep>? steps,
  }) {
    return WorkflowDto(
      metaData: metaData ?? this.metaData,
      guardRails: guardRails ?? this.guardRails,
      steps: steps ?? this.steps,
    );
  }
}
