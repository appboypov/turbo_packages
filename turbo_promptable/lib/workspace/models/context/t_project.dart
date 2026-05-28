import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_context.dart';

part 't_project.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TProject extends TContext {
  const TProject({
    required super.name,
  });

  factory TProject.fromJson(Map<String, dynamic> json) =>
      _$TProjectFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TProjectToJson(this);
}
