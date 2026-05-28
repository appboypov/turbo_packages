import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_tool.dart';

export 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';
export 'package:turbo_promptable/workspace/models/tools/t_tool_ability.dart';

part 't_tool_set.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TToolSet extends TTool {
  const TToolSet({
    required super.name,
    required super.description,
    super.abilities,
  });

  factory TToolSet.fromJson(Map<String, dynamic> json) =>
      _$TToolSetFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TToolSetToJson(this);
}
