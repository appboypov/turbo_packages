import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/checklists/t_acceptance_criteria.dart';
import 'package:turbo_promptable/workspace/models/checklists/t_constraints.dart';
import 'package:turbo_promptable/workspace/models/root/t_goal.dart';

part 't_end_goal.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TEndGoal extends TGoal {
  const TEndGoal(
    super.value, {
    required super.name,
    this.acceptanceCriteria,
    this.constraints,
    super.metaData,
  });

  final TAcceptanceCriteria? acceptanceCriteria;
  final TConstraints? constraints;

  factory TEndGoal.fromJson(Map<String, dynamic> json) =>
      _$TEndGoalFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TEndGoalToJson(this);
}
