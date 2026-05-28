import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_input.dart';
import 'package:turbo_promptable/workspace/models/root/t_instruction.dart';
import 'package:turbo_promptable/workspace/models/root/t_output.dart';

part 't_step.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TStep extends TPromptable {
  const TStep({
    required super.name,
    super.metaData,
    required this.input,
    required this.instructions,
    required this.output,
  });

  final TInput input;
  final String? instructions;
  final TOutput output;

  factory TStep.fromJson(Map<String, dynamic> json) => _$TStepFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TStepToJson(this);
}
