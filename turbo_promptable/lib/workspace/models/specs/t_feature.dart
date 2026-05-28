import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_projects.dart';
import 'package:turbo_promptable/workspace/models/root/t_spec.dart';

part 't_feature.g.dart';

/// A user-facing feature scoped to one or more projects.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TFeature extends TSpec implements TOfProjects {
  const TFeature({
    required super.name,
    super.metaData,
    required this.projectIds,
  });

  @override
  final List<String> projectIds;

  factory TFeature.fromJson(Map<String, dynamic> json) =>
      _$TFeatureFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TFeatureToJson(this);
}
