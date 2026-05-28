import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_instruction.dart';

part 't_skill.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TSkill extends TInstruction {
  TSkill(
    super.name, {
    super.metaData,
    super.principles,
    super.rules,
    super.reasons,
    super.mindset,
    super.approach,
    super.responsibilities,
    super.understandings,
    super.examples,
  });

  factory TSkill.fromJson(Map<String, dynamic> json) => _$TSkillFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TSkillToJson(this);
}
