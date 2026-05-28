import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/turbo_promptable.dart';

export 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';

part 't_constraints.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TConstraints extends TChecklist {
  const TConstraints(List<String> items)
    : super(
        name: 'TConstraints',
        items: items,
      );

  factory TConstraints.fromJson(Map<String, dynamic> json) =>
      _$TConstraintsFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TConstraintsToJson(this);
}
