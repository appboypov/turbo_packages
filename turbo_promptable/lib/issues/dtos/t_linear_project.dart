import 'package:json_annotation/json_annotation.dart';

part 't_linear_project.g.dart';

/// Project a Linear issue belongs to.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TLinearProjectDto {
  const TLinearProjectDto({
    required this.name,
  });

  final String name;

  factory TLinearProjectDto.fromJson(Map<String, dynamic> json) =>
      _$TLinearProjectDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TLinearProjectDtoToJson(this);
}
