import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_tool.dart';

part 't_cli.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TCli extends TTool {
  const TCli({
    required super.name,
    super.description,
    super.abilities,
  });

  factory TCli.fromJson(Map<String, dynamic> json) => _$TCliFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TCliToJson(this);
}
