import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';

part 't_goal.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TGoal extends TPromptable {
  const TGoal(
    String value, {
    required super.name,
    super.metaData,
  }) : super(
         value: value,
       );

  factory TGoal.fromJson(Map<String, dynamic> json) => _$TGoalFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TGoalToJson(this);
}
