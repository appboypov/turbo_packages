import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_tool_set.dart';

export 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';
export 'package:turbo_promptable/workspace/models/tools/t_tool_ability.dart';

part 't_tool.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TTool extends TPromptable {
  const TTool({
    required super.name,
    required super.description,
    this.abilities,
  });

  final List<TToolAbility>? abilities;

  factory TTool.fromJson(Map<String, dynamic> json) => _$TToolFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TToolToJson(this);

  TToolSet asToolSet({
    String? name,
    String? description,
    List<TToolAbility> Function(List<TToolAbility> abilities)? abilities,
  }) => TToolSet(
    description: description ?? this.description,
    name: name ?? this.name,
    abilities: abilities != null && this.abilities != null
        ? abilities(this.abilities!)
        : this.abilities,
  );
}
