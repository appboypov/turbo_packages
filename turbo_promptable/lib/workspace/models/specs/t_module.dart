import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_projects.dart';
import 'package:turbo_promptable/workspace/models/root/t_spec.dart';

part 't_module.g.dart';

/// A logical module that groups related functionality within a project.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TModule extends TSpec implements TOfProjects {
  const TModule({
    required super.name,
    super.metaData,
    required this.projectIds,
  });

  @override
  final List<String> projectIds;

  factory TModule.fromJson(Map<String, dynamic> json) =>
      _$TModuleFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TModuleToJson(this);
}
