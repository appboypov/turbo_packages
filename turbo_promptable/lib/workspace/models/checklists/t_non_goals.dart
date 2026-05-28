import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/turbo_promptable.dart';

export 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';

part 't_non_goals.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TNonGoals extends TChecklist {
  const TNonGoals(List<String> items)
    : super(
        name: 'Non Goals',
        items: items,
      );

  factory TNonGoals.fromJson(Map<String, dynamic> json) =>
      _$TNonGoalsFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TNonGoalsToJson(this);
}
