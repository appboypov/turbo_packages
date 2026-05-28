import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';
import 'package:turbo_promptable/workspace/models/root/t_template.dart';

export 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';

part 't_instruction.g.dart';

/// Behavioural guidance containing [principles], [rules], [mindset], and [examples].
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TInstruction extends TPromptable {
  const TInstruction(
    String name, {
    super.metaData,
    this.principles,
    this.rules,
    this.reasons,
    this.mindset,
    this.approach,
    this.responsibilities,
    this.understandings,
    this.examples,
    this.template,
    this.child,
    this.children,
  }) : super(
         name: name,
       );

  final List<String>? principles;
  final List<String>? rules;
  final List<String>? reasons;
  final List<String>? mindset;
  final List<String>? approach;
  final List<String>? responsibilities;
  final List<String>? understandings;
  final List<String>? examples;
  final TTemplate? template;
  final TInstruction? child;
  final List<TInstruction>? children;

  factory TInstruction.fromJson(Map<String, dynamic> json) =>
      _$TInstructionFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TInstructionToJson(this);
}
