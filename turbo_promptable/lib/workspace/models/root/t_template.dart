import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';

part 't_template.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TTemplate extends TPromptable {
  const TTemplate(
    String name, {
    super.value,
    super.metaData,
  }) : super(name: name);

  factory TTemplate.fromJson(Map<String, dynamic> json) =>
      _$TTemplateFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TTemplateToJson(this);
}
