import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_instruction.dart';

part 't_convention.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TConvention extends TInstruction {
  TConvention(
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

  factory TConvention.fromJson(Map<String, dynamic> json) =>
      _$TConventionFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TConventionToJson(this);
}
