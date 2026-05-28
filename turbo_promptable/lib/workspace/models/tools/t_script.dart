import 'package:json_annotation/json_annotation.dart';

import 'package:turbo_promptable/workspace/models/root/t_tool.dart';

part 't_script.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TScript extends TTool {
  const TScript({
    required super.name,
    super.description,
    super.abilities,
  });

  factory TScript.fromJson(Map<String, dynamic> json) =>
      _$TScriptFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TScriptToJson(this);
}
