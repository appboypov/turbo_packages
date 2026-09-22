import 'package:json_annotation/json_annotation.dart';

part 't_linear_project_milestone.g.dart';

/// Project milestone a Linear issue belongs to.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TLinearProjectMilestoneDto {
  const TLinearProjectMilestoneDto({
    required this.name,
  });

  final String name;

  factory TLinearProjectMilestoneDto.fromJson(Map<String, dynamic> json) =>
      _$TLinearProjectMilestoneDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TLinearProjectMilestoneDtoToJson(this);
}
