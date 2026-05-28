import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_tool.dart';

part 't_api.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TApi extends TTool {
  const TApi({
    required super.name,
    super.description,
    super.abilities,
  });

  factory TApi.fromJson(Map<String, dynamic> json) => _$TApiFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TApiToJson(this);
}
