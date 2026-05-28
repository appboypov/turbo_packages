import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_tool.dart';

part 't_mcp.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TMcp extends TTool {
  const TMcp({
    required super.name,
    super.description,
    super.abilities,
  });

  factory TMcp.fromJson(Map<String, dynamic> json) => _$TMcpFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TMcpToJson(this);
}
