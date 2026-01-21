import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/abstracts/has_to_json.dart';
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
  includeIfNull: true,
  explicitToJson: true,
  genericArgumentFactories: true,
)
class ActivityDto<INPUT extends HasToJson, OUTPUT extends HasToJson> extends TurboPromptable {
  /// Creates an [ActivityDto] with the given properties.
  ActivityDto({
    super.metaData,
    required this.output,
    required this.workflow,
    this.input,
    this.instructions,
    this.subAgents,
  });

  @JsonKey(toJson: _toJsonINPUT, fromJson: _fromJsonINPUT)
  final INPUT? input;
  final List<InstructionDto>? instructions;
  final List<SubAgentDto>? subAgents;
  @JsonKey(toJson: _toJsonOUTPUT, fromJson: _fromJsonOUTPUT)
  final OUTPUT? output;
  final WorkflowDto workflow;

  static const fromJsonFactory = _$ActivityDtoFromJson;
  factory ActivityDto.fromJson(Map<String, dynamic> json) => _$ActivityDtoFromJson(json);
  static const toJsonFactory = _$ActivityDtoToJson;
  @override
  Map<String, dynamic> toJson() => _$ActivityDtoToJson(this);

  static INPUT? _fromJsonINPUT<INPUT>(
    Object? json,
    INPUT Function(Object? json) fromJson,
  ) =>
      json == null ? null : fromJson(json);

  static Object? _toJsonINPUT<INPUT>(
    INPUT? input,
    Object? Function(INPUT value) toJson,
  ) =>
      input == null ? null : toJson(input);

  static OUTPUT? _fromJsonOUTPUT<OUTPUT>(
    Object? json,
    OUTPUT Function(Object? json) fromJson,
  ) =>
      json == null ? null : fromJson(json);

  static Object? _toJsonOUTPUT<OUTPUT>(
    OUTPUT? output,
    Object? Function(OUTPUT value) toJson,
  ) =>
      output == null ? null : toJson(output);

}
